//
//  UserEntity+CoreDataProperties.swift
//  
//
//  Created by Muhammed Siddiqui on 7/10/24.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var email: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var index: Int32
    @NSManaged public var location: String?
    @NSManaged public var selectionStatus: Int16
    @NSManaged public var name: NameEntity?
    @NSManaged public var picture: PictureEntity?

}

extension UserEntity : Identifiable {

}
