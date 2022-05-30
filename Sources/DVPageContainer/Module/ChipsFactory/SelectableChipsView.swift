//
//  SelectableChipsView.swift
//  PageControllerContainer
//
//  Created by Vyacheslav Vakulenko on 25.05.2022.
//

import UIKit

protocol SelectableChipsView: UIView {
    var isSelected: Bool { get set }
    var delegate: SelectableChipsViewDelegate? { get set }
}
