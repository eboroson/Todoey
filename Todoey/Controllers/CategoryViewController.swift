//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Emma Boroson on 10/2/18.
//  Copyright © 2018 eboroson. All rights reserved.
//

import UIKit
import CoreData


class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    
    // get singleton "shared" which corresponds to our curren live application object
    // get our delegat's persisten container
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //at the start we want to load ALL in the persistant container
        loadCategories()

    }

    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create a cell using the reusable cell identifier we gave. Index path is that of the cell we are looking to populate.  Adds it to the table.
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        cell.textLabel?.text = categoryArray[indexPath.row].name
        
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
            destinationVC.selectedCategory = categoryArray[myIndexPath.row]
        }
    }
    
    
    
    
    //MARK: - Data Manipulation Methods
    
    func saveCategories(){
        // need to commit our context to permanent storage inside our persistent container
        do{
            try context.save()
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
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!

            self.categoryArray.append(newCategory)
            self.saveCategories()
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
    
    // th second half of this gets us backALL the category ns managed objects that were created using the CAtegory entity
    let myrequest : NSFetchRequest<Category> = Category.fetchRequest()
    
        //need to specify that the data type of the output of our request will be an array of categories
        do {
            //fetch the myrequest request
            categoryArray = try context.fetch(myrequest)
        } catch {
            print("Error loading categories \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    
 
}
