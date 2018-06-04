//
//  ObjectSchema
//  realm-browser
//
//  Created by shingo asato on 2018/06/04.
//  Copyright © 2018年 anz. All rights reserved.
//

import Foundation

import RealmSwift

extension ObjectSchema {
    typealias Ex = ex
    var ex: Ex {
        return Ex(self)
    }
    struct ex {
        var propertiesWithoutPrimary: [Property] {
            var props = self.objectSchema.properties
            if let primary = self.objectSchema.primaryKeyProperty, let index = props.index(of: primary) {
                props.remove(at: index)
            }
            return props
        }
        private let objectSchema: ObjectSchema
        init(_ objectSchema: ObjectSchema) {
            self.objectSchema = objectSchema
            self.objectSchema.properties
        }
    }
}
