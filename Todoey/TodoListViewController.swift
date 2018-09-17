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

    let itemArray = ["Find Mike","Buy Eggos","Destroy Demogorgon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create a cell using the reusable cell identifier we gave. Index path is that of the cell we are looking to populate
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
//    bool line 1 = View Table 1
//    look at count function
//    bool line 2 = View Table 1
//    look at change color function
//    bool line 3 = View Table 2
//    look at inverse all numbers function
//
//    RUN!
    
    //MARK: Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //grab the cell at the selected index path
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {

            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            

        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    
    


}

