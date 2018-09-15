//
//  MasterICloudVC.swift
//  NowWhatApp
//
//  Created by Jamie Randall on 9/14/18.
//  Copyright © 2018 Jamie Randall. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class MasterICloudVC: UITableViewController {
  
  struct Storyboard {
    static let mainStoryboard = "Main"
    static let addTaskVC = "AddTaskVC"
    static let addCloudTaskVC = "AddCloudTaskVC"
  }
  
  
  @IBOutlet weak var composeTaskButton: UIBarButtonItem!
  var tasks = [CKRecord]()
  var refresh: UIRefreshControl!
  
  @objc func loadTasks() {
    let publicDatabase = CKContainer.default().privateCloudDatabase
    let query = CKQuery(recordType: "notes", predicate: NSPredicate(format: "TRUEPREDICATE", argumentArray: nil))
    query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    publicDatabase.perform(query, inZoneWith: nil) { (results: [CKRecord]?, error: Error?) in
      if let tasks = results {
        self.tasks = tasks
        DispatchQueue.main.async(execute: {
          self.tableView.reloadData()
          self.refresh.endRefreshing()
        })
      }
    }
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tasks.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let task = tasks[indexPath.row]
    
    if let content = task["content"] as? String {
      let date = task["date"] as? String
      
      cell.textLabel?.text = content
      cell.detailTextLabel?.text = date
    }
    
    return cell
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    refresh = UIRefreshControl()
    refresh.attributedTitle = NSAttributedString(string: "Pull to load tasks")
    refresh.addTarget(self, action: #selector(MasterICloudVC.loadTasks), for: .valueChanged)
    tableView.addSubview(refresh)
    loadTasks()
  }
}

extension MasterICloudVC: UIPopoverPresentationControllerDelegate {
  @IBAction func addCloudTask(_ sender: UIBarButtonItem) {
    let storyboard: UIStoryboard = UIStoryboard(name: Storyboard.mainStoryboard, bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: Storyboard.addCloudTaskVC)
    viewController.modalPresentationStyle = .popover
    let popover: UIPopoverPresentationController = viewController.popoverPresentationController!
    popover.barButtonItem = sender
    popover.delegate = self
    present(viewController, animated: true, completion: nil)
  }
  
  func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
    return .fullScreen
  }
}
