//
//  PageContainerController.swift
//  PageControllerContainer
//
//  Created by Vyacheslav Vakulenko on 11.05.2022.
//

import UIKit
import PinLayout

public final class DVPageContainerViewController: UIViewController,
                                                  DVPageContainerViewInput
                                        
{
    public var presenter: DVPageContainerViewOutput?
    public var onViewDidAppear: (() -> Void)?
    
    private lazy var chipsContainerScrollView: UIScrollView = makeScrollView()
    private lazy var childViewsContainerScrollView: UIScrollView = {
       let scrollView = makeScrollView()
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.isDirectionalLockEnabled = true
        //scrollView.contentInset = UIEdgeInsets(top: childrenViewsScrollVerticalInset, left: 0, bottom: 0, right: 0)
        return scrollView
    }()
    
    private var childControllers: [UIViewController] = []
    private var childrenViewsScrollVerticalInset: CGFloat = 0
    private let chipsDataSource: DVPagesChipsDataSource
    
    private lazy var contentViews: [UIView] = []
    private lazy var chipsViews: [DVSelectablePageChipsView] = []
    
    private lazy var aboveChipsContainerView: UIView = UIView()
    private lazy var belowChipsContainerView: UIView = UIView()
    private lazy var belowContentContainerView: UIView = UIView()
    
    private var innerViewsContentItems: [DVPageContainerInnerViewsContentItem] = []
    private var visibleInnerViewsContentItemsForCurrentPage: [DVPageContainerInnerViewsContentItem] = []
    
    public init(
        chipsDataSource: DVPagesChipsDataSource
    ) {
        self.chipsDataSource = chipsDataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAppearance() {
        view.backgroundColor = .white
    }
    
    private func setupSubviews() {
        view.addSubview(childViewsContainerScrollView)
        view.addSubview(belowContentContainerView)
        view.addSubview(belowChipsContainerView)
        view.addSubview(aboveChipsContainerView)
        view.addSubview(chipsContainerScrollView)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layout()
        
        chipsContainerScrollView.contentSize = chipsContainerScrollContentSize
        childViewsContainerScrollView.contentSize = childViewsContainerScrollContentSize
    }
    
    private func layout() {
        aboveChipsContainerView.isHidden = innerViewsAboveChips.isEmpty
        
        var lastAboveChipsView: UIView?
        innerViewsAboveChips.forEach { view in
            view.pin
                .top(to: lastAboveChipsView?.edge.bottom ?? aboveChipsContainerView.edge.top)
                .horizontally()
                .sizeToFit(.width)
            lastAboveChipsView = view
        }
        
        aboveChipsContainerView.pin
            .top(view.pin.safeArea)
            .horizontally()
            .wrapContent(.vertically)
        
        if aboveChipsContainerView.isHidden {
            chipsContainerScrollView.pin
                .top(view.pin.safeArea)
        } else {
            chipsContainerScrollView.pin
                .below(of: aboveChipsContainerView)
        }
        
        chipsContainerScrollView.pin
            .horizontally()
        
        var chipsViewLeftEdge = chipsContainerScrollView.edge.left
        chipsViews.forEach { view in
            view.pin
                .top()
                .left(to: chipsViewLeftEdge)
                .sizeToFit()
            chipsViewLeftEdge = view.edge.right
        }
        
        chipsContainerScrollView.pin
            .height(chipsViews.first?.frame.height ?? .zero)
        
        belowChipsContainerView.isHidden = innerViewsBelowChips.isEmpty
        
        var lastBelowChipsView: UIView?
        innerViewsBelowChips.forEach { view in
            view.pin
                .top(to: lastBelowChipsView?.edge.bottom ?? belowChipsContainerView.edge.top)
                .horizontally()
                .sizeToFit(.width)
            lastBelowChipsView = view
        }
        
        belowChipsContainerView.pin
            .below(of: chipsContainerScrollView)
            .horizontally()
            .wrapContent(.vertically)
        
        belowContentContainerView.isHidden = innerViewsBelowContent.isEmpty
        
        var lastViewBelowContent: UIView?
        innerViewsBelowContent.forEach { view in
            view.pin
                .top(to: lastViewBelowContent?.edge.bottom ?? belowContentContainerView.edge.top)
                .horizontally()
                .sizeToFit(.width)
            lastViewBelowContent = view
        }
        
        belowContentContainerView.pin
            .bottom(view.pin.safeArea)
            .horizontally()
            .wrapContent(.vertically)
        
        var totalHeight: CGFloat
        if #available(iOS 11.0, *) {
            totalHeight = view.frame.height - chipsContainerScrollView.frame.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom
        } else {
            totalHeight = view.frame.height - chipsContainerScrollView.frame.height - 44 - 44
        }
        
        if !aboveChipsContainerView.isHidden {
            totalHeight -= aboveChipsContainerView.frame.height
        }

        if !belowChipsContainerView.isHidden {
            totalHeight -= belowChipsContainerView.frame.height
        }
        
        if !belowContentContainerView.isHidden {
            totalHeight -= belowContentContainerView.frame.height
        }
        
        childViewsContainerScrollView.frame = CGRect(
            x: 0,
            y: 44,
            width: view.frame.width,
            height: totalHeight
        )
        
        var childViewLeftEdge = childViewsContainerScrollView.edge.left
        contentViews.forEach { view in
            view.pin
                .top()
                .left(to: childViewLeftEdge)
                .width(childViewsContainerScrollView.frame.width)
                .height(childViewsContainerScrollView.frame.height)
            childViewLeftEdge = view.edge.right
        }
    }
    
    private func removeAllChildViews() {
        chipsViews.forEach { view in
            view.removeFromSuperview()
        }
        contentViews.forEach { view in
            view.removeFromSuperview()
        }
        contentViews = []
        chipsViews = []
        
        view.setNeedsLayout()
    }
    
    public func setInnerViewsContent(_ content: DVPageContainerInnerViewsContent, for item: Int? = nil) {
        let item = item ?? 0
        innerViewsContentItems.map { $0.view }.forEach { $0.removeFromSuperview() }
        self.innerViewsContentItems = content.items
        self.visibleInnerViewsContentItemsForCurrentPage = content.items.filter { contentItem in
            if case let .specificPage(index: id) = contentItem.visibility {
                return id == item
            } else {
                return contentItem.visibility == .all
            }
        }
        innerViewsAboveChips.forEach { view in
            aboveChipsContainerView.addSubview(view)
        }
        innerViewsBelowChips.forEach { view in
            belowChipsContainerView.addSubview(view)
        }
        innerViewsBelowContent.forEach { view in
            belowContentContainerView.addSubview(view)
        }
        view.setNeedsLayout()
    }
    
    public func setPageChildOffset(_ offset: CGFloat) {
//        chipsContainerScrollView.frame.origin = CGPoint(
//            x: childViewsContainerScrollView.frame.origin.x,
//            y: min(safeAreaInsets.top, childViewsContainerScrollView.frame.origin.y - offset)
//        )
    }
    
    private func addPageContainerItem(_ item: DVPageContainerContentItem, with index: Int) {
        guard let childContentView = item.pageController.view else { return }
        
        item.pageController.willMove(toParent: self)
        
        childControllers.append(item.pageController)
        addChild(item.pageController)
        
        childViewsContainerScrollView.addSubview(childContentView)
        contentViews.append(childContentView)
        
        item.pageController.didMove(toParent: self)
        
        let chipsView = chipsDataSource.configureSelectableChipsView(for: index)
        chipsView.delegate = self
        
        chipsContainerScrollView.addSubview(chipsView)
        chipsViews.append(chipsView)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
        setupSubviews()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        onViewDidAppear?()
    }
    
    public func scrollToPage(with index: Int) {
        selectPageChips(with: index)
    }
    
    deinit {
        print("Deinit DVPageViewController")
    }
    
    public func setPagesContainerItems(with items: [DVPageContainerContentItem]) {
        items.enumerated().forEach { offset, item in
            addPageContainerItem(item, with: offset)
        }
        view.setNeedsLayout()
    }
}

