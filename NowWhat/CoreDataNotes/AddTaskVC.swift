//
//  AddTaskVC.swift
//  NowWhatApp
//
//  Created by Jamie Randall on 9/14/18.
//  Copyright © 2018 Jamie Randall. All rights reserved.
//

import UIKit
import CoreData
import GoogleMobileAds
import Flurry_iOS_SDK



class AddTaskVC: UIViewController {
  
  var items: Tasks?
  
  @IBOutlet weak var textFieldTrailing: NSLayoutConstraint!
  @IBOutlet weak var textFieldLeading: NSLayoutConstraint!
  @IBOutlet weak var bannerView: GADBannerView!
  
  @IBOutlet weak var newTaskTextField: UITextField!
  @IBOutlet weak var newTaskTextView: UITextView!
  @IBOutlet weak var datePicker: UIDatePicker!
  @IBOutlet weak var dateLabel: UILabel!
  
  @IBAction func datePickerAction(_ sender: Any) {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM-dd-yyyy"
    let strDate = dateFormatter.string(from: datePicker.date)
    self.dateLabel.text = strDate
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bannerView.adUnitID = "ca-app-pub-2183852088176657/5387455955"
    bannerView.rootViewController = self
    let request = GADRequest()
    request.testDevices = [kGADSimulatorID]
    bannerView.load(request)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    UIView.animate(withDuration: 1) {
      self.newTaskTextField.alpha = 1
    }
    
    UIView.animate(withDuration: 4) {
      self.newTaskTextView.alpha = 1
    }
    
    UIView.animate(withDuration: 6) {
      self.datePicker.alpha = 1
    }
  }
  
  func objectCount() {
    do {
      
      let persistentContainer = CoreDataHelper.shared.persistentContainer
      let managedContext = persistentContainer.viewContext
      let fetchRequest = NSFetchRequest<Tasks>(entityName: "Tasks")
      
      _ = try managedContext.count(for: fetchRequest)
      print(objectCount)
    } catch let error as NSError {
      print("Could not count \(error)")
    }
    
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let masterViewController = segue.destination as! MasterVC
    
    if let identifier = segue.identifier {
      if identifier == "Save" {
        print("Save button tapped")
        
        // Save New Note to Core Data
        
        var objects: Int64 = 0
        
        do {
          
          let persistentContainer = CoreDataHelper.shared.persistentContainer
          let managedContext = persistentContainer.viewContext
          let fetchRequest = NSFetchRequest<Tasks>(entityName: "Tasks")
          
          var objectCount = try managedContext.count(for: fetchRequest)
          objects = Int64(objectCount)
          print(objects)
        } catch let error as NSError {
          print("Could not count \(error)")
        }
        
        let dueDate = datePicker.date 
        
        let task = self.items ?? CoreData.newTask()
        task.title = newTaskTextField.text ?? ""
        task.content = newTaskTextView.text ?? ""
        task.date = dateLabel.text ?? ""
        task.dueDate = dueDate
        task.order = objects + 1
        
        masterViewController.items.append(task)
        
        print(task)
        
        CoreData.saveTask()
        
        Flurry.logEvent("Added New Task")
        
      }
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
}
