//
//  Item.swift
//  DP4coRUna
//
//  Created by YANBO JIANG on 8/11/20.
//

import Foundation
import RealmSwift

class SignalDetail: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var signalStrength: Double = 0.0
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
