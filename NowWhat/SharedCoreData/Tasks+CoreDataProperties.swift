//
//  Tasks+CoreDataProperties.swift
//  NowWhatApp
//
//  Created by Jamie Randall on 9/14/18.
//  Copyright © 2018 Jamie Randall. All rights reserved.
//
//

import Foundation
import CoreData


extension Tasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tasks> {
        return NSFetchRequest<Tasks>(entityName: "Tasks")
    }

    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var order: Int64
    @NSManaged public var date: String?
    @NSManaged public var dueDate: Date

}
