//
//  UserEntityExtension.swift
//  MatchUp
//
//  Created by Muhammed Siddiqui on 7/10/24.
//

import Foundation
import CoreData
import ObjectiveC

extension UserEntity {
    // Additional properties for UserEntity that aren't in the Core Data model
    private struct AssociatedKeys {
        static var phoneKey = "phoneKey"
        static var cellKey = "cellKey"
        static var dobKey = "dobKey"
        static var registeredKey = "registeredKey"
        static var natKey = "natKey"
        static var loginKey = "loginKey"
    }
    
    // Phone property
    var phone: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.phoneKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.phoneKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // Cell property
    var cell: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.cellKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.cellKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // DOB property
    var dob: APIDate? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.dobKey) as? APIDate
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.dobKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // Registered property
    var registered: APIDate? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.registeredKey) as? APIDate
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.registeredKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // Nationality property
    var nat: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.natKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.natKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // Login property
    var login: APILogin? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.loginKey) as? APILogin
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.loginKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}