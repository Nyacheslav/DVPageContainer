//
//  PageContainerPresenter.swift
//  PageControllerContainer
//
//  Created by Vyacheslav Vakulenko on 12.05.2022.
//

import UIKit

public final class DVPageContainerPresenter: DVpageContainerModuleInput {
    private weak var pageContainerViewInput: DVPageContainerViewController?
    
    public init(pageContainerViewInput: DVPageContainerViewController) {
        self.pageContainerViewInput = pageContainerViewInput
    }
    
    public func setPageContainerContent(_ pageContainerContent: DVPageContainerContent) {
        let viewModel = DVPageContainerViewModel(
            itemsViewModels: pageContainerContent.items.enumerated().map { offset, contentItem in
                let chipsViewModel = ChipsViewModel(
                    id: offset,
                    title: contentItem.title,
                    isSelected: offset == 0
                )
                return DVPageContainerItemViewModel(
                    chipsViewModel: chipsViewModel,
                    childPageController: contentItem.pageController
                )
            }
        )
        pageContainerViewInput?.apply(viewModel)
    }
    
    public func childPageViewDidScroll(with offset: CGFloat) {
        pageContainerViewInput?.setPageChildOffset(offset)
    }
    
    public func setInnerViewsContent(_ content: DVPageContainerInnerViewsContent) {
        pageContainerViewInput?.setCustomViewsContent(content)
    }
}
