//
//  QueryEntity.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/17.
//

import Foundation

struct QueryEntity {
    var field: String
    var value: Any
    var comparator: Comparator
}

enum Comparator {
    case `in`, notIn, isEqualTo, isLessThan,
         arrayContains, isGreaterThan, isNotEqualTo,
         isLessThanOrEqual, isGreaterThanOrEqualTo,
         order, orderDescending, limit, limitToLast, startAfterDocument
}
