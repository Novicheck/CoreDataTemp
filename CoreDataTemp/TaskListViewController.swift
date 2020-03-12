//
//  ViewController.swift
//  CoreDataTemp
//
//  Created by Denis on 11.03.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import UIKit
import CoreData

class TaskListViewController: UITableViewController {
    
    private let cellId = "cell"
    private var tasks = [Task]()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tasks = DataManager.shared.fetchData()
    }
     
    @objc func addNewTask() {
        showAllertController(with: "New Task", and: "What do you want to do")
    }
}

//MARK: Setup Navigation Controller
extension TaskListViewController {
    func setupNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Task List"
        
        if #available(iOS 13.0, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()
            navigationBarAppearance.backgroundColor = UIColor(red: 21/255, green: 101/255, blue: 192/255, alpha: 194/255)
            navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navigationController?.navigationBar.standardAppearance = navigationBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTask))
            navigationController?.navigationBar.tintColor = .white
        }
    }
}

//MARK: UITableViewDataSource, UITableViewDelegate
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let cellText = tasks[indexPath.row].name
        cell.textLabel?.text = cellText
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            DataManager.shared.deleteTask(task: task)
            tasks.remove(at: tasks.firstIndex(of: task) ?? 0)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        showAllertController(with: "Edit Task", and: "Enter text", task: task, indexPath: indexPath)
    }
}

//MARK: AllertController
extension TaskListViewController {
    func showAllertController(with title: String, and message: String, task: Task? = nil, indexPath: IndexPath? = nil) {
        let allertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let self = self else {return}
            guard let taskName = allertController.textFields?.first?.text, !taskName.isEmpty else {return}
            
            if let task = task {
                task.name = taskName
                DataManager.shared.saveContext()
                guard let indexPath = indexPath else {return}
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            } else {
                guard let newTask = DataManager.shared.saveToInsert(taskName: taskName) else {return}
                self.tasks.append(newTask)
                let lastIndex = self.tasks.count
                let cellIndex = IndexPath(row: lastIndex - 1, section: 0)
                self.tableView.insertRows(at: [cellIndex], with: .left)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        allertController.addTextField { textField in
            if let name = task?.name {
            textField.text = name
            }
        }
        allertController.addAction(saveAction)
        allertController.addAction(cancelAction)
        
        present(allertController, animated: true, completion: nil)
    }
}
