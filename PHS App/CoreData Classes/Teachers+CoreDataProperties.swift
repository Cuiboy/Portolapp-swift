//
//  Teachers+CoreDataProperties.swift
//  PHS App
//
//  Created by Patrick Cui on 8/27/18.
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
    @NSManaged public var myTeacher: NSSet?

}

// MARK: Generated accessors for myTeacher
extension Teachers {

    @objc(addMyTeacherObject:)
    @NSManaged public func addToMyTeacher(_ value: MyTeachers)

    @objc(removeMyTeacherObject:)
    @NSManaged public func removeFromMyTeacher(_ value: MyTeachers)

    @objc(addMyTeacher:)
    @NSManaged public func addToMyTeacher(_ values: NSSet)

    @objc(removeMyTeacher:)
    @NSManaged public func removeFromMyTeacher(_ values: NSSet)

}
