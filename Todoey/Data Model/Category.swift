//
//  Category.swift
//  Todoey
//
//  Created by Emma Boroson on 10/19/18.
//  Copyright © 2018 eboroson. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name : String = ""
    //List is like an array - initiliaze with () as an empty list
    let items = List<Item>()

}
