//
//  PageContainerViewModel.swift
//  PageControllerContainer
//
//  Created by Vyacheslav Vakulenko on 24.05.2022.
//

public struct DVPageContainerViewModel: Equatable {
    let itemsViewModels: [DVPageContainerItemViewModel]
}

public struct DVPageContainerItemViewModel: Equatable {
    let chipsViewModel: ChipsViewModel
    let childPageController: DVPageViewController
    
    static func == (
        lhs: DVPageContainerItemViewModel,
        rhs: DVPageContainerItemViewModel
    ) -> Bool {
        return lhs.chipsViewModel == rhs.chipsViewModel && lhs.childPageController === rhs.childPageController
    }
}
