//
//  RepositoryEntity.swift
//  GitInsightHub
//
//  Created by Issac on 2021/11/03.
//

import Foundation
import CoreData

extension Repository {
    func toEntity(in context: NSManagedObjectContext) -> ReposiporyEntity {
        let entity: ReposiporyEntity = .init(context: context)
        entity.id = Int16(id)
        entity.title = title
        entity.fullTitle = fullTitle
        entity.repositoryDescription = repositoryDescription
        entity.topics = topics
        entity.starCount = Int16(starCount)
        entity.language = language
        entity.loginName = loginName
        entity.isStarred = isStarred
        entity.profileImageURL = profileImageURL
        entity.forkCount = Int16(forkCount)
        
        return entity
    }
}

extension ReposiporyEntity {
    func toDTO() -> Repository {
        return .init(id: Int(id), title: title ?? "", fullTitle: fullTitle ?? "", repositoryDescription: repositoryDescription ?? "", topics: topics ?? [String](), starCount: Int(starCount), language: language ?? "", loginName: loginName ?? "", isStarred: isStarred, profileImageURL: profileImageURL ?? "", forkCount: Int(forkCount))
    }
}
