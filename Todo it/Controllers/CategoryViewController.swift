
import UIKit
import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {

    
    let realm = try! Realm()        // en iyi sekilde olusturmanin yolu bu
    
    var categoryArray: Results<Category>?   // realm db den okurken bu tipte donucek
    // tipki hibernate gibi bu tipte bir obje olusturursan db de direk olusturuyor

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }


    
    // Mark: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1        // nil coalesing operator nil olabilir nilse 1 degilse kendini dondur
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added Yet"
    
        return cell
    }
    
    // Mark: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    // Mark: - Model Manipulation Methods
    
    
    // Mark: - Add New Category
  
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        var alertTextField = UITextField()
    
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = alertTextField.text!
            
            
            self.saveCategory(category: newCategory)
        }
        alert.addAction(action)
        alert.addTextField { (textField) in
            alertTextField = textField
        }
        present(alert, animated: true, completion: nil)
    }
    
    
    // Mark: - Save Category
    
    func saveCategory(category : Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error when try to save categories \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(){
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
}
