//
//  AddCloudTaskVC.swift
//  NowWhatApp
//
//  Created by Jamie Randall on 9/14/18.
//  Copyright © 2018 Jamie Randall. All rights reserved.
//
import UIKit
import CoreData
import CloudKit


class AddCloudTaskVC: UIViewController {
  
  var items: Tasks?
  
  @IBOutlet weak var newTaskTextField: UITextField!
  @IBOutlet weak var dateTextView: UITextView!
  @IBOutlet weak var datePicker: UIDatePicker!
  
  
  @IBAction func datePickerAction(_ sender: Any) {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM-dd-yyyy"
    let strDate = dateFormatter.string(from: datePicker.date)
    self.dateTextView.text = strDate
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    newTaskTextField.text = ""
    dateTextView.text = ""
    
  }
  
  @IBAction func cancelButtonPressed(_ sender: Any) {
    
    print("cancel pressed")
    dismiss(animated: true, completion: nil)
    
  }
  
  @IBAction func savedButtonPressed(_ sender: Any) {
    
    print("saved?")
    
    if ((newTaskTextField?.text) != "") && dateTextView?.text != "" {
      let task = CKRecord(recordType: "notes")
      task["content"] = newTaskTextField?.text as CKRecordValue?
      task["date"] = dateTextView?.text as CKRecordValue?
      
      let publicDatabase = CKContainer.default().privateCloudDatabase
      publicDatabase.save(task, completionHandler: { (record: CKRecord?, error: Error?) in
        if error == nil {
          print("task saved")
        } else {
          print("Error: \(error.debugDescription)")
        }
      })
    }
    dismiss(animated: true, completion: nil)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
}
