//
//  UserInfo.swift
//  DP4coRUna
//
//  Created by YANBO JIANG on 8/12/20.
//

import Foundation
import RealmSwift

class PlaceDetail: Object{
    @objc dynamic var address: String = ""
    @objc dynamic var city: String = ""
    @objc dynamic var state: String = ""
    @objc dynamic var zipcode: String = ""
    @objc dynamic var country: String = ""
    @objc dynamic var floor: String = ""
    @objc dynamic var place: String = ""
    @objc dynamic var tag: String = ""
    var parentCategory = LinkingObjects(fromType: PlaceInfo.self, property: "placeDetail")
}
