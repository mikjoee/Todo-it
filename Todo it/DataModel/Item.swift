//
//  Item.swift
//  Todo it
//
//  Created by Muhammed ikbal Can on 23.04.2018.
//  Copyright © 2018 Muhammed ikbal Can. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    var category = LinkingObjects(fromType: Category.self, property: "items")   /// relationship
}
