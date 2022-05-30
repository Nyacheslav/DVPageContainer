//
//  CustomViewPosition.swift
//  PageControllerContainer
//
//  Created by Vyacheslav Vakulenko on 26.05.2022.
//

enum CustomViewPosition: Equatable {
    case aboveChips
    case betweenChipsAndContent
    case belowContent
}

enum CustomViewVisibilityParameter: Equatable {
    case
    visibleForAll,
    visibleForSpecificItem(Int)
}
