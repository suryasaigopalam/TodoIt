//
//  CategoryViewController.swift
//  TodoIt
//
//  Created by surya sai on 05/12/23.
//

import UIKit
import CoreData

class CategoryViewController: SwipeTableViewController {
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryArray:[Category] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
//      print(FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first?.appendingPathComponent("Items.plist"))
        loadData()
        navigationController?.navigationBar.backgroundColor = UIColor.random()
    }
   
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add Category", style: .default) {[unowned self] UIAlertAction in
            let category = Category(context: context)
            let text:String! = alert.textFields?.first?.text
            category.name = text
          categoryArray.append(category)
            saveData()
            tableView.reloadData()
            
        }
        alert.addTextField() {
            $0.placeholder = "Category Name"
        }
        alert.addAction(alertAction)
        present(alert, animated: true)
   
        }
    
    
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    categoryArray.count
     
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = super.tableView(tableView, cellForRowAt: indexPath)
        category.textLabel?.text = categoryArray[indexPath.row].name
        return category
   }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       performSegue(withIdentifier:"goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        let indexPath = tableView.indexPathForSelectedRow!
        destinationVC.selectedCategory = categoryArray[indexPath.row]
        
    }
    func saveData() {
     try? context.save()
      
    }
    func loadData() {
        categoryArray = try! context.fetch(Category.fetchRequest())
    }

    
    override func update(at indexPath: IndexPath) {
        let category = categoryArray.remove(at: indexPath.row)
        let request = Item.fetchRequest()
        request.predicate = NSPredicate(format: "category MATCHES %@",category.name!)
      let items:[Item] = try! context.fetch(request)
        for item in items {
            context.delete(item)
        }
        context.delete(category)
        try! context.save()
    }
}
