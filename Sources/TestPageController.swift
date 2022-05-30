//
//  TestPageController.swift
//  PageControllerContainer
//
//  Created by Vyacheslav Vakulenko on 17.05.2022.
//

import UIKit

final class TestPageController: UIViewController, PageViewController {
    let backgroundColor: UIColor
    
    init(_ backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = backgroundColor.withAlphaComponent(0.2)
    }
    
    func onPageDidAppear() {
        print("i am showing")
    }
}
