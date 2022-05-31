//
//  CustomViewPosition.swift
//  PageControllerContainer
//
//  Created by Vyacheslav Vakulenko on 26.05.2022.
//

public enum DVPageContainerInnerViewPosition: Equatable {
    case abovePageChips
    case belowPageChips
    case belowPageContent
}

public enum DVPageContainerInnerViewVisibility: Equatable {
    case all
    case specificPage(index: Int)
}
