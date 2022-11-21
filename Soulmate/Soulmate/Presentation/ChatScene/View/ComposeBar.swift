//
//  ComposeBar.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/21.
//

import UIKit

final class ComposeBar: UIView {
    
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    func configure() {
        Bundle.main.loadNibNamed("ComposeBar", owner: self)
        addSubview(contentView)
        contentView.frame = self.frame
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
