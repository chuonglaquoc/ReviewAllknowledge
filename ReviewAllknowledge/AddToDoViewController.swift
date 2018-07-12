//
//  AddToDoViewController.swift
//  ReviewAllknowledge
//
//  Created by Brian La on 7/12/18.
//  Copyright © 2018 BrianLa. All rights reserved.
//

import UIKit
import CoreData

class AddToDoViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
 
    @IBAction func cancel(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(sender: AnyObject) {
        let name = textField.text
        
        if let isEmpty = name?.isEmpty, isEmpty == false {
            let entity = NSEntityDescription.entity(forEntityName: "Item", in: self.managedObjectContext)
            
            let record = NSManagedObject(entity: entity!, insertInto: self.managedObjectContext)
            
            record.setValue(name, forKey: "name")
            record.setValue(NSDate(), forKey: "createdAt")
            
            do {
                try record.managedObjectContext?.save()
                
                dismiss(animated: true, completion: nil)
                
            } catch {
                let saveError = error as NSError
                print("\(saveError), \(saveError.userInfo)")
                
                showAlertWithTitle(title: "Warning", message: "Your to-do could not be saved.", cancelButtonTitle: "OK")
                
            }
        }
        else {
            showAlertWithTitle(title: "Warning", message: "Your to-do needs a name.", cancelButtonTitle: "OK")
        }
    }
    
    private func showAlertWithTitle(title: String, message: String, cancelButtonTitle: String) {
        // Initialize Alert Controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Configure Alert Controller
        alertController.addAction(UIAlertAction(title: cancelButtonTitle, style: .default, handler: nil))
        
        // Present Alert Controller
        present(alertController, animated: true, completion: nil)
    }
    
}
