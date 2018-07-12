//
//  ViewController.swift
//  ReviewAllknowledge
//
//  Created by Brian La on 7/12/18.
//  Copyright © 2018 BrianLa. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var managedObjectContext: NSManagedObjectContext!
    
    lazy var fetchedResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<NSFetchRequestResult> in
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.resultType = .managedObjectResultType
        
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //check managedObjectContext
        print(managedObjectContext)
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch  {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
        
        let nib = UINib(nibName: "ProductCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ProductCell.identifier)
        
        tableView.dataSource = self
        
        
    }
    
    func configureCell(cell: ProductCell, atIndexPath indexPath: NSIndexPath) {
        // Fetch Record
        let record = fetchedResultsController.object(at: indexPath as IndexPath)
//
        // Update Cell
//        if let name = record as! [NSManagedObject] {//} valueForKey("name") as? String {
//            cell.nameLabel.text = name
//        }
        if let item = record as? NSManagedObject {
            cell.title.text = item.value(forKey: "name") as! String
        }
        
//
//        if let done = record.valueForKey("done") as? Bool {
//            cell.doneButton.selected = done
//        }
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! ProductCell
                configureCell(cell: cell, atIndexPath: indexPath as NSIndexPath)
            }
            break
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .move:
            if let indexPath = indexPath {
//                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            
            if let newIndexPath = newIndexPath {
//                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            }
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueAddToDoViewController" {
            if let navigationController = segue.destination as? UINavigationController {
                if let viewController = navigationController.topViewController as? AddToDoViewController {
                    viewController.managedObjectContext = managedObjectContext
                }
            }
        }
    }

}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell
        
        configureCell(cell: cell, atIndexPath: indexPath as NSIndexPath)
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115.0
    }
}

