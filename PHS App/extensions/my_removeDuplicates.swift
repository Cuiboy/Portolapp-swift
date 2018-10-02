//
//  my_removeDuplicates.swift
//  PHS App
//
//  Created by Patrick Cui on 9/12/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//

import Foundation
import UIKit

func uniq<S: Sequence, T: Hashable>(source: S) -> [T] where S.Iterator.Element == T {
    var buffer = [T]()
    var added = Set<T>()
    for elem in source {
        if !added.contains(elem) {
            buffer.append(elem)
            added.insert(elem)
        }
    }
    return buffer
}

