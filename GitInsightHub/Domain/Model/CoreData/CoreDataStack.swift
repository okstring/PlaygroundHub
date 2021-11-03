//
//  CoreDataStack.swift
//  GitInsightHub
//
//  Created by Issac on 2021/11/03.
//

import Foundation
import CoreData

enum StoreType {
    case persistent, inMemory

    func NSStoreType() -> String {
        switch self {
        case .persistent:
            return NSSQLiteStoreType
        case .inMemory:
            return NSInMemoryStoreType
        }
    }
}

class CoreDataStack {
    static let shared = CoreDataStack(storeType: .persistent)
    
    let storeType: StoreType
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Repository")
        
        if self.storeType == .inMemory {
            let description = NSPersistentStoreDescription()
            description.type = self.storeType.NSStoreType()
            container.persistentStoreDescriptions = [description]
        }
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unable to load core data persistent stores: \(error)")
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
    
    init(storeType: StoreType) {
        self.storeType = storeType
    }
    
    fileprivate func setBackgroundContext(_ context: NSManagedObjectContext) {
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.undoManager = nil
    }
    
    func taskContext() -> NSManagedObjectContext {
        let taskContext = persistentContainer.newBackgroundContext()
        setBackgroundContext(taskContext)
        
        return taskContext
    }
    
    func performBackgroundTask(task: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask { context in
            self.setBackgroundContext(context)
            task(context)
        }
    }
    
    
}
