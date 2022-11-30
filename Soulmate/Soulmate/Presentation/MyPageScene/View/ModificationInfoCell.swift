//
//  ModificationInfoCell.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/29.
//

import UIKit

class ModificationInfoCell: UICollectionViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 15)
        label.text = "닉네임"
        label.textColor = .labelDarkGrey
        self.contentView.addSubview(label)
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        label.text = "초록잎"
        label.textColor = .black
        self.contentView.addSubview(label)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.cornerRadius = 6
        self.isSelected = false
        
        self.contentView.layer.borderColor = UIColor.labelGrey?.cgColor
        self.contentView.backgroundColor = .systemBackground
    }
    
    func configureLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        valueLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(104)
            $0.centerY.equalToSuperview()
        }
    }
    
    func fill(with infoViewModel: ModificationInfoViewModel) {
        self.titleLabel.text = infoViewModel.key
        self.valueLabel.text = infoViewModel.value
    }
    
}



#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct ModificationInfoCellPreview: PreviewProvider{
    static var previews: some View {
        UIViewPreview {
            let cell = ModificationInfoCell(frame: .zero)
            return cell
        }.previewLayout(.fixed(width: 350, height: 50))
    }
}
#endif
