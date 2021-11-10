//
//  CoreDataStack.swift
//  GitInsightHub
//
//  Created by Issac on 2021/11/03.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RepositoryEntity")
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    
    func taskContext() -> NSManagedObjectContext {
        let taskContext = persistentContainer.newBackgroundContext()
        setBackgroundContext(taskContext)
        
        return taskContext
    }
    
    fileprivate func setBackgroundContext(_ context: NSManagedObjectContext) {
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.undoManager = nil
    }
    
    func performBackgroundTask(task: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask { context in
            self.setBackgroundContext(context)
            task(context)
        }
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                assertionFailure("CoreDataStack Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
}

extension NSManagedObjectContext {
    func fetchData(predicate: NSPredicate? = nil) -> Array<Any> {
        let request: NSFetchRequest = ReposiporyEntity.fetchRequest()
        request.returnsObjectsAsFaults = false
        
        if let predicate = predicate {
            request.predicate = predicate
        }
        do {
            let result = try self.fetch(request)
            return result
        } catch {
            fatalError("Failed to fetch repositoryEntity: \(error)")
        }
    }
}

