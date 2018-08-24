//
//  Today+CoreDataProperties.swift
//  PHS App
//
//  Created by Patrick Cui on 8/8/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//
//

import Foundation
import CoreData


extension Today {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Today> {
        return NSFetchRequest<Today>(entityName: "Today")
    }

    @NSManaged public var todayType: Int32
    @NSManaged public var tomorrowType: Int32
    @NSManaged public var nextMondayType: Int32
    @NSManaged public var day: Int32

}
