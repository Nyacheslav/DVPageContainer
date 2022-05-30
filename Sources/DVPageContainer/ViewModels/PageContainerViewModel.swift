//
//  PageContainerViewModel.swift
//  PageControllerContainer
//
//  Created by Vyacheslav Vakulenko on 24.05.2022.
//

struct PageContainerViewModel: Equatable {
    let itemsViewModels: [PageContainerItemViewModel]
}

struct PageContainerItemViewModel: Equatable {
    let chipsViewModel: ChipsViewModel
    let childPageController: PageViewController
    
    static func == (
        lhs: PageContainerItemViewModel,
        rhs: PageContainerItemViewModel
    ) -> Bool {
        return lhs.chipsViewModel == rhs.chipsViewModel && lhs.childPageController === rhs.childPageController
    }
}
