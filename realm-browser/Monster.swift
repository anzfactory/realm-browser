//
//  Monster.swift
//  realm-browser
//
//  Created by shingo asato on 2018/06/04.
//  Copyright © 2018年 anz. All rights reserved.
//

import Foundation

import RealmSwift

@objcMembers
final class Monster: Object {
    dynamic var id: Int = 0
    dynamic var name: String = ""
    dynamic var level: Int = 0
    dynamic var createdAt: Date = Date()
    dynamic var updatedAt: Date = Date()
    
    override static func primaryKey() -> String? {
        return #keyPath(Monster.id)
    }
}
