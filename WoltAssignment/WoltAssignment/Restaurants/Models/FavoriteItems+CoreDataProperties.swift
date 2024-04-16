//
//  FavoriteItems+CoreDataProperties.swift
//  WoltAssignment
//
//  Created by Vadim Rufov on 14.4.2024.
//
//

import Foundation
import CoreData


extension FavoriteItems {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteItems> {
        return NSFetchRequest<FavoriteItems>(entityName: "FavoriteItems")
    }

    @NSManaged public var id: String?

}

extension FavoriteItems : Identifiable {

}
