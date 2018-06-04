//
//  Weapon.swift
//  realm-browser
//
//  Created by shingo asato on 2018/06/04.
//  Copyright © 2018年 anz. All rights reserved.
//

import Foundation

import RealmSwift

@objcMembers
final class Weapon: Object {
    dynamic var id: Int = 0
    dynamic var name: String = ""
    dynamic var atk: Int = 0
    dynamic var price: Int = 0
    dynamic var createdAt: Date = Date()
    dynamic var updatedAt: Date = Date()
    
    override static func primaryKey() -> String? {
        return #keyPath(Weapon.id)
    }
}
