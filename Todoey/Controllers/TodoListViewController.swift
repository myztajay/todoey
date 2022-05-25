//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    var itemArr = [Item]()
    // added a plist storage
    let defaults = UserDefaults.standard
    // get our filepath
    var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    // grab the context from coredata
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // grabs a file path for the users document director
        // retrieve plist
        //        if let items = defaults.array(forKey: "TodoListArr") as? [Item] {
        //            itemArr = items
        //        }
        //        let newItem = Item()
        //        newItem.title = "call mike"
        //        itemArr.append(newItem)
        //
        //        let newItem2 = Item()
        //        newItem2.title = "get eggs"
        //        itemArr.append(newItem2)
        searchBar.delegate = self
        loadItems()
    }
    //MARK: - TABLE VIEW SECION
    
    // callout how many rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArr.count
    }
    // callout which cell to return - assign data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // here is the cell type with identifier - indexPath will be passed as well as table auto magically to this fun
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = itemArr[indexPath.row]
        // next now that we have our cell - we assign it - now our cell is prepped lets return it
        cell.textLabel?.text = item.title
        item.isDone
        ? (cell.accessoryType = .checkmark)
        : (cell.accessoryType = .none)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ip = indexPath
        let selectedItem = itemArr[ip.row]
        // here to make sure we auto deselect
        tableView.deselectRow(at: ip, animated: true)
        // flip switch for checkmark
        selectedItem.isDone = !selectedItem.isDone
        //deletes from context
        //        context.delete(itemArr[ip.row])
        //        // removed it from the UI
        //        itemArr.remove(at: ip.row)
        self.saveItem()
        tableView.reloadData()
    }
    //MARK: - ADD ITEM SECTION
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var newTodoListItem = UITextField()
        
        // create an alert
        let alert = UIAlertController(title: "Create a todo list item" , message: "", preferredStyle: .alert)
        
        // action button withim the alert
        let action = UIAlertAction(title: "Add item", style: .default) { UIAlertAction in
            
            // grab the coredata context
            //form model based on core data entity and give the the coreDB context to work from
            let newItem = Item(context: self.context)
            newItem.title = newTodoListItem.text!
            // assign parent category
            newItem.parentCategory = self.selectedCategory
            self.itemArr.append(newItem)
            self.tableView.reloadData()
            self.saveItem()
        }
        
        // manually add that action
        alert.addAction(action)
        
        // add text field
        alert.addTextField {(alertTextField) in
            alertTextField.placeholder = "add a todo list item EX. call johnny"
            newTodoListItem = alertTextField
        }
        // finally present the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveItem() {
        // add to my custom plist
        do {
            try self.context.save()
        } catch {
            print("\(error)")
        }
    }
    
    //MARK: - Load Items
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format:"parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        // compound predicate
//        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
        do{
            itemArr =  try context.fetch(request)
        } catch {
            print("\(error)")
        }
        tableView.reloadData()
    }
}

//MARK: - SearchBar
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // request data
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format:"title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors  = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if  searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
