//
//  ChipsFactoryExample.swift
//  PageControllerContainer
//
//  Created by Vyacheslav Vakulenko on 26.05.2022.
//

final class ChipsDataSourceExample: ChipsDataSource {
    init(titles: [String]) {
        self.titles = titles
    }
    
    var titles: [String] = []
    
    func createNewChipsView(for item: Int) -> SelectableChipsView {
        return ChipsView()
    }
    
    func configureChipsView(_ view: SelectableChipsView, for index: Int) {
        guard let chipsView = view as? ChipsView, index <= titles.count else { return }
        chipsView.apply(.init(id: index, title: titles[index], isSelected: index == 0))
    }
}
