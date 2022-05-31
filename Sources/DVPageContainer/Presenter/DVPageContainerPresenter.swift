//
//  PageContainerPresenter.swift
//  PageControllerContainer
//
//  Created by Vyacheslav Vakulenko on 12.05.2022.
//

import UIKit

public final class DVPageContainerPresenter: DVpageContainerModuleInput, DVPageContainerViewOutput {
    private weak var pageContainerViewInput: DVPageContainerViewInput?
    private weak var moduleOutput: DVPageContainerModuleOutput?
    
    public init(pageContainerViewInput: DVPageContainerViewInput) {
        self.pageContainerViewInput = pageContainerViewInput
        
        setupActions()
    }
    
    private func setupActions() {
        pageContainerViewInput?.onViewDidAppear = { [weak self] in
            self?.moduleOutput?.onPageContainerDidAppear()
        }
    }
    
    public func setPageContainerContent(_ pageContainerItems: [DVPageContainerContentItem]) {
        pageContainerViewInput?.setPagesContainerItems(with: pageContainerItems)
    }
    
    public func childPageViewDidScroll(with offset: CGFloat) {
        pageContainerViewInput?.setPageChildOffset(offset)
    }
    
    public func setInnerViewsContent(_ content: DVPageContainerInnerViewsContent) {
        pageContainerViewInput?.setInnerViewsContent(content, for: nil)
    }
    
    public func setModuleOutput(_ output: DVPageContainerModuleOutput) {
        self.moduleOutput = output
    }
    
    public func scrollToPage(with index: Int) {
        pageContainerViewInput?.scrollToPage(with: index)
    }
}
