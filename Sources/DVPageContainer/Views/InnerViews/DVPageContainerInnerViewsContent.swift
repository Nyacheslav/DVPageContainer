//
//  CustomViewContent.swift
//  PageControllerContainer
//
//  Created by Vyacheslav Vakulenko on 26.05.2022.
//

import UIKit

public struct DVPageContainerInnerViewsContent: Equatable {
    public let items: [DVPageContainerInnerViewsContentItem]
    
    public init(
        items: [DVPageContainerInnerViewsContentItem]
    ) {
        self.items = items
    }
}

public struct DVPageContainerInnerViewsContentItem: Equatable {
    public let view: UIView
    public let position: DVPageContainerInnerViewPosition
    public let visibility: DVPageContainerInnerViewVisibility
    
    public init(
        view: UIView,
        position: DVPageContainerInnerViewPosition,
        visibility: DVPageContainerInnerViewVisibility
    ) {
        self.view = view
        self.position = position
        self.visibility = visibility
    }
}
