//
//  PageContainerContentItem.swift
//  PageControllerContainer
//
//  Created by Vyacheslav Vakulenko on 26.05.2022.
//

public struct DVPageContainerContentItem {
    public let title: String
    public let pageController: DVPageViewController
    
    public init(
        title: String,
        pageController: DVPageViewController
    ) {
        self.title = title
        self.pageController = pageController
    }
}
