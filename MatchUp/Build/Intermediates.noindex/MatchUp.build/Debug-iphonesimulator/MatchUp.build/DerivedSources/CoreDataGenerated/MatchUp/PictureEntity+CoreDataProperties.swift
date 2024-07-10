//
//  PictureEntity+CoreDataProperties.swift
//  
//
//  Created by Muhammed Siddiqui on 7/10/24.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension PictureEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PictureEntity> {
        return NSFetchRequest<PictureEntity>(entityName: "PictureEntity")
    }

    @NSManaged public var large: String?
    @NSManaged public var medium: String?
    @NSManaged public var thumbnail: String?

}

extension PictureEntity : Identifiable {

}
