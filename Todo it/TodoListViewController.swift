//
//  ViewController.swift
//  Todo it
//
//  Created by Muhammed ikbal Can on 22.04.2018.
//  Copyright © 2018 Muhammed ikbal Can. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["IOS öğren","Masraf yönetimi çak", "Bussiness model olustur"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // MARK - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count;
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    // MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
        if(tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }
    
    // MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        var alertTextView = UITextField()
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            // add e basilince burasi calisacak
                self.itemArray.append(alertTextView.text!)
            self.tableView.reloadData()
            }
        
        
        alert.addTextField { (alertTextF) in
            alertTextF.placeholder = "Create New Item"
            alertTextView = alertTextF
        }
        
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)

        
    }
    
    

}

