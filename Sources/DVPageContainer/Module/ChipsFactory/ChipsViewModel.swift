//
//  ChipsViewModel.swift
//  PageControllerContainer
//
//  Created by Vyacheslav Vakulenko on 20.05.2022.
//

struct ChipsViewModel: Equatable {
    let id: Int
    let title: String
    let isSelected: Bool
    
    init(
        id: Int,
        title: String,
        isSelected: Bool
    ) {
        self.id = id
        self.title = title
        self.isSelected = isSelected
    }
    
    private var onSelect: ((Int) -> Void)?
    
    static func == (lhs: ChipsViewModel, rhs: ChipsViewModel) -> Bool {
        return lhs.title == rhs.title && lhs.isSelected == rhs.isSelected && lhs.id == rhs.id
    }
}
