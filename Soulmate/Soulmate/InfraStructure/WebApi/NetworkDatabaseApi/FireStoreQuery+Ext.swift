//
//  FireStoreQuery+Ext.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/17.
//

import Foundation
import FirebaseFirestore

extension Query {
    func merge(with entity: QueryEntity) -> Query {
        switch entity.comparator {
        case .in:
            return self.whereField(entity.field, in: [entity.value]) // FIXME: 이부분 어케할지 고민
        case .notIn:
            return self.whereField(entity.field, notIn: [entity.value]) // FIXME: 이부분 어케할지 고민
        case .isEqualTo:
            return self.whereField(entity.field, isEqualTo: entity.value)
        case .isLessThan:
            return self.whereField(entity.field, isLessThan: entity.value)
        case .arrayContains:
            return self.whereField(entity.field, arrayContains: entity.value)
        case .isGreaterThan:
            return self.whereField(entity.field, isGreaterThan: entity.value)
        case .isNotEqualTo:
            return self.whereField(entity.field, isNotEqualTo: entity.value)
        case .isLessThanOrEqual:
            return self.whereField(entity.field, isLessThanOrEqualTo: entity.value)
        case .isGreaterThanOrEqualTo:
            return self.whereField(entity.field, isGreaterThanOrEqualTo: entity.value)
        case .order:
            return self.order(by: entity.field)
        case .orderDescending:
            return self.order(by: entity.field, descending: true)
        case .limit:
            let number = entity.value as? Int
            return self.limit(to: number ?? 0)
        case .limitToLast:
            let number = entity.value as? Int
            return self.limit(toLast: number ?? 0)
        case .startAfterDocument:
            let doc = entity.value as? DocumentSnapshot
            // FIXME: - 강제 언래핑 안됨!
            return self.start(afterDocument: doc!)
        }
    }
}
