//
//  TaskDescriptionViewController.swift
//  LogAccount3
//
//  Created by Ana Carolina Palhares Poletto on 08/05/25.
//
import UIKit

protocol DetailsTaskDelegate: AnyObject {
    func didAddTask(task: Task)
}
class TaskDetailsViewController: UIViewController {
    var taskName: String?
    var taskIsDone: Bool?
    var taskDescription: String?
    var taskCategory: Category?
    var taskId: UUID?
    
    lazy var header: HeaderView = {
        var header = HeaderView()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.title = "Task Details"
        
        header.cancelButtonAction = { [weak self] in
            self?.dismiss(animated: true)
        
        }
        
        header.addButton.setTitle("Done", for: .normal)
        header.addButton.setTitle("Done", for: .disabled)
        header.addButton.isEnabled = true
        header.addButtonAction = { [weak self] in
            self?.doneButtonTapped()
        }
        
        return header
    }()
    
    // MARK: Name
    lazy var taskComponent : NamedTextField = {
        var view = NamedTextField()
        view.nameTextField.layer.borderWidth = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.name = "Task"
        view.text = taskName
        return view
    }()
    
    lazy var button: UIButton = {
        var button = UIButton()
        if let isDone = taskIsDone {
            button.setImage(UIImage(systemName: isDone ? "checkmark.circle.fill" : "circle") , for: .normal)
            button.tintColor = isDone ? .accent : .labelSecondary
        }
        
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var label: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "SFPro-Regular-Semibold", size: 16)
        label.textColor = .label
        label.text = "Status"
        return label
    }()
    
    lazy var isDoneStack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [button, label])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 12
        stack.backgroundColor = .backgroundTertiary
        stack.layer.cornerRadius = 8
        
        stack.layoutMargins = UIEdgeInsets(top: 6.75, left: 16, bottom: 6.75, right: 16)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    // MARK: Description
    lazy var descriptionLabel : UILabel = {
        var label = UILabel()
        label.text = "Description"
        label.textColor = .label
        label.font = UIFont(name: "SFPro-Regular", size: 16)
        return label
    }()
    
    lazy var descriptionTextField: UITextView = {
        let textField = UITextView()
        textField.text = taskDescription
        textField.textColor = .label
        textField.font = UIFont(name: "SFPro-Regular", size: 17)
        textField.textContainerInset = UIEdgeInsets(top: 12, left: 6, bottom: 12, right: 12)
        textField.backgroundColor = .backgroundTertiary
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    lazy var descriptionStack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [descriptionLabel, descriptionTextField])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    // MARK: Category Selector
    lazy var categorySelector = CategorySelector()
    
    // MARK: BigStack
    lazy var bigStack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [
            taskComponent, categorySelector, isDoneStack, descriptionStack
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    lazy var deleteButton : UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Delete Task", for: .normal)
        button.configuration = .filled()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFPro-Regular-Semibold", size: 17)
        button.layer.cornerRadius = 8
        button.tintColor = .backgroundTertiary
        button.layer.borderWidth = 0
        button.addTarget(self, action: #selector(tappedButtonDelete), for: .touchUpInside)
        return button
    }()
    
    // MARK: Properties
    weak var delegate: AddTaskDelegate?
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapDismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapDismissKeyboard)
        
        view.backgroundColor = .backgroundSecondary
        
        categorySelector.selectedCategory = taskCategory
        
        setup()
    }

    func cleanViewValues() {
        taskComponent.text = ""
        categorySelector.selectedCategory = nil
        descriptionTextField.text = ""
    }
    
    @objc func buttonTapped() {
        
        if var isDone = taskIsDone{
            isDone.toggle()

            button.setImage(UIImage(systemName: isDone ? "checkmark.circle.fill" : "circle") , for: .normal)
            button.tintColor = isDone ? .accent : .labelSecondary
            
            taskIsDone = isDone
        }
        
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func doneButtonTapped() {
        let updateTask = Task(name: taskComponent.text ?? "no name",
                           category: categorySelector.selectedCategory ?? .Other, description: descriptionTextField.text ?? "no description", isDone: taskIsDone ?? false)
        
        var user = Persistence.getLoggedUser()
        user?.userTaskList.removeAll(where: { $0.id == taskId})
        user?.userTaskList.append(updateTask)
        
        Persistence.saveLoggedUser(user)
        
        cleanViewValues()
        
        let taskList = Persistence.getLoggedUser()?.userTaskList
        taskList?.forEach { print($0) }
        
        //ver se tem task para ser add
        delegate?.didAddTask(task: updateTask)
        
        dismiss(animated: true)
    }
    
    @objc func tappedButtonDelete() {
        let tabBarController = UINavigationController(rootViewController: TabBarController())
        guard let id = taskId else { return }
        Persistence.deleteTask(by: id)
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(tabBarController)
    }
    
    

}

    // MARK: ViewCodeProtocol
extension TaskDetailsViewController: ViewCodeProtocol {

    func addSubViews() {
        view.addSubview(header)
        view.addSubview(bigStack)
        view.addSubview(deleteButton)
    }

    func setupConstraints() {
        
        NSLayoutConstraint.activate([
        
            header.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            
            taskComponent.nameTextField.heightAnchor.constraint(equalToConstant: 46),
            isDoneStack.heightAnchor.constraint(equalToConstant: 46),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 112),
            
            bigStack.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            bigStack.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
            bigStack.topAnchor.constraint(
                equalTo: header.bottomAnchor,
                constant: 20
            ),
            
            deleteButton.heightAnchor.constraint(equalToConstant: 50),
            deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            deleteButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            deleteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
        ])
        
    }

    }

extension TaskDetailsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "More details about the task" {
            textView.text = ""
            textView.textColor = .label
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "More details about the task"
            textView.textColor = .secondaryLabel
        }
    }
}

