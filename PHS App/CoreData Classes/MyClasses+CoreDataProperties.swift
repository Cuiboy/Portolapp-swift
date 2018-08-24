//
//  MyClasses+CoreDataProperties.swift
//  PHS App
//
//  Created by Patrick Cui on 8/18/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//
//

import Foundation
import CoreData


extension MyClasses {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyClasses> {
        return NSFetchRequest<MyClasses>(entityName: "MyClasses")
    }

    @NSManaged public var period1: String?
    @NSManaged public var period2: String?
    @NSManaged public var period3: String?
    @NSManaged public var period4: String?
    @NSManaged public var period5: String?
    @NSManaged public var period6: String?
    @NSManaged public var period7: String?
    @NSManaged public var period8: String?

}
