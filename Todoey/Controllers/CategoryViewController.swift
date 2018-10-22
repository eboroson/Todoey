//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Emma Boroson on 10/2/18.
//  Copyright © 2018 eboroson. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryViewController: UITableViewController {

    // try! hints at possibly bad code... but in this case, it's okay
    let realm = try! Realm()
    
    //this is an AUTO-updated container type from Realm - returned from object queries
    var categories: Results<Category>?
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }

    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //get count of categories ONLY IF categories is not null.  If it IS nil, then use 1 instead
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create a cell using the reusable cell identifier we gave. Index path is that of the cell we are looking to populate.  Adds it to the table.
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // we only have one segue, so we don't need an if statement here
        let destinationVC = segue.destination as! TodoListViewController
        
        //get the category that corresponds with the selected cell
        // this may be nil if nothing has been selected
        if let myIndexPath = tableView.indexPathForSelectedRow{
            // set a property in the destination VC
            destinationVC.selectedCategory = categories?[myIndexPath.row]
        }
    }
    
    
    
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category){
        // need to commit our context to permanent storage inside our persistent container
        do{
            try realm.write{
                realm.add(category)
            }
        } catch{
            print("Error saving category \(error)")
        }
    }
    
    
    
    //MARK: - Add new categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        // want popup (UIAlert Controller) - with text field in that alert
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default, handler: {
            (action) in
            //what will happen once the user clicks the 'add category' button on the UI alert
            
            let newCategory = Category()
            newCategory.name = textField.text!

            self.save(category: newCategory)
            self.tableView.reloadData()
            
        })
        
        
        // add the action to our alertcontroller
        alert.addAction(action)
        
        // the closure in the below happens after the text field is ADDED to the alert
        //"alertTextField" is what we're calling our text field
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new category"
            textField = alertTextField
        }
        
        //present our alert view controller
        present(alert, animated: true, completion: nil)
        
        
    }
    


    

    

    //"with" is the external parameter, "request" is whats used INTERNAL to the function
    // DEFAULT value for the REQUEST is Item.fetchRequest (if we call this without a parameter)
    func loadCategories(){
    
        //pulls all objects inside Realm of type Category
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    
    
 
}
