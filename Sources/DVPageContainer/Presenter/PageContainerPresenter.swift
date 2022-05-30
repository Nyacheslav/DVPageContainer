//
//  PageContainerPresenter.swift
//  PageControllerContainer
//
//  Created by Vyacheslav Vakulenko on 12.05.2022.
//

import UIKit

final class PageContainerPresenter {
    private weak var pageContainerViewInput: PageContainerViewController?
    
    init(pageContainerViewInput: PageContainerViewController) {
        self.pageContainerViewInput = pageContainerViewInput
    }
    
    func setPageContainerContent(_ pageContainerContent: PageContainerContent) {
        let viewModel = PageContainerViewModel(
            itemsViewModels: pageContainerContent.items.enumerated().map { offset, contentItem in
                let chipsViewModel = ChipsViewModel(
                    id: offset,
                    title: contentItem.title,
                    isSelected: offset == 0
                )
                return PageContainerItemViewModel(
                    chipsViewModel: chipsViewModel,
                    childPageController: contentItem.pageController
                )
            }
        )
        pageContainerViewInput?.apply(viewModel)
    }
    
    func childPageViewDidScroll(with offset: CGFloat) {
        pageContainerViewInput?.setPageChildOffset(offset)
    }
    
    func setCustomViewContent(_ content: CustomViewsContent) {
        pageContainerViewInput?.setCustomViewsContent(content)
    }
}
