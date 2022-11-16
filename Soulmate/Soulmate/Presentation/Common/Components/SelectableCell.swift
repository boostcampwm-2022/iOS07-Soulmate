//
//  SelectableCell.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/11.
//

import UIKit
import SnapKit

class SelectableCell: UICollectionViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        self.contentView.addSubview(label)
        return label
    }()
    
    private lazy var checkImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        self.contentView.addSubview(imageView)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureLayout()
        isUnChecked()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.cornerRadius = 14
    }
    
    func configureLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.centerY.equalToSuperview()
        }
        
        checkImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-24)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(28)
        }
    }
    
    func isChecked() {
        self.contentView.layer.borderColor = UIColor.borderPurple?.cgColor
        self.contentView.backgroundColor = UIColor.lightPurple
        self.checkImageView.image = UIImage(named: "checkOn")
    }
    
    func isUnChecked() {
        self.contentView.layer.borderColor = UIColor.symbolGrey?.cgColor
        self.contentView.backgroundColor = UIColor.white
        self.checkImageView.image = UIImage(named: "checkOff")
    }
    
    
}


#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct UIViewPreview<View: UIView>: UIViewRepresentable {
    let view: View

    init(_ builder: @escaping () -> View) {
        view = builder()
    }

    // MARK: - UIViewRepresentable

    func makeUIView(context: Context) -> UIView {
        return view
    }

    func updateUIView(_ view: UIView, context: Context) {
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}
#endif

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct MyYellowButtonPreview: PreviewProvider{
    static var previews: some View {
        UIViewPreview {
            let button = SelectableCell(frame: .zero)
            //button.setTitle("buttonTest", for: .normal)
            return button
        }.previewLayout(.fixed(width: 350, height: 72))
    }
}
#endif
