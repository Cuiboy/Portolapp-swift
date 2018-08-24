//
//  Teachers+CoreDataProperties.swift
//  PHS App
//
//  Created by Patrick Cui on 8/19/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//
//

import Foundation
import CoreData


extension Teachers {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Teachers> {
        return NSFetchRequest<Teachers>(entityName: "Teachers")
    }

    @NSManaged public var first: String?
    @NSManaged public var gender: Bool
    @NSManaged public var id: Int32
    @NSManaged public var last: String?
    @NSManaged public var subject1: String?
    @NSManaged public var subject2: String?

}
