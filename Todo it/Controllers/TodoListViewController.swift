import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
 
    var items : Results<Item>?
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    let arrayName = "todoListArrays"
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    // MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No Items added"
        }
       
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = items?[indexPath.row]{
            do{
                try realm.write {
                    // realm.delete(item)
                    item.done  = !item.done
                }
            }catch{
                print("Error when trying to done item + \(error)")
            }
            tableView.reloadData()
        }
  
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        var alertTextView = UITextField()
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // add e basilince burasi calisacak
            
            if let currentCategory = self.selectedCategory{
                 do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = alertTextView.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }
                 catch{
                    print("Error when trying to save items, \(error)")
                }
               self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (alertTextF) in
            alertTextF.placeholder = "Create New Item"
            alertTextView = alertTextF
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    // MARK: - Model manipulation methods
    
    func saveItem(){
       
        self.tableView.reloadData()
    }
    
    // bu sekilde tanimlayinca parametre gondermezsen default deger veriyosun
    func loadItems(){
        items = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }
    
    // MARK: - Service Methods
    func dateStr() -> String{
        
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let datestr: String = "\(year)-\(month)-\(day)"
        return datestr
    }
}

// MARK: - Extension class
extension TodoListViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder() // eski haline donduruyor kapatiyor
            }

        }
    }
}

