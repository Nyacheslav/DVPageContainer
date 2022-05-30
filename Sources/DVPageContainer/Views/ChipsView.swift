//
//  ChipsView.swift
//  PageControllerContainer
//
//  Created by Vyacheslav Vakulenko on 18.05.2022.
//

import UIKit

protocol SelectableChipsViewDelegate: AnyObject {
    func didSelectChips(with id: Int)
}

final class ChipsView: UIView, SelectableChipsView {
    weak var delegate: SelectableChipsViewDelegate?
    
    private let titleLabel: InsetsStyledLabel = {
        let label = InsetsStyledLabel()
        label.insets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.font = UIFont.systemFont(ofSize: 15.0)
        return label
    }()
    
    var isSelected: Bool = false {
        didSet {
            if isSelected {
                titleLabel.backgroundColor = .lightGray.withAlphaComponent(0.5)
            } else {
                titleLabel.backgroundColor = .clear
            }
        }
    }
    
    private var viewModel: ChipsViewModel?
    
    init() {
        super.init(frame: .zero)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layout()
    }
    
    @objc private func onTap() {
        guard let viewModel = viewModel else { return }
        
        delegate?.didSelectChips(with: viewModel.id)
    }
    
    @discardableResult
    private func layout() -> CGSize {
        titleLabel.pin
            .top()
            .horizontally()
            .sizeToFit()
            .marginHorizontal(12)
            .marginVertical(8)
        
        return CGSize(width: titleLabel.frame.maxX + 12, height: titleLabel.frame.maxY + 8)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        self.pin.width(size.width)
        return layout()
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
        
        setNeedsLayout()
    }
    
    func apply(_ viewModel: ChipsViewModel) {
        guard self.viewModel != viewModel else { return }
        
        titleLabel.text = viewModel.title
        isSelected = viewModel.isSelected
        
        self.viewModel = viewModel
    }
}

open class InsetsStyledLabel: UILabel {
    var insets: UIEdgeInsets = UIEdgeInsets.zero
    
    override open func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let size = super.intrinsicContentSize
        
        return CGSize(
            width: size.width + insets.left + insets.right,
            height: size.height + insets.top + insets.bottom
        )
    }
}
