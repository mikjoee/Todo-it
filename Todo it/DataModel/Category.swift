//
//  Category.swift
//  Todo it
//
//  Created by Muhammed ikbal Can on 23.04.2018.
//  Copyright © 2018 Muhammed ikbal Can. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
