//
//  PageContainerController.swift
//  PageControllerContainer
//
//  Created by Vyacheslav Vakulenko on 11.05.2022.
//

import UIKit

final class PageContainerViewController: UIViewController {
    private let chipsFactory: ChipsDataSource
    
    lazy var pageContainerView: PageContainerView = {
        let view = PageContainerView(chipsFactory: chipsFactory)
        view.delegate = self
        return view
    }()
    
    var presenter: PageContainerPresenter?
    
    private var childControllers: [PageViewController] = []
    
    init(
        chipsFactory: ChipsDataSource
    ) {
        self.chipsFactory = chipsFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        view = pageContainerView
    }
    
    func apply(_ viewModel: PageContainerViewModel) {
        pageContainerView.setNeedsLayout()
        
        pageContainerView.apply(viewModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
    }
    
    func setPageChildOffset(_ offset: CGFloat) {
        pageContainerView.setPageChildOffset(offset)
    }
    
    private func setupNavigationBar() {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCustomView))
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc private func addCustomView() {
        let customView = CustomView()
        
        pageContainerView.setCustomViewsContent(.init(items: [
            .init(view: customView, position: .aboveChips, visibilityParameter: .visibleForSpecificItem(0)),
            .init(view: CustomView(), position: .betweenChipsAndContent, visibilityParameter: .visibleForSpecificItem(0)),
            .init(view: CustomView(), position: .betweenChipsAndContent, visibilityParameter: .visibleForSpecificItem(0)),
            .init(view: CustomView(), position: .betweenChipsAndContent, visibilityParameter: .visibleForSpecificItem(1)),
            
            .init(view: CustomView(), position: .belowContent, visibilityParameter: .visibleForSpecificItem(0)),
            .init(view: CustomView(), position: .belowContent, visibilityParameter: .visibleForSpecificItem(1)),
        ]))
    }
    
    func setCustomViewsContent(_ content: CustomViewsContent) {
        pageContainerView.setCustomViewsContent(content)
    }
    
}

extension PageContainerViewController: PageContainerViewDelegate {
    
    func onPageDidAppear(for index: Int) {
        childControllers[index].onPageDidAppear()
    }
    func onRemoveAllChildViews() {
        childControllers.forEach { childController in
            childController.willMove(toParent: nil)
            childController.removeFromParent()
            childController.didMove(toParent: nil)
        }
        childControllers = []
    }
    
    func shouldAddChildPageController(_ viewController: PageViewController) {
        viewController.willMove(toParent: self)
        addChild(viewController)
    }
    
    func childPageViewDidAdd(for viewController: PageViewController) {
        childControllers.append(viewController)
        viewController.didMove(toParent: self)
    }
}
