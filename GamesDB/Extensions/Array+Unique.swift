//
//  Array+Unique.swift
//  GamesDB
//
//  Created by admin on 18.03.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    var uniques: Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}
