//
//  Collection+Extension.swift
//  JVocab
//
//  Created by Nam Dinh Vu on 9/14/17.
//  Copyright © 2017 NamDV. All rights reserved.
//

import UIKit

extension Collection where Indices.Iterator.Element == Index {
    //check if index is out of bounds
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
