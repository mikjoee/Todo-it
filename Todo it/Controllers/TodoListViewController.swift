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
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
 //   let defaults = UserDefaults.standard
    let arrayName = "todoListArrays"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
      //  print(dataFilePath)
       
        loadItems()
        /*
        if let items = defaults.array(forKey: arrayName) as? [Item] {
            itemArray = items
        }
 
 */
        
        
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
     
        saveItem()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        var alertTextView = UITextField()
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // add e basilince burasi calisacak
            
            let newItem = Item()
            newItem.title = alertTextView.text!
            
            self.itemArray.append(newItem)
            self.saveItem()
        }
        
        alert.addTextField { (alertTextF) in
            alertTextF.placeholder = "Create New Item"
            alertTextView = alertTextF
        }
        
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)

        
        
    }
    
    func saveItem(){
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("Error encoding item array \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                
            }
            
        }
    }
    
    

}

