//
//  UserCacheManager.swift
//  Hit
//
//  Created by Pietro Putelli on 31/10/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import CoreData
import UIKit

class CoreDateManager {
    
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    var entityName: String!
    
    init(entityName: String) {
        self.entityName = entityName
    }
    
    func elementAlreadyExists(id: Int, entityName: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.includesSubentities = false
        var entitiesCount = 0
        do {
            entitiesCount = try context.count(for: fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        return entitiesCount > 0
    }
}

class UserCoreDataManager: CoreDateManager {
    
}
