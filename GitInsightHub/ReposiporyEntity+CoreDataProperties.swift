//
//  ReposiporyEntity+CoreDataProperties.swift
//  
//
//  Created by Issac on 2021/11/03.
//
//

import Foundation
import CoreData


extension ReposiporyEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReposiporyEntity> {
        return NSFetchRequest<ReposiporyEntity>(entityName: "ReposiporyEntity")
    }

    @NSManaged public var forkCount: Int16
    @NSManaged public var fullTitle: String?
    @NSManaged public var id: Int16
    @NSManaged public var isStarred: Bool
    @NSManaged public var language: String?
    @NSManaged public var loginName: String?
    @NSManaged public var profileImageURL: String?
    @NSManaged public var repositoryDescription: String?
    @NSManaged public var starCount: Int16
    @NSManaged public var title: String?
    @NSManaged public var topics: [String]?

}
