//
//  CoreDataStack.swift
//  Tasks
//
//  Created by Keri Levesque on 2/24/20.
//  Copyright © 2020 Keri Levesque. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack() // only one in entire application
    
    
   lazy var container: NSPersistentContainer = {
        // the name below should match the filename of the xcdatamodeld file esactly (minue the extension)
        let container = NSPersistentContainer(name: "Tasks")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)") // intentionally crash app  only in development not production
            }
        }
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}