private extension DVPageContainerViewController {
    var innerViewsAboveChips: [UIView] {
        visibleInnerViewsContentItemsForCurrentPage.filter {
            $0.position == .abovePageChips
        }.map { $0.view }
    }
    
    
    var innerViewsBelowChips: [UIView] {
        visibleInnerViewsContentItemsForCurrentPage.filter {
            $0.position == .belowPageChips
        }.map { $0.view }
    }
    
    
    var innerViewsBelowContent: [UIView] {
        visibleInnerViewsContentItemsForCurrentPage.filter {
            $0.position == .belowPageContent
        }.map { $0.view }
    }
    
    var chipsContainerScrollContentSize: CGSize {
        CGSize(
            width: chipsViews.last?.frame.maxX ?? .zero,
            height: chipsContainerScrollView.frame.height
        )
    }
    
    var childViewsContainerScrollContentSize: CGSize {
        CGSize(
            width: contentViews.last?.frame.maxX ?? .zero,
            height: childViewsContainerScrollView.frame.height
        )
    }
    
    func makeScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }
    
    func arrangeInnerViews(for item: Int) {
        setInnerViewsContent(.init(items: innerViewsContentItems), for: item)
        view.setNeedsLayout()
    }
}

extension DVPageContainerViewController: UIScrollViewDelegate {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let newChipsIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        
        chipsViews.first(where: { $0.isSelected })?.isSelected = false
        chipsViews[newChipsIndex].isSelected = true
        
        chipsContainerScrollView.scrollRectToVisible(chipsViews[newChipsIndex].frame, animated: true)
        
        arrangeInnerViews(for: newChipsIndex)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
        
        (childControllers[currentPage] as? DVPageViewController)?.onPageDidAppear()
    }
}

extension DVPageContainerViewController: DVSelectablePageChipsViewDelegate {
    public func selectPageChips(with id: Int) {
        chipsViews.first(where: { $0.isSelected })?.isSelected = false
        chipsViews[id].isSelected = true
        chipsContainerScrollView.scrollRectToVisible(chipsViews[id].frame, animated: true)
        childViewsContainerScrollView.scrollRectToVisible(contentViews[id].frame, animated: true)
        
        arrangeInnerViews(for: id)
    }
}
