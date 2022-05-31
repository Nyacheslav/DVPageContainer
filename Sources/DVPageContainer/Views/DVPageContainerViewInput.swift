//
//  DVPageContainerViewInput.swift
//  
//
//  Created by Vyacheslav Vakulenko on 06.06.2022.
//

import UIKit

public protocol DVPageContainerViewInput: UIViewController {
    var presenter: DVPageContainerViewOutput? { get set }
    
    var onViewDidAppear: (() -> Void)? { get set }
    
    func setPagesContainerItems(with items: [DVPageContainerContentItem])
    func setPageChildOffset(_ offset: CGFloat)
    func setInnerViewsContent(_ content: DVPageContainerInnerViewsContent, for item: Int?)
    func scrollToPage(with index: Int)
}
