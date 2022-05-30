//
//  PageContainerView.swift
//  PageControllerContainer
//
//  Created by Vyacheslav Vakulenko on 11.05.2022.
//

import UIKit
import PinLayout

protocol PageContainerViewDelegate: UIViewController {
    func onPageDidAppear(for index: Int)
    func onRemoveAllChildViews()
    func shouldAddChildPageController(_ viewController: PageViewController)
    func childPageViewDidAdd(for viewController: PageViewController)
}

final class PageContainerView: UIView {
    private lazy var chipsContainerScrollView: UIScrollView = makeScrollView()
    private lazy var childViewsContainerScrollView: UIScrollView = {
       let scrollView = makeScrollView()
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.contentInset = UIEdgeInsets(top: childrenViewsScrollVerticalInset, left: 0, bottom: 0, right: 0)
        return scrollView
    }()
    var childrenViewsScrollVerticalInset: CGFloat = 100
    private let chipsViewFactory: ChipsDataSource
    
    private lazy var contentViews: [UIView] = []
    private lazy var chipsViews: [SelectableChipsView] = []
    
    var customViewsAboveChips: [UIView] {
        visibleCustomViewsContentItemsForCurrentPage.filter { $0.position == .aboveChips }.map { $0.view }
    }
    private lazy var aboveChipsContainer: UIView = UIView()
    
    var customViewsBetweenChipsAndContent: [UIView] {
        visibleCustomViewsContentItemsForCurrentPage.filter { $0.position == .betweenChipsAndContent }.map { $0.view }
    }
    private lazy var betweenChipsAndContentContainerView: UIView = UIView()
    
    var customViewsBelowContent: [UIView] {
        visibleCustomViewsContentItemsForCurrentPage.filter { $0.position == .belowContent }.map { $0.view }
    }
    private lazy var customViewsBelowContentContainerView: UIView = UIView()
    
    private var customViewsContentItems: [CustomViewsContentItem] = []
    private var visibleCustomViewsContentItemsForCurrentPage: [CustomViewsContentItem] = []
    
    weak var delegate: PageContainerViewDelegate?
    
    init(
        chipsFactory: ChipsDataSource
    ) {
        self.chipsViewFactory = chipsFactory
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        setupSubviews()
    }
    
    private func setupSubviews() {
        addSubview(childViewsContainerScrollView)
        addSubview(customViewsBelowContentContainerView)
        addSubview(betweenChipsAndContentContainerView)
        addSubview(aboveChipsContainer)
        addSubview(chipsContainerScrollView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
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
            .top(pin.safeArea)
            .horizontally()
            .wrapContent(.vertically)
        
        if aboveChipsContainer.isHidden {
            chipsContainerScrollView.pin
                .top(pin.safeArea)
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
            .bottom(pin.safeArea)
            .horizontally()
            .wrapContent(.vertically)
        
        var totalHeight: CGFloat = frame.height - chipsContainerScrollView.frame.height - safeAreaInsets.top - safeAreaInsets.bottom
        
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
            y: safeAreaInsets.top,
            width: frame.width,
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
    
    private func addPageContainerItem(_ content: PageContainerItemViewModel, with index: Int) {
        guard let childContentView = content.childPageController.view else { return }
        childViewsContainerScrollView.addSubview(childContentView)
        contentViews.append(childContentView)
        
        let chipsView = chipsViewFactory.createNewChipsView(for: index)
        chipsView.delegate = self
        chipsViewFactory.configureChipsView(chipsView, for: index)
        
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
        
        delegate?.onRemoveAllChildViews()
        
        setNeedsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCustomViewsContent(_ content: CustomViewsContent, for item: Int? = nil) {
        let item = item ?? 0//Int(childViewsContainerScrollView.contentOffset.x / childViewsContainerScrollView.frame.width)
        customViewsContentItems.map { $0.view }.forEach { $0.removeFromSuperview() }
        self.customViewsContentItems = content.items
        self.visibleCustomViewsContentItemsForCurrentPage = content.items.filter { contentItem in
            if case let .visibleForSpecificItem(id) = contentItem.visibilityParameter {
                return id == item
            } else {
                return contentItem.visibilityParameter == .visibleForAll
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
        setNeedsLayout()
    }
    
    func setPageChildOffset(_ offset: CGFloat) {
//        chipsContainerScrollView.frame.origin = CGPoint(
//            x: childViewsContainerScrollView.frame.origin.x,
//            y: min(safeAreaInsets.top, childViewsContainerScrollView.frame.origin.y - offset)
//        )
    }
    
    func apply(_ viewModel: PageContainerViewModel) {
        removeAllChildViews()
        viewModel.itemsViewModels.enumerated().forEach { offset, item in
            delegate?.shouldAddChildPageController(item.childPageController)
            addPageContainerItem(item, with: offset)
            delegate?.childPageViewDidAdd(for: item.childPageController)
        }
        setNeedsLayout()
    }
}

private extension PageContainerView {
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
        setNeedsLayout()
    }
}

extension PageContainerView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let newChipsIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        
        chipsViews.first(where: { $0.isSelected })?.isSelected = false
        chipsViews[newChipsIndex].isSelected = true
        
        chipsContainerScrollView.scrollRectToVisible(chipsViews[newChipsIndex].frame, animated: true)
        
        handleCustomViews(for: newChipsIndex)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
        
        delegate?.onPageDidAppear(for: currentPage)
    }
}

extension PageContainerView: SelectableChipsViewDelegate {
    func didSelectChips(with id: Int) {
        chipsViews.first(where: { $0.isSelected })?.isSelected = false
        chipsViews[id].isSelected = true
        chipsContainerScrollView.scrollRectToVisible(chipsViews[id].frame, animated: true)
        childViewsContainerScrollView.scrollRectToVisible(contentViews[id].frame, animated: true)
        
        handleCustomViews(for: id)
    }
}
