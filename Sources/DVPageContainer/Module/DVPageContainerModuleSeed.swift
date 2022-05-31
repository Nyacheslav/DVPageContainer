//
//  DVPageContainerModuleSeed.swift
//  
//
//  Created by Vyacheslav Vakulenko on 31.05.2022.
//

public struct DVPageContainerModuleSeed {
    public let pageContainerContent: DVPageContainerContent
    public let chipsDataSource: DVChipsDataSource
    
    public init(
        pageContainerContent: DVPageContainerContent,
        chipsDataSource: DVChipsDataSource
    ) {
        self.pageContainerContent = pageContainerContent
        self.chipsDataSource = chipsDataSource
    }
}

