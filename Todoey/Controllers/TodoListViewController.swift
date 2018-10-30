//
//  ViewController.swift
//  Todoey
//
//  Created by Emma Boroson on 9/17/18.
//  Copyright © 2018 eboroson. All rights reserved.
//

import UIKit
import RealmSwift



// because this is type UITableViewController - no need to set ourself as delegate, data source, etc
class TodoListViewController: UITableViewController {
    // default name given to the table view outlet is "tableView"

    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    // this will be nil until we select it in the previous screen
    var selectedCategory : Category? {
        // will happen as soon as this value is set with a value
        didSet{
            loadItems()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        searchBar.delegate = self
        
        //at the start we want to load ALL in the persistant container
       // loadItems()
    
    }

    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //if todoitems is not null = return count, else 1
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create a cell using the reusable cell identifier we gave. Index path is that of the cell we are looking to populate
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        

        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            
            
            //check to see if it should be checked or not
            
            //Ternary opeartor ==>
            // value = condition ? valueIfTrue : valueIfFalse
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            //if we don't get a cell because there was no item
            cell.textLabel?.text = "No Items Added"
        }


        return cell
    }
    

    
    //MARK: Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //what to do when a cell is selected
        
        //get the item from the todoItems container at current selecdted row indexpath row
        if let item = todoItems?[indexPath.row] {
            //assuming it is not nil - then we can grab the item object
            do {
                try realm.write{
                    //here is what we want to write:
                    item.done = !item.done
                    
                    //if we want to DELETE:
                   // realm.delete(item)
                }
            } catch {
                print ("Error svaing done status, \(error)")
            }
        }
        
        //force tableView to call its data source method again
        tableView.reloadData()
        
        //make it DE-selected immediately so it doesn't stay highlighted
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    //MARK: - Add new items
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // want popup (UIAlert Controller) - with text field in that alert
     
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) {
            (action) in
            //what will happen once the user clicks the add item button on the UI alert
            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                } catch{
                    print("Error saving Item \(error)")
                }
            }

            self.tableView.reloadData()
        
        }
        
        // the closure in the below happens after the text field is ADDED to the alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        // add the action to our alertcontroller
        alert.addAction(action)
        //present our alrt
        present(alert, animated: true, completion: nil)
    
    }
    
  
    
    
    //"with" is the external parameter, "request" is whats used INTERNAL to the function
    // DEFAULT value for the REQUEST is Item.fetchRequest (if we call this without a parameter)
    //DEFAULT value for the myPREDICATE is nil -- meaning it might not have a value, which is why it's an optional
    func loadItems(){

        // all items belonging to current selected category,sorted by title
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)


        tableView.reloadData()
    }



}


//MARK: Search Bar Methods
extension TodoListViewController: UISearchBarDelegate{
    
    //this is the search bar delegate method
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //now want to reload table view using only items they searched for

        //title contains case and diacritic insensotive, based on argument, sorted by  --
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)

     tableView.reloadData()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
       loadItems()
            
            // this manages all the threads/processing
            // main thread is where you update your user interface elements
            DispatchQueue.main.async {
                //need to tell search bar to STOP being first responder in window (no longer currenlty selected)
                searchBar.resignFirstResponder()
            }
            
        
        }
    }

}
