//
//  ChipsFactory.swift
//  PageControllerContainer
//
//  Created by Vyacheslav Vakulenko on 25.05.2022.
//

public protocol DVChipsDataSource: AnyObject {
    func createNewChipsView(for item: Int) -> DVSelectablePageChipsView
    func configureChipsView(_ view: DVSelectablePageChipsView, for index: Int)
}
