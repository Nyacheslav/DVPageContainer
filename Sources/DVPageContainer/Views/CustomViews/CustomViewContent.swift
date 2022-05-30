//
//  CustomViewContent.swift
//  PageControllerContainer
//
//  Created by Vyacheslav Vakulenko on 26.05.2022.
//

import UIKit

struct CustomViewsContent: Equatable {
    let items: [CustomViewsContentItem]
}

struct CustomViewsContentItem: Equatable {
    let view: UIView
    let position: CustomViewPosition
    let visibilityParameter: CustomViewVisibilityParameter
}
