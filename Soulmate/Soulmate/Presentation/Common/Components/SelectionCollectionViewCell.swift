//
//  SelectionCollectionViewCell.swift
//  Soulmate
//
//  Created by hanjongwoo on 2022/11/10.
//

import UIKit
import SnapKit

class SelectionCollectionViewCell: UICollectionViewCell {
    
    let testLabel: UILabel = {
        let label = UILabel()
        label.text = "dd"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.contentView.backgroundColor = .blue
        self.addSubview(testLabel)
        
        testLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
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

struct MyYellowButtonPreview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let cell = SelectionCollectionViewCell(frame: .zero)
            cell.backgroundColor = .blue
            return cell
        }.previewLayout(.sizeThatFits)
    }
}
#endif
