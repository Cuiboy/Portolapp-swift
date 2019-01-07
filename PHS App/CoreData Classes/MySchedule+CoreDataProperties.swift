//
//  MySchedule+CoreDataProperties.swift
//  PHS App
//
//  Created by Patrick Cui on 1/6/19.
//  Copyright © 2019 Portola App Development. All rights reserved.
//
//

import Foundation
import CoreData


extension MySchedule {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MySchedule> {
        return NSFetchRequest<MySchedule>(entityName: "MySchedule")
    }

    @NSManaged public var period: Int16
    @NSManaged public var name: String?
    @NSManaged public var teacher: MyNewTeachers?

}
