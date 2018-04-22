//
//  ViewController.swift
//  Todo it
//
//  Created by Muhammed ikbal Can on 22.04.2018.
//  Copyright © 2018 Muhammed ikbal Can. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    let defaults = UserDefaults.standard
    let arrayName = "todoListArrays"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item = Item()
        item.title = "IOS öğren"
        item.done = true
        
        itemArray.append(item)
        
        if let items = defaults.array(forKey: arrayName) as? [Item] {
            itemArray = items
        }
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // MARK - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count;
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
       
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    // MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = itemArray[indexPath.row]
        
        itemArray[indexPath.row].done = !item.done
     
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        var alertTextView = UITextField()
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            // add e basilince burasi calisacak
            
            let newItem = Item()
            newItem.title = alertTextView.text!
            
            self.itemArray.append(newItem)
            self.tableView.reloadData()
            self.defaults.set(self.itemArray, forKey: self.arrayName)
        }
        
        
        alert.addTextField { (alertTextF) in
            alertTextF.placeholder = "Create New Item"
            alertTextView = alertTextF
        }
        
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)

        
    }
    
    

}

