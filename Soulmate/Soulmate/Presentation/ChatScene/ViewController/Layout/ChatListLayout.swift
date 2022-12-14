//
//  ChatListLayout.swift
//  Soulmate
//
//  Created by Hoen on 2022/12/03.
//

import UIKit

final class ChatListLayout: UICollectionViewLayout {        
    
    private var computedContentSize: CGSize = .zero
    private var attributes = [UICollectionViewLayoutAttributes]()
    
    override var collectionViewContentSize: CGSize {
        return computedContentSize
    }
    
    override func prepare() {
        
        guard let collectionView,
              let dataSource = collectionView.dataSource as? ChatDataSource else { return }
                
        attributes = [UICollectionViewLayoutAttributes]()        
        
        let snapshot = dataSource.snapshot()
        var yOffset: CGFloat = 0
        
        snapshot.sectionIdentifiers.enumerated().forEach { section, sectionIdentifier in
            
            let header = sectionIdentifier
            
            let headerAttributes = UICollectionViewLayoutAttributes(
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                with: IndexPath(item: 0, section: section)
            )
            
            let headerFrame = CGRect(
                x: 0,
                y: yOffset,
                width: collectionView.bounds.size.width,
                height: dataSource.headerHeight
            )
            
            headerAttributes.frame = headerFrame
            attributes.append(headerAttributes)
            yOffset += dataSource.headerHeight
            
            snapshot.itemIdentifiers(inSection: sectionIdentifier).enumerated().forEach { item, chatId in
                
                if let chat = dataSource.chatDictionary[chatId] {
                    let indexPath = IndexPath(item: item, section: section)                
                    
                    let cellHeight = chat.height
                    let cellWidth = collectionView.bounds.size.width
                    let cellOffset = yOffset
                    
                    let itemFrame = CGRect(x: 0, y: cellOffset, width: cellWidth, height: cellHeight)
                    
                    let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    cellAttributes.frame = itemFrame
                    attributes.append(cellAttributes)
                    
                    yOffset += cellHeight
                }
            }
        }
        
        let contentWidth = collectionView.bounds.size.width
        let contentHeight = max(collectionView.bounds.size.height, yOffset)
            
        computedContentSize = CGSize(width: contentWidth, height: contentHeight)
    }        
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var attributeList = [UICollectionViewLayoutAttributes]()
        
        let index: Int? = binarySearch(attributes) { (attribute) -> ComparisonResult in
            if attribute.frame.intersects(rect) {
                return .orderedSame
            }
            if attribute.frame.minY > rect.maxY {
                return .orderedDescending
            }
            return .orderedAscending
        }
        
        guard let index else { return [] }
        
        for itemAttributes in attributes[..<index].reversed() {
            guard itemAttributes.frame.maxY >= rect.minY else { break }
            attributeList.append(itemAttributes)
        }
        
        for itemAttributes in attributes[index...] {
            guard itemAttributes.frame.minY <= rect.maxY else { break }
            attributeList.append(itemAttributes)
        }                
        
        return attributeList
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
