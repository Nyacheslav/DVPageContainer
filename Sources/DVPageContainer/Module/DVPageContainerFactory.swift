//
//  PageContollerContainer.swift
//  PageControllerContainer
//
//  Created by Vyacheslav Vakulenko on 11.05.2022.
//

import UIKit

public protocol DVPageContainerFactoryProtocol {
    func module(seed: DVPageContainerModuleSeed) -> DVPageContainerModule
}

public final class DVPageContainerFactory: DVPageContainerFactoryProtocol {
    public init() { }
    
    public func module(seed: DVPageContainerModuleSeed) -> DVPageContainerModule {
        let viewController: DVPageContainerViewInput = DVPageContainerViewController(
            chipsDataSource: seed.chipsDataSource
        )
        
        let presenter = DVPageContainerPresenter(pageContainerViewInput: viewController)
        viewController.presenter = presenter
        
        return .init(viewController: viewController, moduleInput: presenter)
    }
}
