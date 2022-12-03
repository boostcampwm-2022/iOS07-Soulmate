//
//  ChatListLayout.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/03.
//

import UIKit

final class ChatListLayout: UICollectionViewLayout {
    
    private var computedContentSize: CGSize = .zero
    private var cellAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    
    override var collectionViewContentSize: CGSize {
        return computedContentSize
    }
    
    override func prepare() {
        guard let collectionView else { return }
        
        computedContentSize = .zero
        cellAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
        
        var yOffset: CGFloat = 0
        var contentHeight: CGFloat = 0
        
        for section in 0..<collectionView.numberOfSections {
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                
                let indexPath = IndexPath(item: item, section: section)
                
                let dataSource = collectionView.dataSource as? ChatDataSource
                guard let heights = dataSource?.heights else { return }
                
                let cellHeight = heights[item]
                let cellWidth = collectionView.bounds.size.width
                let itemFrame = CGRect(x: 0, y: yOffset, width: cellWidth, height: cellHeight)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = itemFrame
                cellAttributes[indexPath] = attributes
                
                yOffset += cellHeight
                
                contentHeight = max(collectionView.bounds.size.height, itemFrame.maxY)
            }
        }
        
        computedContentSize = CGSize(width: collectionView.bounds.size.width, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributeList = [UICollectionViewLayoutAttributes]()
        
        for (_, attributes) in cellAttributes {
            if attributes.frame.intersects(rect) {
                attributeList.append(attributes)
            }
        }
        
        return attributeList
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttributes[indexPath]
    }
}
