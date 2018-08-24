//
//  Coaches+CoreDataProperties.swift
//  PHS App
//
//  Created by Patrick Cui on 8/18/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//
//

import Foundation
import CoreData


extension Coaches {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Coaches> {
        return NSFetchRequest<Coaches>(entityName: "Coaches")
    }

    @NSManaged public var first: String?
    @NSManaged public var last: String?
    @NSManaged public var email: String?
    @NSManaged public var gender: Bool
    @NSManaged public var team1: String?
    @NSManaged public var team2: String?

}
