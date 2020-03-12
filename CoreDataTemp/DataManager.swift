//
//  DataManager.swift
//  CoreDataTemp
//
//  Created by Denis on 11.03.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import Foundation
import CoreData

class DataManager {
    
    static let shared = DataManager()
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataTemp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func fetchData () -> [Task] {
        let fetchRequest: NSFetchRequest = Task.fetchRequest()
        var tasks:[Task] = []
        do {
           tasks = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
        return tasks
    }
    
    func saveToInsert (taskName: String) -> Task? {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: persistentContainer.viewContext) else { return nil }
        let task = NSManagedObject(entity: entityDescription, insertInto: persistentContainer.viewContext) as! Task
        task.name = taskName
        do {
            try persistentContainer.viewContext.save()
        } catch let error {
            print(error.localizedDescription)
        }
        return task
    }
    
    func deleteTask (task: Task) {
        persistentContainer.viewContext.delete(task)
        saveContext()
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func search(text: String) -> [Task]? {
        var tasks:[Task] = []
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        var params = [Any]()
        let sql = "name CONTAINS[cd] %@"
        params.append(text)
        let predicate = NSPredicate(format: sql, argumentArray: params)
        fetchRequest.predicate = predicate
        do {
            tasks = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            fatalError("Fetching Failed")
        }
        return tasks
    }

}
