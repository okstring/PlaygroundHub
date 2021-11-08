//
//  CoreDataStorage.swift
//  GitInsightHub
//
//  Created by Issac on 2021/11/04.
//

import Foundation
import CoreData
import RxSwift
import RxCocoa

protocol RepositoryCoreDataStorage {
    func getLocalRepositoryList(category: RepositoryCagetory) -> Single<[Repository]>
    func saveRepository(repository: Repository, category: RepositoryCagetory)
}

class DefaultRepositoryCoreDataStorage: RepositoryCoreDataStorage {
    private let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack = .shared) {
        self.coreDataStack = coreDataStack
    }
    
    func getLocalRepositoryList(category: RepositoryCagetory) -> Single<[Repository]> {
        var repositories = [Repository]()
        let predicate = NSPredicate(format: "categoryID == %d", category.categoryID)
        
        return Single.create() { [weak self] single in
            if let repositoryEntity = self?.coreDataStack.persistentContainer.viewContext.fetchData(predicate: predicate) as? [ReposiporyEntity] {
                
                for repository in repositoryEntity {
                    repositories.append(repository.toDTO())
                }
            }
            
            if repositories.isEmpty {
                single(.failure(PersistanceError.noResult))
            } else {
                single(.success(repositories))
            }
            
            return Disposables.create()
        }
    }
    
    func saveRepository(repository: Repository, category: RepositoryCagetory) {
        coreDataStack.persistentContainer.performBackgroundTask { context in
            do {
                self.deleteResponse(id: repository.id, in: context)
                _ = repository.toEntity(in: context, category: category)
                
                try context.save()
            } catch {
                debugPrint("store Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
}

extension DefaultRepositoryCoreDataStorage {
    func fetchRequest(id: Int) -> NSFetchRequest<ReposiporyEntity> {
        let request: NSFetchRequest = ReposiporyEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id = %d", id)
        return request
    }
    
    private func deleteResponse(id: Int, in context: NSManagedObjectContext) {
        let request = fetchRequest(id: id)
        do {
            if let result = try context.fetch(request).first {
                context.delete(result)
            }
        } catch {
            print(error)
        }
    }
}
