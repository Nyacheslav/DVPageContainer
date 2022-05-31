//
//  PageContollerContainer.swift
//  PageControllerContainer
//
//  Created by Vyacheslav Vakulenko on 11.05.2022.
//

import UIKit

public protocol AssemblesPageContainer {
    func module(seed: DVPageContainerModuleSeed) -> DVPageContainerModule
}

public final class PageContainerAssembly: AssemblesPageContainer {
    public func module(seed: DVPageContainerModuleSeed) -> DVPageContainerModule {
        let viewController = DVPageContainerViewController(chipsDataSource: seed.chipsDataSource)
        
        let presenter = DVPageContainerPresenter(pageContainerViewInput: viewController)
        viewController.presenter = presenter
        
        presenter.setPageContainerContent(seed.pageContainerContent)
        
        return .init(viewController: viewController, moduleInput: presenter)
    }
}
