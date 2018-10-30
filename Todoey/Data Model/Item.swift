//
//  Item.swift
//  Todoey
//
//  Created by Emma Boroson on 10/19/18.
//  Copyright © 2018 eboroson. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated: Date = Date()
    //linking objects define inverse relationship - each item has parentCateogry of type "Category";   "property" is the name of the forward relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
