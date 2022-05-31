//
//  PageContainerController.swift
//  PageControllerContainer
//
//  Created by Vyacheslav Vakulenko on 11.05.2022.
//

import UIKit
import PinLayout

public final class DVPageContainerViewController: UIViewController {
    var presenter: DVPageContainerPresenter?
    
    private var childControllers: [DVPageViewController] = []
    
    private lazy var chipsContainerScrollView: UIScrollView = makeScrollView()
    private lazy var childViewsContainerScrollView: UIScrollView = {
       let scrollView = makeScrollView()
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.contentInset = UIEdgeInsets(top: childrenViewsScrollVerticalInset, left: 0, bottom: 0, right: 0)
        return scrollView
    }()
    var childrenViewsScrollVerticalInset: CGFloat = 100
    private let chipsDataSource: DVChipsDataSource
    
    private lazy var contentViews: [UIView] = []
    private lazy var chipsViews: [DVSelectablePageChipsView] = []
    
    var customViewsAboveChips: [UIView] {
        visibleCustomViewsContentItemsForCurrentPage.filter { $0.position == .abovePageChips }.map { $0.view }
    }
    private lazy var aboveChipsContainer: UIView = UIView()
    
    var customViewsBetweenChipsAndContent: [UIView] {
        visibleCustomViewsContentItemsForCurrentPage.filter { $0.position == .belowPageChips }.map { $0.view }
    }
    private lazy var betweenChipsAndContentContainerView: UIView = UIView()
    
    var customViewsBelowContent: [UIView] {
        visibleCustomViewsContentItemsForCurrentPage.filter { $0.position == .belowPageContent }.map { $0.view }
    }
    private lazy var customViewsBelowContentContainerView: UIView = UIView()
    
    private var customViewsContentItems: [DVPageContainerInnerViewsContentItem] = []
    private var visibleCustomViewsContentItemsForCurrentPage: [DVPageContainerInnerViewsContentItem] = []
    
