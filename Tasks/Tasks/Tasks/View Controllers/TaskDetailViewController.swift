//
//  TaskDetailViewController.swift
//  Tasks
//
//  Created by Keri Levesque on 2/24/20.
//  Copyright © 2020 Keri Levesque. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {
 
    //MARK: Outlets
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var notesTextView: UITextView!
    @IBOutlet var priorityControl: UISegmentedControl!
    @IBOutlet var completedButton: UIButton!
 
 // MARK: - Properties
 
 // This is a managed object from the Core Data model
 var task: Task?
 
 // MARK: - View Lifecycle
 override func viewDidLoad() {
     super.viewDidLoad()
     notesTextView.text = ""
     let priority: TaskPriority
     if let taskPriority = task?.priority {
         priority = TaskPriority(rawValue: taskPriority)!
     } else {
         priority = .normal
     }
     priorityControl.selectedSegmentIndex = TaskPriority.allCases.firstIndex(of: priority) ?? 1
 }
 
 override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(animated)

     if let task = task {
         title = task.name
         nameTextField.text = task.name
         notesTextView.text = task.notes
     } else {
         // If no task was passed in, assume the user wants to create one,
         // so add a button to the navbar to "save" the new task
         navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
     }
 }
 
 override func viewWillDisappear(_ animated: Bool) {
     super.viewWillDisappear(animated)
     
     if let task = task {
         guard let name = nameTextField.text,
             !name.isEmpty else { return }
         
         let notes = notesTextView.text
         
         let priorityIndex = priorityControl.selectedSegmentIndex
         let priority = TaskPriority.allCases[priorityIndex]
         
         task.name = name
         task.notes = notes
         task.priority = priority.rawValue
         
         do {
             try CoreDataStack.shared.mainContext.save()
         } catch {
             NSLog("Error saving managed object context: \(error)")
         }
     }
 }
 
 @objc func save() {
     guard let name = nameTextField.text,
         !name.isEmpty else { return }
     
     let notes = notesTextView.text
     
     let priorityIndex = priorityControl.selectedSegmentIndex
     let priority = TaskPriority.allCases[priorityIndex]
     
     Task(name: name, notes: notes, priority: priority)
     saveTask()
     navigationController?.dismiss(animated: true, completion: nil)
 }
 
 private func saveTask() {
     do {
         try CoreDataStack.shared.mainContext.save()
     } catch {
         NSLog("Error saving managed object context: \(error)")
     }
 }

}

