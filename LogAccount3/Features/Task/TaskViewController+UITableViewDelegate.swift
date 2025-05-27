//
//  TaskViewController+UITableViewDelegate.swift
//  LogAccount3
//
//  Created by Ana Carolina Palhares Poletto on 16/05/25.
//
import UIKit
// MARK: UITableViewDelegate
extension TaskViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let task = getTask(by: indexPath)
        
        let TaskDetailsVC = TaskDetailsViewController()
        TaskDetailsVC.taskName = task.name
        TaskDetailsVC.taskIsDone = task.isDone
        TaskDetailsVC.taskCategory = task.category
        TaskDetailsVC.taskDescription = task.description
        TaskDetailsVC.taskId = task.id
        
        TaskDetailsVC.delegate = self
        present(TaskDetailsVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            [weak self] (action, view, completionHandler) in
            
            if let taskToDelete = self?.getTask(by: indexPath) {
                
                Persistence.deleteTask(by: taskToDelete.id)
                
                self?.taskList = Persistence.getLoggedUser()?.userTaskList
            }
            
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        let swipe = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipe
        
    }
}

