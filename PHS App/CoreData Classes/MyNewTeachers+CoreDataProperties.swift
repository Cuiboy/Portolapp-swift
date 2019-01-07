//
//  MyNewTeachers+CoreDataProperties.swift
//  PHS App
//
//  Created by Patrick Cui on 1/6/19.
//  Copyright © 2019 Portola App Development. All rights reserved.
//
//

import Foundation
import CoreData


extension MyNewTeachers {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyNewTeachers> {
        return NSFetchRequest<MyNewTeachers>(entityName: "MyNewTeachers")
    }

    @NSManaged public var first: String?
    @NSManaged public var last: String?
    @NSManaged public var subject1: String?
    @NSManaged public var subject2: String?
    @NSManaged public var isFemale: Bool
    @NSManaged public var schedule: NSSet?

}

// MARK: Generated accessors for schedule
extension MyNewTeachers {

    @objc(addScheduleObject:)
    @NSManaged public func addToSchedule(_ value: MySchedule)

    @objc(removeScheduleObject:)
    @NSManaged public func removeFromSchedule(_ value: MySchedule)

    @objc(addSchedule:)
    @NSManaged public func addToSchedule(_ values: NSSet)

    @objc(removeSchedule:)
    @NSManaged public func removeFromSchedule(_ values: NSSet)

}
