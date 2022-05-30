//
//  CustomView.swift
//  PageControllerContainer
//
//  Created by Vyacheslav Vakulenko on 26.05.2022.
//

import UIKit

final class CustomView: UIView {
    let label: UILabel = {
        let label = UILabel()
        label.text = "CustomView"
        return label
    }()
    
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .cyan.withAlphaComponent(0.2)
        
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layout()
    }
    
    private func layout() -> CGSize {
      
        label.pin.top().left().sizeToFit()
        return label.frame.size
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        pin.width(size.width)
        return layout()
    }
}
