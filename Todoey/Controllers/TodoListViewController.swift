//
//  ViewController.swift
//  Todoey
//
//  Created by Emma Boroson on 9/17/18.
//  Copyright © 2018 eboroson. All rights reserved.
//

import UIKit

// because this is type UITableViewController - no need to set ourself as delegate, data source, etc
class TodoListViewController: UITableViewController {
    // default name given to the table view outlet is "tableView"

    var itemArray = [Item]()
    
    //let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        


//        let newItem = Item()
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
//        
//        let newItem2 = Item()
//        newItem2.title = "Buy Eggos"
//        itemArray.append(newItem2)
//        
//        let newItem3 = Item()
//        newItem3.title = "Destroy Demogorgon"
//        itemArray.append(newItem3)
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item]{
//            itemArray = items
//        }
        
        loadItems()
    
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
        //now want to save this to the plist we made
        
        
        
        //force tableView to call its data source method again
        tableView.reloadData()
        

//            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none

        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // want popup (UIAlert Controller) - with text field in that alert
     
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default, handler: {
            (action) in
            //what will happen once the user clicks the add item button on the UI alert

            let newItem = Item()
            newItem.title = textField.text!
            
            
            self.itemArray.append(newItem)
            self.saveItems()
            
            //save the updated itemArray to user defaults with this new key
            //self.defaults.setValue(self.itemArray, forKey: "TodoListArray")
            
                        // need to get the address of the simular and of the sandbox where our app lives
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
        //encodes into a plist
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            //write data to our data file path
            try data.write(to: dataFilePath!)
        } catch{
            print("Error encoding item array, \(error)")
        }

    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
            itemArray = try decoder.decode([Item].self, from: data)
            } catch{
                print("Error decoding item array, \(error)")
            }
        }
    }


}

