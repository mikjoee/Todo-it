import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    let arrayName = "todoListArrays"
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
     
    }
    
    // MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count;
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        let dt:String = item.date == nil ? "" : item.date!
        cell.textLabel?.text = "\(item.title!)  \(dt)"
        
        cell.accessoryType = item.done ? .checkmark : .none
     //   cell.backgroundColor = item.done ? .lightGray : .white
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = itemArray[indexPath.row]
        itemArray[indexPath.row].done = !item.done
        
        if(itemArray[indexPath.row].done){
            let dtstr: String = dateStr()
            itemArray[indexPath.row].date = "(\(dtstr))"
        }else{
            itemArray[indexPath.row].date = ""
        }
     
      //   context.delete(itemArray[indexPath.row]) //bu sekilde silebilirsin
      //   itemArray.remove(at: indexPath.row)
        saveItem()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        var alertTextView = UITextField()
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // add e basilince burasi calisacak
            let newItem = Item(context: self.context)
            newItem.title = alertTextView.text!
            newItem.done = false
            newItem.category = self.selectedCategory
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
    // MARK: - Model manipulation methods
    
    func saveItem(){
        do{
           try context.save()
        }catch{
            print("Error encoding item array \(error)")
        }
        self.tableView.reloadData()
    }
    
    // bu sekilde tanimlayinca parametre gondermezsen default deger veriyosun
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil){
        let categoryPredicate = NSPredicate(format: "category.name MATCHES %@", selectedCategory!.name!)
        
        if let additonalPredicate = predicate {
              request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additonalPredicate])
        }else{
              request.predicate = categoryPredicate
        }
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("Error fetching request \(error)")
        }
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
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request, predicate : predicate)
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

