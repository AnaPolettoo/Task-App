//
//  TaskViewController+UITableViewDataSource.swift
//  LogAccount3
//
//  Created by Ana Carolina Palhares Poletto on 16/05/25.
//
import UIKit
// MARK: UITableViewDataSource
extension TaskViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].rawValue.uppercased()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        emptyView.isHidden = !sections.isEmpty
        tableView.isHidden = sections.isEmpty
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskViewCell.reuseIdentifier, for: indexPath) as? TaskViewCell else {
            return UITableViewCell()
        }
        
        let task = getTask(by: indexPath)
        
        
        cell.config(labelText: task.name, isDone: task.isDone) { [weak self] in
            Persistence.toggleTaskStatus(by: task.id)
            self?.taskList = Persistence.getLoggedUser()?.userTaskList

            
        }
        
        return cell
    }
    
    
}
