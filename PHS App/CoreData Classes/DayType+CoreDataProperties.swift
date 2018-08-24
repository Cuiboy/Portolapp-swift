//
//  DayType+CoreDataProperties.swift
//  PHS App
//
//  Created by Patrick Cui on 8/10/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//
//

import Foundation
import CoreData


extension DayType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DayType> {
        return NSFetchRequest<DayType>(entityName: "DayType")
    }

    @NSManaged public var type: Int16
    @NSManaged public var date: Date

}
