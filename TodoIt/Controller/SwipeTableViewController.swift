//
//  SwipeTableViewController.swift
//  TodoIt
//
//  Created by surya sai on 06/12/23.
//

import UIKit
import SwipeCellKit
import ColorKit

class SwipeTableViewController: UITableViewController,SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        cell.backgroundColor = UIColor.random()
        return cell   }
    
    
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
         guard orientation == .right else { return nil }

         let deleteAction = SwipeAction(style: .destructive, title: "Delete") { [unowned self] action, index in
       update(at: indexPath)
           //  tableView.reloadData()
             
         }

         // customize the action appearance
         deleteAction.image = UIImage(named: "Trash")

         return [deleteAction]
     }
    
    

    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
    
    func update(at indexPath:IndexPath) {
        //For Updatingcells
    }
}
