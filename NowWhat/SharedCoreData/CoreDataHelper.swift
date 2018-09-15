//
//  CoreDataHelper.swift
//  NowWhatApp
//
//  Created by Jamie Randall on 9/14/18.
//  Copyright © 2018 Jamie Randall. All rights reserved.
//
import Foundation
import CoreData


class CoreDataHelper {
  
  static let shared = CoreDataHelper()
  
  lazy var persistentContainer: NSPersistentContainer = {
    
    let container = NSPersistentContainer(name: "NowWhat")
    container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.Jimmers.NowWhat")!.appendingPathComponent("Data.sqlite"))]
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()

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
  
}
