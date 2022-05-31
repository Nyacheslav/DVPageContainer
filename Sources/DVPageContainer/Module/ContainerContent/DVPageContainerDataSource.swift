//
//  ChipsFactory.swift
//  PageControllerContainer
//
//  Created by Vyacheslav Vakulenko on 25.05.2022.
//

public protocol DVPagesChipsDataSource: AnyObject {
    var delegate: DVPagesChipsDataSourceDelegate? { get set }
    
    func configureSelectableChipsView(for index: Int) -> DVSelectablePageChipsView
}

public protocol DVPagesChipsDataSourceDelegate: AnyObject {
    func updateContainerData(with items: [DVPageContainerContentItem])
}
