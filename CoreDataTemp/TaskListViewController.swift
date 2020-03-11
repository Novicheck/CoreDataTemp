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
    private var tasks: [Task] = []
    private let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        fetchData()
    }
     
    @objc func addNewTask() {
        showAllertController(with: "New Task", and: "What do you want to do")
    }
    
    func save(taskName: String) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: viewContext) else { return }
        let task = NSManagedObject(entity: entityDescription, insertInto: viewContext) as! Task
        task.name = taskName
        do {
            try viewContext.save()
            tasks.append(task)
            
            let cellIndex = IndexPath(row: self.tasks.count - 1, section: 0)
            self.tableView.insertRows(at: [cellIndex], with: .left)
        
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func fetchData () {
        let fetchRequest: NSFetchRequest = Task.fetchRequest()
        do {
            tasks = try viewContext.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
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
        return cell
    }
}

//MARK: AllertController
extension TaskListViewController {
    func showAllertController(with title: String, and message: String) {
        let allertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self]_ in
            guard let self = self else {return}
            guard let task = allertController.textFields?.first?.text, !task.isEmpty else {return}
            self.save(taskName: task)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        allertController.addTextField()
        allertController.addAction(saveAction)
        allertController.addAction(cancelAction)
        present(allertController, animated: true, completion: nil)
    }
}
