//
//  ChipsFactory.swift
//  PageControllerContainer
//
//  Created by Vyacheslav Vakulenko on 25.05.2022.
//

protocol ChipsDataSource: AnyObject {
    func createNewChipsView(for item: Int) -> SelectableChipsView
    func configureChipsView(_ view: SelectableChipsView, for index: Int)
}
