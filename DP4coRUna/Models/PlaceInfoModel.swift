//
//  PlaceInfo.swift
//  DP4coRUna
//
//  Created by YANBO JIANG on 8/12/20.
//

import Foundation
import RealmSwift

class PlaceInfo: Object {
    @objc dynamic var place: String = ""
    let placeDetail = List<PlaceDetail>()
}
