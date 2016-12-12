//
//  CoreMoodCell+CoreDataProperties.swift
//  Baldr
//
//  Created by Thomas Emilsson on 12/13/16.
//  Copyright © 2016 Thomas Emilsson. All rights reserved.
//

import Foundation
import CoreData

extension CoreMoodCell {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<CoreMoodCell> {
        return NSFetchRequest<CoreMoodCell>(entityName: "CoreMoodCell");
    }

    @NSManaged public var lightsJSON: String
    @NSManaged public var moodName: String

}
