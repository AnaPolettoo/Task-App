import UIKit

class TaskViewController: UIViewController, DetailsTaskDelegate {
    
    // MARK: Plus button
    lazy var addButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(systemName: "plus"),
                               style: .plain,
                               target: self,
                               action: #selector(addTaskButtonTapped))
    }()
    
    lazy var tableView: UITableView = {
        var table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "default-cell")
        table.register(TaskViewCell.self, forCellReuseIdentifier: TaskViewCell.reuseIdentifier)
        return table
    }()
    
    lazy var emptyView: EmptyState = {
        var empty = EmptyState()
        empty.translatesAutoresizingMaskIntoConstraints = false
        empty.image = .noTasks
        empty.titleText = "No tasks yet!"
        empty.descriptionText = "Add a new task and it will show up here."
        empty.buttonTitle = "Add New task"
        empty.buttonAction = { [weak self] in
            self?.addTaskButtonTapped()
        }
        return empty
    }()
    
    // MARK: Properties
    var taskList = Persistence.getLoggedUser()?.userTaskList {
        didSet {
            buildContent()
            tableView.reloadData()
        }
    }
    
    var sections: [Category] = []
    var rows: [[Task]] = []
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tasks"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = addButtonItem
        navigationController?.navigationBar.prefersLargeTitles = true
        self.taskList = Persistence.getLoggedUser()?.userTaskList
        setup()
    }
    
    
    @objc func addTaskButtonTapped() {
        let addTaskVC = AddTaskViewController()
        addTaskVC.delegate = self
        present(addTaskVC, animated: true)
    }
    
    func buildContent() {
        sections = buildSections()
        rows = buildRows()
    }
    func buildSections() -> [Category] {
        var sections: [Category] = []
        
        for category in Category.allCases {
            
            if let taskList = taskList {
                let hasCategory = taskList.contains(where: {$0.category == category})
                
                if hasCategory {
                    sections.append(category)
                }
            }
        }
        
        return sections
    }
    
    func buildRows() -> [[Task]] {
        var rows: [[Task]] = []
        
        for section in sections {
            if let taskList = taskList {
                rows.append(taskList.filter({ $0.category == section }))
            }
        }
        
        return rows
    }
    
    func getTask(by indexPath: IndexPath) -> Task {
        let tasksOfSection = rows[indexPath.section]
        let task = tasksOfSection[indexPath.row]
        return task
    }
}

extension TaskViewController: AddTaskDelegate {
    func didAddTask(task: Task) {
        taskList = Persistence.getLoggedUser()?.userTaskList
    }
}


// MARK: ViewCodeProtocol
extension TaskViewController: ViewCodeProtocol {
    
    func addSubViews() {
        view.addSubview(emptyView)
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
}
