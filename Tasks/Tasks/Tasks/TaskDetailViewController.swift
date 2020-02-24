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
 
    //MARK: Properties
    
    // this is a managed object from the core data model
    var task: Task?
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        notesTextView.text = ""
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if task == nil {
            // if no task was passed im, assume the user wants to create one
            // so add a button to the navbar to "save" the new task
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        }
    }
    
   @objc func save() {
    guard let name = nameTextField.text,
        !name.isEmpty else { return }
    
    let notes = notesTextView.text
   let _ = Task(name: name, notes: notes)
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

