//
//  SelectableChipsView.swift
//  PageControllerContainer
//
//  Created by Vyacheslav Vakulenko on 25.05.2022.
//

import UIKit

public protocol DVSelectablePageChipsView: UIView {
    var isSelected: Bool { get set }
    var delegate: DVSelectablePageChipsViewDelegate? { get set }
}
