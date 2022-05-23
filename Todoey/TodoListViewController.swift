//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    let itemArr = ["find a jpb", "have more meaningful sex", "make $1m dollar"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // callout how many rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArr.count
    }
    // callout which cell to return - assign data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // here is the cell type with identifier - indexPath will be passed as well as table auto magically to this fun
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        // next now that we have our cell - we assign it - now our cell is prepped lets return it
        cell.textLabel?.text = itemArr[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ip = indexPath
        // here to make sure we auto deselect
        tableView.deselectRow(at: ip, animated: true)
        let selectedCell = tableView.cellForRow(at: ip)
        // check for checkmark
        let hasCheckmark = tableView.cellForRow(at: ip)?.accessoryType == .checkmark
        // flip switch for checkmark
        hasCheckmark
        ? (selectedCell?.accessoryType = .none)
        : (selectedCell?.accessoryType = .checkmark)
    }


}

