//
//  ViewController.swift
//  TodoIt
//
//  Created by surya sai on 01/12/23.
//

import UIKit
import CoreData

class TodoListViewController: SwipeTableViewController,UISearchBarDelegate{
    let context = AppDelegate().persistentContainer.viewContext
    var  itemArray:[Item] = []
    var selectedCategory:Category? {
       didSet {
            loadItems()
        }
       
    }
    var defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first?.appendingPathComponent("Items.plist")
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        searchBar.delegate = self
        tableView.rowHeight = 80.0
        // print(FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first?.appendingPathComponent("Items.plist"))
        super.viewDidLoad()
        navigationController?.navigationBar.backgroundColor = UIColor.random()
       
        }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark:.none
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = itemArray[indexPath.row]
        item.done = !item.done
       // context.delete(itemArray.remove(at: indexPath.row))
       saveData()
        tableView.reloadData()
    
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Todo item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) {[unowned self] (action) in
            let text:String! = alert.textFields?.first?.text
            let item = Item(context: context)
            item.title = text
            item.done = false
            item.category = selectedCategory?.name
            
            itemArray.append(item)
            
           // print(itemArray.count)
            saveData()
            tableView.reloadData()
        }
        alert.addTextField {
            $0.placeholder = "Add new item"
        }
        alert.addAction(action)
        present(alert, animated: true,completion: nil)
        
        
        
    }
    func saveData() {
     try? context.save()
      
    }
    
    func loadItems() {
      let request = Item.fetchRequest()
        let predicate = NSPredicate(format: "category MATCHES %@",selectedCategory!.name!)
        request.predicate = predicate
      itemArray = try! context.fetch(request)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request = Item.fetchRequest()
        let predicate1 = NSPredicate(format: "title contains[cd] %@",searchBar.text!)
        let predicate2 = NSPredicate(format: "category MATCHES %@",selectedCategory!.name!)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1,predicate2])
        let sortdescpritor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortdescpritor]
        itemArray = try! context.fetch(request)
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text! == "" {
            loadItems()
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
       
            
        }
    }
    
    override func update(at indexPath: IndexPath) {
        let item = itemArray.remove(at: indexPath.row)
        context.delete(item)
        saveData()
        
    }
    
}
