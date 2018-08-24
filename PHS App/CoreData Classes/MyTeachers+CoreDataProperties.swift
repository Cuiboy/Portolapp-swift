//
//  MyTeachers+CoreDataProperties.swift
//  PHS App
//
//  Created by Patrick Cui on 8/19/18.
//  Copyright © 2018 Portola App Development. All rights reserved.
//
//

import Foundation
import CoreData


extension MyTeachers {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyTeachers> {
        return NSFetchRequest<MyTeachers>(entityName: "MyTeachers")
    }

    @NSManaged public var period: Int16
    @NSManaged public var teacher: Teachers?

}
