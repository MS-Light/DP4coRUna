//
//  Category.swift
//  DP4coRUna
//
//  Created by YANBO JIANG on 8/11/20.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<SignalDetail>()
}
