//
//  ChipsViewModel.swift
//  PageControllerContainer
//
//  Created by Vyacheslav Vakulenko on 20.05.2022.
//

public struct ChipsViewModel: Equatable {
    public let id: Int
    public let title: String
    public let isSelected: Bool
    
    public init(
        id: Int,
        title: String,
        isSelected: Bool
    ) {
        self.id = id
        self.title = title
        self.isSelected = isSelected
    }
    
    private var onSelect: ((Int) -> Void)?
    
    public static func == (lhs: ChipsViewModel, rhs: ChipsViewModel) -> Bool {
        return lhs.title == rhs.title && lhs.isSelected == rhs.isSelected && lhs.id == rhs.id
    }
}
