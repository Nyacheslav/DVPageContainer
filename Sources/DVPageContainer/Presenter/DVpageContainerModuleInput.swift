//
//  DVpageContainerModuleInput.swift
//  
//
//  Created by Vyacheslav Vakulenko on 31.05.2022.
//

public protocol DVpageContainerModuleInput: AnyObject {
    func setInnerViewsContent(_ content: DVPageContainerInnerViewsContent)
    func setPageContainerContent(_ pageContainerContent: DVPageContainerContent)
}
