//
//  User+CoreDataProperties.swift
//  PHS App
//
//  Created by Patrick Cui on 8/18/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var first: String?
    @NSManaged public var last: String?
    @NSManaged public var grade: Int16
    @NSManaged public var house: String?
    @NSManaged public var shortID: Int32
    @NSManaged public var longID: Int32

}
