//
//  PersistentContainer.swift
//  Touchlet
//
//  Created by Elias on 10/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import CoreData

class PersistentContainer: NSPersistentContainer{
    func saveContext(backgroundContext: NSManagedObjectContext? = nil){
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else {return}
        
        do{
            try context.save()
        }catch let error as NSError{
            Logger.log(text: "Error \(error), \(error.userInfo)")
        }
    }
}
