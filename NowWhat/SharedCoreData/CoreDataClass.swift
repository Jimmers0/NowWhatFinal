//
//  File.swift
//  NowWhatApp
//
//  Created by Jamie Randall on 9/14/18.
//  Copyright © 2018 Jamie Randall. All rights reserved.
//
import CoreData
import UIKit

class CoreData {
  
  public static let persistentContainer = CoreDataHelper.shared.persistentContainer
  public static let managedContext = persistentContainer.viewContext
  
  static func newTask() -> Tasks {
    let task = NSEntityDescription.insertNewObject(forEntityName: "Tasks", into: managedContext) as! Tasks
    return task
  }
  
  static func saveTask() {
    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save \(error)")
    }
  }
  
  static func delete(task: Tasks) {
    managedContext.delete(task) 
    saveTask()
  }
  
  static func retrieveTasks() -> [Tasks] {
    
    let persistentContainer = CoreDataHelper.shared.persistentContainer
    let managedContext = persistentContainer.viewContext
    
    
    let fetchRequest = NSFetchRequest<Tasks>(entityName: "Tasks")
    do {
      let objectCount = try managedContext.count(for: fetchRequest)
      print(objectCount)
    } catch let error as NSError {
      print("Could not count \(error)")
    }
    
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
    
    do {
      let results = try managedContext.fetch(fetchRequest)
      return results
    } catch let error as NSError {
      print("Could not fetch \(error)")
    }
    return []
  }
  
  static func updateTasks() {
    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save \(error)")
    }
  }
}
