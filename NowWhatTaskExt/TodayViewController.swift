//
//  TodayViewController.swift
//  NowWhatExtension
//
//  Created by Jamie Randall on 9/14/18.
//  Copyright © 2018 Jamie Randall. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreData

class TodayViewController: UITableViewController, NCWidgetProviding {
  
  
  var items = [Tasks]()
  var startDate : Date = Date()
  var endDate : Date = Date()
  var todaysDate = Date()
  let formatter = DateFormatter()
  var date = "01-28-1994"
  
  func format() {
    let formatter = DateFormatter()
    // initially set the format based on your datepicker date / server String
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    let myString = formatter.string(from: Date()) // string purpose I add here
    // convert your string to date
    let yourDate = formatter.date(from: myString)
    //then again set the date format whhich type of output you need
    formatter.dateFormat = "MM-dd-yyyy"
    // again convert your date to string
    let myStringafd = formatter.string(from: yourDate!)
    
    date = myStringafd
  }
  
  func retrieveTasks() -> [Tasks] {
    
    let fetchRequest = orderFetchRequest()
    let persistentContainer = CoreDataHelper.shared.persistentContainer 
    let managedContext = persistentContainer.viewContext
    
    let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath:nil, cacheName: nil)
    
    do {
      try fetchedResultController.performFetch()
    }
    catch let error as NSError {
      print("Could not fetch \(error), \(error.userInfo)")
    }
    return []
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return items.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TaskExtCell
    
    let row = indexPath.row
    let item = items[row]
    
    cell.taskTitleLabel.text = item.title
    
    if item.date == date {
      cell.taskDate.text = "Due Today!"
      cell.taskDate.textColor = .red
      
    } else {
      cell.taskDate.text = item.date
    }
    
    return cell
    
  }
  
  func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
    if activeDisplayMode == .expanded {
      preferredContentSize = CGSize(width: 0, height: 500)
    } else {
      preferredContentSize = maxSize
    }
  }
  
  func orderFetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
    let sortDescriptor = NSSortDescriptor(key: "dueDate", ascending: true)
    let predicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate as CVarArg, endDate as CVarArg) // startDate and endData are defined elsewhere
    
    fetchRequest.sortDescriptors = [sortDescriptor]
    fetchRequest.predicate = predicate
    
    return fetchRequest
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    format()
    print(todaysDate)
    self.preferredContentSize = tableView.contentSize
    extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    
    items = CoreData.retrieveTasks()
    
  }
  
}
