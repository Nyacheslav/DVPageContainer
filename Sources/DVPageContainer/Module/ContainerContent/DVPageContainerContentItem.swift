//
//  PageContainerContentItem.swift
//  PageControllerContainer
//
//  Created by Vyacheslav Vakulenko on 26.05.2022.
//

import UIKit

public struct DVPageContainerContentItem {
    public let title: String
    public let pageController: UIViewController
    
    public init(
        title: String,
        pageController: UIViewController    
    ) {
        self.title = title
        self.pageController = pageController
    }
}
