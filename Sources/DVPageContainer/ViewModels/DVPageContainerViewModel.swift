//
//  PageContainerViewModel.swift
//  PageControllerContainer
//
//  Created by Vyacheslav Vakulenko on 24.05.2022.
//

import UIKit

public struct DVPageContainerViewModel: Equatable {
    let itemsViewModels: [DVPageContainerItemViewModel]
}

public struct DVPageContainerItemViewModel: Equatable {
    let title: String
    let childPageController: UIViewController
    
    public static func == (
        lhs: DVPageContainerItemViewModel,
        rhs: DVPageContainerItemViewModel
    ) -> Bool {
        return lhs.title == rhs.title && lhs.childPageController === rhs.childPageController
    }
}
