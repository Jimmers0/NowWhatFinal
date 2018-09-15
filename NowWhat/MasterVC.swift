//
//  MasterVC.swift
//  NowWhatApp
//
//  Created by Jamie Randall on 9/14/18.
//  Copyright © 2018 Jamie Randall. All rights reserved.
//

import UIKit
import CoreData


class MasterVC: UITableViewController, UISplitViewControllerDelegate, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
  
  struct Storyboard {
    static let mainStoryboard = "Main"
    static let addTaskVC = "AddTaskVC"
    static let addCloudTaskVC = "AddCloudTaskVC"
  }
  
  var items = [Tasks]() {
    didSet {
      tableView.reloadData()
    }
  }
  
  @IBOutlet weak var editButton: UIBarButtonItem!
  @IBOutlet weak var doneButton: UIBarButtonItem!
  var lastSelectedIndex: Int?
  
  
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
    
  }
  
  func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return CustomNavigationAnimator() 
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.delegate = self
    
    
    doneButton.title = " "
    doneButton.isEnabled = false
    tableView.tableFooterView = UIView()
    items = CoreData.retrieveTasks()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return items.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskTableViewCell
    
    let row = indexPath.row
    let item = items[row]
    
    cell.taskTitleLabel.text = item.title
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
  {
    if editingStyle == .delete {
      
      let persistentContainer = CoreDataHelper.shared.persistentContainer
      let managedContext = persistentContainer.viewContext
      //remove object from core data
      let context:NSManagedObjectContext = managedContext
      context.delete(items[indexPath.row] as NSManagedObject)
      do {
        try context.save()
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
      
      //update UI methods
      tableView.beginUpdates()
      items.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
      tableView.endUpdates()
      
      CoreData.saveTask()
    }
  }
  
  @IBAction func editButtonPressed(_ sender: Any) {
    
    tableView.setEditing(true, animated: true)
    doneButton.title = "Done"
    doneButton.isEnabled = true
    
    self.isEditing = !self.isEditing
    
  }
  
  @IBAction func doneButtonPressed(_ sender: Any) {
    tableView.setEditing(false, animated: true)
    doneButton.title = " "
  }
  
  func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    
    let item = items[sourceIndexPath.row]
    items.remove(at: sourceIndexPath.row)
    items.insert(item, at: destinationIndexPath.row)
    
    var order = 0
    for item in items {
      item.order = Int64(order)
      order = order + 1
    }
    
    CoreData.updateTasks()
  }
  //  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  //    if let identifier = segue.identifier {
  //
  //      if identifier == "ShowDetail" {
  //        print("Table view cell tapped")
  //        if let indexPath = self.tableView.indexPathForSelectedRow {
  //
  //          let item = items[indexPath.row]
  //          let controller = (segue.destination as! UINavigationController).topViewController as! DetailVC
  //          controller.items = item
  //
  //        }
  //      }
  //    }
  //  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowDetail" {
      let toViewController = segue.destination as UIViewController
      toViewController.transitioningDelegate = self
      if let indexPath = self.tableView.indexPathForSelectedRow {
        
        let item = items[indexPath.row]
        let controller = (segue.destination as! UINavigationController).topViewController as! DetailVC
        controller.items = item
        
      }
    } 
  }
  
  @IBAction func unwindToMasterViewController(_ segue: UIStoryboardSegue) {
    self.items = CoreData.retrieveTasks()
  }
}

extension MasterVC: UIPopoverPresentationControllerDelegate {
  @IBAction func addTask(_ sender: UIBarButtonItem) {
    let storyboard: UIStoryboard = UIStoryboard(name: Storyboard.mainStoryboard, bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: Storyboard.addTaskVC)
    viewController.transitioningDelegate = self
    let popover: UIPopoverPresentationController = viewController.popoverPresentationController!
    popover.barButtonItem = sender
    popover.delegate = self
    present(viewController, animated: true, completion: nil)
  }
  
  func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
    return .fullScreen
  }
  
}
