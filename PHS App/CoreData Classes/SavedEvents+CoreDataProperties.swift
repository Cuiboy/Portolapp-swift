//
//  SavedEvents+CoreDataProperties.swift
//  PHS App
//
//  Created by Patrick Cui on 8/9/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//
//

import Foundation
import CoreData


extension SavedEvents {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedEvents> {
        return NSFetchRequest<SavedEvents>(entityName: "SavedEvents")
    }

    @NSManaged public var title: String?
    @NSManaged public var time: String?
    @NSManaged public var date: Date
    @NSManaged public var notification: Bool
    @NSManaged public var identifier: String?

}
