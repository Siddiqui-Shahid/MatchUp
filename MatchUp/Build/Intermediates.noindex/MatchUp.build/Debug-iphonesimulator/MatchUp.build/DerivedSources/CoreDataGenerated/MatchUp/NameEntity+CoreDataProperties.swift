//
//  NameEntity+CoreDataProperties.swift
//  
//
//  Created by Muhammed Siddiqui on 7/10/24.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension NameEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NameEntity> {
        return NSFetchRequest<NameEntity>(entityName: "NameEntity")
    }

    @NSManaged public var first: String?
    @NSManaged public var last: String?
    @NSManaged public var title: String?

}

extension NameEntity : Identifiable {

}
