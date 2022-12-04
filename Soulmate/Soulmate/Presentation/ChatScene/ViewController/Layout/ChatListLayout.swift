//
//  ChatListLayout.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/03.
//

import UIKit

final class ChatListLayout: UICollectionViewLayout {
    
    private var computedContentSize: CGSize = .zero
    private var cellAttributes = [UICollectionViewLayoutAttributes]()
    private var cellIds = [String]()
    
    override var collectionViewContentSize: CGSize {
        return computedContentSize
    }
    
    override func prepare() {
        
        guard let collectionView,
              let dataSource = collectionView.dataSource as? ChatDataSource,
              !dataSource.ids.isEmpty else { return }

        let heights = dataSource.heights
        let yOffsets = dataSource.offsets
        let ids = dataSource.ids
        
        // FIXME: Refactoring 필요
        let cacheFirst = cellIds.first ?? ""
        let cacheLast = cellIds.last ?? ""
        let dataSourceFirst = ids.first ?? ""
        let dataSourceLast = ids.last ?? ""
                
        var startItem = 0
        
        if cacheFirst == dataSourceFirst && cacheLast == dataSourceLast {
            return
        } else if cacheFirst != dataSourceFirst {
            cellAttributes = [UICollectionViewLayoutAttributes]()
        } else if cacheFirst == dataSourceFirst && cacheLast != dataSourceLast {
            startItem = cellAttributes.count
        }

        for section in 0..<collectionView.numberOfSections {
            for item in startItem..<collectionView.numberOfItems(inSection: section) {
                
                let indexPath = IndexPath(item: item, section: section)
                                
                let cellHeight = heights[item]
                let cellWidth = collectionView.bounds.size.width
                let cellOffset = yOffsets[item] - cellHeight
                
                let itemFrame = CGRect(x: 0, y: cellOffset, width: cellWidth, height: cellHeight)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = itemFrame
                cellAttributes.append(attributes)
                cellIds.append(ids[item])
            }
        }
        
        let contentWidth = collectionView.bounds.size.width
        let contentHeight = max(collectionView.bounds.size.height, dataSource.offsets.last ?? 0)
        
        computedContentSize = CGSize(width: contentWidth, height: contentHeight)
    }        
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var attributeList = [UICollectionViewLayoutAttributes]()
        
        let index: Int? = binarySearch(cellAttributes) { (attribute) -> ComparisonResult in
            if attribute.frame.intersects(rect) {
                return .orderedSame
            }
            if attribute.frame.minY > rect.maxY {
                return .orderedDescending
            }
            return .orderedAscending
        }
        
        guard let index else { return [] }
        
        for attributes in cellAttributes[..<index].reversed() {
            guard attributes.frame.maxY >= rect.minY else { break }
            attributeList.append(attributes)
        }
        
        for attributes in cellAttributes[index...] {
            guard attributes.frame.minY <= rect.maxY else { break }
            attributeList.append(attributes)
        }                
        
        return attributeList
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }
    
    func binarySearch<T: Any>(_ a: [T], where compare: ((T)-> ComparisonResult)) -> Int? {
        var lowerBound = 0
        var upperBound = a.count
        while lowerBound < upperBound {
            let midIndex = lowerBound + (upperBound - lowerBound) / 2
            if compare(a[midIndex]) == .orderedSame {
                return midIndex
            } else if compare(a[midIndex]) == .orderedAscending {
                lowerBound = midIndex + 1
            } else {
                upperBound = midIndex
            }
        }
        return nil
    }
}