    public init(
        chipsDataSource: DVChipsDataSource
    ) {
        self.chipsDataSource = chipsDataSource
        super.init(nibName: nil, bundle: nil)
        
        setupAppearance()
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAppearance() {
        view.backgroundColor = .white
    }
    
    private func setupSubviews() {
        view.addSubview(childViewsContainerScrollView)
        view.addSubview(customViewsBelowContentContainerView)
        view.addSubview(betweenChipsAndContentContainerView)
        view.addSubview(aboveChipsContainer)
        view.addSubview(chipsContainerScrollView)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layout()
        
        chipsContainerScrollView.contentSize = chipsContainerScrollContentSize
        childViewsContainerScrollView.contentSize = childViewsContainerScrollContentSize
    }
    
    private func layout() {
        aboveChipsContainer.isHidden = customViewsAboveChips.isEmpty
        
        var lastAboveChipsView: UIView?
        customViewsAboveChips.forEach { view in
            view.pin
                .top(to: lastAboveChipsView?.edge.bottom ?? aboveChipsContainer.edge.top)
                .horizontally()
                .sizeToFit(.width)
            lastAboveChipsView = view
        }
        
        aboveChipsContainer.pin
            .top(view.pin.safeArea)
            .horizontally()
            .wrapContent(.vertically)
        
        if aboveChipsContainer.isHidden {
            chipsContainerScrollView.pin
                .top(view.pin.safeArea)
        } else {
            chipsContainerScrollView.pin
                .below(of: aboveChipsContainer)
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
        
        betweenChipsAndContentContainerView.isHidden = customViewsBetweenChipsAndContent.isEmpty
        
        var lastBetweenContentAndChipsView: UIView?
        customViewsBetweenChipsAndContent.forEach { view in
            view.pin
                .top(to: lastBetweenContentAndChipsView?.edge.bottom ?? betweenChipsAndContentContainerView.edge.top)
                .horizontally()
                .sizeToFit(.width)
            lastBetweenContentAndChipsView = view
        }
        
        betweenChipsAndContentContainerView.pin
            .below(of: chipsContainerScrollView)
            .horizontally()
            .wrapContent(.vertically)
        
        customViewsBelowContentContainerView.isHidden = customViewsBelowContent.isEmpty
        
        var lastViewBelowContent: UIView?
        customViewsBelowContent.forEach { view in
            view.pin
                .top(to: lastViewBelowContent?.edge.bottom ?? customViewsBelowContentContainerView.edge.top)
                .horizontally()
                .sizeToFit(.width)
            lastViewBelowContent = view
        }
        
        customViewsBelowContentContainerView.pin
            .bottom(view.pin.safeArea)
            .horizontally()
            .wrapContent(.vertically)
        
        var totalHeight: CGFloat
        if #available(iOS 11.0, *) {
            totalHeight = view.frame.height - chipsContainerScrollView.frame.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom
        } else {
            totalHeight = view.frame.height - chipsContainerScrollView.frame.height - 44 - 44
        }
        
        if !aboveChipsContainer.isHidden {
            totalHeight -= aboveChipsContainer.frame.height
        }

        if !betweenChipsAndContentContainerView.isHidden {
            totalHeight -= betweenChipsAndContentContainerView.frame.height
        }
        
        if !customViewsBelowContentContainerView.isHidden {
            totalHeight -= customViewsBelowContentContainerView.frame.height
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
    
    private func addPageContainerItem(_ content: DVPageContainerItemViewModel, with index: Int) {
        guard let childContentView = content.childPageController.view else { return }
        childViewsContainerScrollView.addSubview(childContentView)
        contentViews.append(childContentView)
        
        let chipsView = chipsDataSource.createNewChipsView(for: index)
        chipsView.delegate = self
        chipsDataSource.configureChipsView(chipsView, for: index)
        
        chipsContainerScrollView.addSubview(chipsView)
        chipsViews.append(chipsView)
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
    
    func setCustomViewsContent(_ content: DVPageContainerInnerViewsContent, for item: Int? = nil) {
        let item = item ?? 0//Int(childViewsContainerScrollView.contentOffset.x / childViewsContainerScrollView.frame.width)
        customViewsContentItems.map { $0.view }.forEach { $0.removeFromSuperview() }
        self.customViewsContentItems = content.items
        self.visibleCustomViewsContentItemsForCurrentPage = content.items.filter { contentItem in
            if case let .specificPage(index: id) = contentItem.visibility {
                return id == item
            } else {
                return contentItem.visibility == .all
            }
        }
        customViewsAboveChips.forEach { view in
            aboveChipsContainer.addSubview(view)
        }
        customViewsBetweenChipsAndContent.forEach { view in
            betweenChipsAndContentContainerView.addSubview(view)
        }
        customViewsBelowContent.forEach { view in
            customViewsBelowContentContainerView.addSubview(view)
        }
        view.setNeedsLayout()
    }
    
    func setPageChildOffset(_ offset: CGFloat) {
//        chipsContainerScrollView.frame.origin = CGPoint(
//            x: childViewsContainerScrollView.frame.origin.x,
//            y: min(safeAreaInsets.top, childViewsContainerScrollView.frame.origin.y - offset)
//        )
    }
    
    func apply(_ viewModel: DVPageContainerViewModel) {
        removeAllChildViews()
        viewModel.itemsViewModels.enumerated().forEach { offset, item in
            //delegate?.shouldAddChildPageController(item.childPageController)
            addPageContainerItem(item, with: offset)
            //delegate?.childPageViewDidAdd(for: item.childPageController)
        }
        view.setNeedsLayout()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    public func setCustomViewsContent(_ content: DVPageContainerInnerViewsContent) {
        //pageContainerView.setCustomViewsContent(content)
    }
    
}

private extension DVPageContainerViewController {
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
    
    func handleCustomViews(for item: Int) {
        setCustomViewsContent(.init(items: customViewsContentItems), for: item)
        view.setNeedsLayout()
    }
}

extension DVPageContainerViewController: UIScrollViewDelegate {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let newChipsIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        
        chipsViews.first(where: { $0.isSelected })?.isSelected = false
        chipsViews[newChipsIndex].isSelected = true
        
        chipsContainerScrollView.scrollRectToVisible(chipsViews[newChipsIndex].frame, animated: true)
        
        handleCustomViews(for: newChipsIndex)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
        
        childControllers[currentPage].onPageDidAppear()
    }
}

extension DVPageContainerViewController: DVSelectablePageChipsViewDelegate {
    public func didSelectChips(with id: Int) {
        chipsViews.first(where: { $0.isSelected })?.isSelected = false
        chipsViews[id].isSelected = true
        chipsContainerScrollView.scrollRectToVisible(chipsViews[id].frame, animated: true)
        childViewsContainerScrollView.scrollRectToVisible(contentViews[id].frame, animated: true)
        
        handleCustomViews(for: id)
    }
}
