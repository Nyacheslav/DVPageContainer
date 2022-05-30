//
//  ViewController.swift
//  PageControllerContainer
//
//  Created by Vyacheslav Vakulenko on 11.05.2022.
//

import PinLayout
import UIKit

class RootViewController: UIViewController {

    let pageContainerAseembler: AssemblesPageContainer = PageContainerAssembly()

    var pageContainerModule: PageContainerModule?
    
    private lazy var pushButton: UIButton = {
        let button = UIButton()
        button.setTitle("Перейти через Push", for: .normal)
        button.addTarget(self, action: #selector(onPushButton), for: .touchUpInside)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private lazy var presentButton: UIButton = {
        let button = UIButton()
        button.setTitle("Перейти через Present", for: .normal)
        button.addTarget(self, action: #selector(onPresentButton), for: .touchUpInside)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(pushButton)
        view.addSubview(presentButton)
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadControllers))
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc private func reloadControllers() {
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        pushButton.pin
            .bottom(to: view.edge.vCenter)
            .hCenter(to: view.edge.hCenter)
            .sizeToFit()
        
        presentButton.pin
            .top(to: view.edge.vCenter)
            .hCenter(to: view.edge.hCenter)
            .sizeToFit()
    }
    
    @objc private func onPushButton() {
        let verticalScrollPageController = TestVerticalScrollPageController(.lightGray)
        verticalScrollPageController.delegate = self
        
        let contentItems: [PageContainerContentItem] = [
            .init(title: "Вертикальный скролл", pageController: verticalScrollPageController),
            .init(title: "Страница №1", pageController: TestPageController(.red)),
            .init(title: "Страница с длинным описанием №2", pageController: TestPageController(.blue))
        ]
        pageContainerModule = pageContainerAseembler.module(
            seed: .init(
                pageContainerContent:  .init(
                    items: contentItems
                ), chipsFactory: ChipsDataSourceExample(titles: contentItems.map { $0.title })
            )
        )
        
        guard let pageContainerModule = pageContainerModule else {
            return
        }

        
        navigationController?.pushViewController(pageContainerModule.viewController, animated: true)
    }
    
    @objc private func onPresentButton() {
        let verticalScrollPageController = TestVerticalScrollPageController(.lightGray)
        verticalScrollPageController.delegate = self
        
        let contentItems: [PageContainerContentItem] = [
            .init(title: "Вертикальный скролл", pageController: verticalScrollPageController),
            .init(title: "Страница №1", pageController: TestPageController(.red)),
            .init(title: "Страница с длинным описанием №2", pageController: TestPageController(.blue))
        ]
        pageContainerModule = pageContainerAseembler.module(
            seed: .init(
                pageContainerContent:  .init(
                    items: contentItems
                ), chipsFactory: ChipsDataSourceExample(titles: contentItems.map { $0.title })
            )
        )
        
        guard let pageContainerModule = pageContainerModule else {
            return
        }

        pageContainerModule.moduleInput.setCustomViewContent(.init(items: [
            .init(view: CustomView(), position: .aboveChips, visibilityParameter: .visibleForSpecificItem(0)),
            .init(view: CustomView(), position: .betweenChipsAndContent, visibilityParameter: .visibleForSpecificItem(0)),
            .init(view: CustomView(), position: .betweenChipsAndContent, visibilityParameter: .visibleForSpecificItem(0)),
            .init(view: CustomView(), position: .betweenChipsAndContent, visibilityParameter: .visibleForSpecificItem(1)),
            
            .init(view: CustomView(), position: .belowContent, visibilityParameter: .visibleForSpecificItem(0)),
            .init(view: CustomView(), position: .belowContent, visibilityParameter: .visibleForSpecificItem(1)),
        ]))
        
        present(pageContainerModule.viewController, animated: true, completion: nil)
    }
}

extension RootViewController: ChildPageScrollDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let pageContainerModule = pageContainerModule else { return }
        
        pageContainerModule.moduleInput.childPageViewDidScroll(with: scrollView.contentOffset.y)
    }
}

