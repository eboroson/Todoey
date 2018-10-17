//
//  ViewController.swift
//  Todoey
//
//  Created by Emma Boroson on 9/17/18.
//  Copyright © 2018 eboroson. All rights reserved.
//

import UIKit
import CoreData


// because this is type UITableViewController - no need to set ourself as delegate, data source, etc
class TodoListViewController: UITableViewController {
    // default name given to the table view outlet is "tableView"

    var itemArray = [Item]()
    
    // this will be nil until we select it in the previous screen
    var selectedCategory : Category? {
        // will happen as soon as this value is set with a value
        didSet{
            loadItems()
        }
    }
    
    
    //let defaults = UserDefaults.standard
   
    // get singleton "shared" which corresponds to our curren live application object
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
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
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create a cell using the reusable cell identifier we gave. Index path is that of the cell we are looking to populate
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        

        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        
        
        //check to see if it should be checked or not
        
        //Ternary opeartor ==>
        // value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none

        return cell
    }
    

    
    //MARK: Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //grab the cell at the selected index path

        
        //if it's true, make it false, if false make it true
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
     
        // if we want to DELETE:
        
//        //this would remove it from the context
//        context.delete(itemArray[indexPath.row])
//        //then we can  remove the item from the item array
//        itemArray.remove(at: indexPath.row)

        saveItems()
        
        
        //force tableView to call its data source method again
        tableView.reloadData()
        

//            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none

        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    //MARK: - Add new items
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // want popup (UIAlert Controller) - with text field in that alert
     
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default, handler: {
            (action) in
            //what will happen once the user clicks the add item button on the UI alert
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            self.saveItems()
            
            //save the updated itemArray to user defaults with this new key
            //self.defaults.setValue(self.itemArray, forKey: "TodoListArray")
   // need to get the address of the simulator and of the sandbox where our app lives
            self.tableView.reloadData()
        
        })
        
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
    
    func saveItems(){
        // need to commit our context to permanent storage inside our persistent container
        
        
        do{
            try context.save()
        } catch{
            print("Error saving context \(error)")
        }

    }
    
    //"with" is the external parameter, "request" is whats used INTERNAL to the function
    // DEFAULT value for the REQUEST is Item.fetchRequest (if we call this without a parameter)
    //DEFAULT value for the myPREDICATE is nil -- meaning it might not have a value, which is why it's an optional
    func loadItems(with myrequest: NSFetchRequest<Item> = Item.fetchRequest(), myPredicate: NSPredicate? = nil){

        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = myPredicate {
            // assuming it's not nil
            myrequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate ])
        } else {
            // meaning the predicate parameter is nil
            myrequest.predicate = categoryPredicate
        }
        
        
        //need to specify that the data type of the output of our request will be an array of Items
      //  let myrequest : NSFetchRequest<Item> = Item.fetchRequest()
        do {
        //fetch the myrequest request
        itemArray = try context.fetch(myrequest)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    


}


//MARK: Search Bar Methods
extension TodoListViewController: UISearchBarDelegate{
    
    //this is the search bar delegate method
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //now want to reload table view using only items they searched for
        let myrequest : NSFetchRequest<Item> = Item.fetchRequest()
        
        //what is our query?  use an NSPredicate
        //replace %@ with the argument -- [cd] makes it case and diacritic INsensitive
       let mypredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        
        // we can sort the data we get back
        myrequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        // looks for an aRRAY of sort descriptors
        
        
//        do {
//            //fetch the myrequest request
//            itemArray = try context.fetch(myrequest)
//        } catch {
//            print("Error fetching data from context \(error)")
//        }
        loadItems(with: myrequest, myPredicate: mypredicate )
        
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
