//
//  CoreLightCell+CoreDataProperties.swift
//  Baldr
//
//  Created by Thomas Emilsson on 11/22/16.
//  Copyright © 2016 Thomas Emilsson. All rights reserved.
//

import Foundation
import CoreData


extension CoreLightCell {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<CoreLightCell> {
        return NSFetchRequest<CoreLightCell>(entityName: "CoreLightCell");
    }

    @NSManaged public var color: String?
    @NSManaged public var expanded: Bool
    @NSManaged public var name: String?
    @NSManaged public var state: Bool
    @NSManaged public var version: String?

}
