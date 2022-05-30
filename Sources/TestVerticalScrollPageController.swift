//
//  TestVerticalScrollPageController.swift
//  PageControllerContainer
//
//  Created by Vyacheslav Vakulenko on 25.05.2022.
//

import UIKit

protocol ChildPageScrollDelegate: AnyObject {
    func scrollViewDidScroll(_ scrollView: UIScrollView)
}

final class TestVerticalScrollPageController: UIViewController, PageViewController, UIScrollViewDelegate {
    func onPageDidAppear() {
        print("Scroll appear")
    }
    
    let scrollView = UIScrollView()
    
    let backgroundColor: UIColor
    var delegate: ChildPageScrollDelegate?
    
    init(_ backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
        
        super.init(nibName: nil, bundle: nil)
        scrollView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        scrollView.backgroundColor = backgroundColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.pin.all()
        scrollView.contentSize = .init(width: scrollView.frame.width, height: 800)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll(scrollView)
    }
}

