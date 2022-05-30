//
//  PageContollerContainer.swift
//  PageControllerContainer
//
//  Created by Vyacheslav Vakulenko on 11.05.2022.
//

import UIKit

struct PageContainerModule {
    let viewController: UIViewController
    let moduleInput: PageContainerPresenter
}

protocol AssemblesPageContainer {
    func module(seed: PageContainerModuleSeed) -> PageContainerModule
}

final class PageContainerAssembly: AssemblesPageContainer {
    func module(seed: PageContainerModuleSeed) -> PageContainerModule {
        let viewController = PageContainerViewController(chipsFactory: seed.chipsFactory)
        
        let presenter = PageContainerPresenter(pageContainerViewInput: viewController)
        viewController.presenter = presenter
        
        presenter.setPageContainerContent(seed.pageContainerContent)
        
        return .init(viewController: viewController, moduleInput: presenter)
    }
}

struct PageContainerModuleSeed {
    let pageContainerContent: PageContainerContent
    let chipsFactory: ChipsDataSource
}
