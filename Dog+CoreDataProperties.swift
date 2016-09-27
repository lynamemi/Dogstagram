//
//  Dog+CoreDataProperties.swift
//  Dogstagram
//
//  Created by Emily Lynam on 9/15/16.
//  Copyright © 2016 Emily Lynam. All rights reserved.
//

import Foundation
import CoreData


extension Dog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dog> {
        return NSFetchRequest<Dog>(entityName: "Dog");
    }

    @NSManaged public var name: String?
    @NSManaged public var color: String?
    @NSManaged public var treat: String?
    @NSManaged public var photo: Double

}
