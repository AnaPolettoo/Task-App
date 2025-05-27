//
//  AddTaskDelegate.swift
//  LogAccount3
//
//  Created by Ana Carolina Palhares Poletto on 03/05/25.
//
import UIKit

protocol AddTaskDelegate: AnyObject {
    func didAddTask(task: Task)
}

class AddTaskViewController: UIViewController {
    
    // MARK: Header
    lazy var header: HeaderView = {
        var header = HeaderView()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.title = "New Task"
        
        header.cancelButtonAction = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        header.addButtonAction = { [weak self] in
            self?.addButtonTapped()
        }
        
        return header
    }()
    
    // MARK: Name
    lazy var taskComponent : NamedTextField = {
        var view = NamedTextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.name = "Task"
        view.placeholder = "Your task name here"
        view.nameTextField.layer.borderWidth = 0
        view.delegate = self
        return view
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
        textField.text = "More details about the task"
        textField.font = UIFont(name: "SFPro-Regular", size: 17)
        textField.textColor = .tertiaryLabel
        textField.textContainerInset = UIEdgeInsets(top: 12, left: 6, bottom: 12, right: 12)
        textField.backgroundColor = .backgroundTertiary
        textField.layer.cornerRadius = 8
        textField.delegate = self
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
            taskComponent, categorySelector, descriptionStack
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    // MARK: Properties
    weak var delegate: AddTaskDelegate?
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapDismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapDismissKeyboard)
        
        view.backgroundColor = .backgroundSecondary
        
        setup()
    }
    

    func cleanViewValues() {
        taskComponent.text = ""
        categorySelector.selectedCategory = nil
        descriptionTextField.text = ""
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func addButtonTapped() {
        let newTask = Task(name: taskComponent.text ?? "no name",
                         category: categorySelector.selectedCategory ?? .Other, description: descriptionTextField.text ?? "no description")
        
        var user = Persistence.getLoggedUser()
        user?.userTaskList.append(newTask)
        
        Persistence.saveLoggedUser(user)
        
        cleanViewValues()
        
        let taskList = Persistence.getLoggedUser()?.userTaskList
        taskList?.forEach { print($0) }
        
        //ver se tem task para ser add
        delegate?.didAddTask(task: newTask)
        
        dismiss(animated: true)
    }

}

    // MARK: ViewCodeProtocol
    extension AddTaskViewController: ViewCodeProtocol {

    func addSubViews() {
        view.addSubview(header)
        view.addSubview(bigStack)
    }

    func setupConstraints() {
        
        NSLayoutConstraint.activate([
        
            header.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            
            taskComponent.nameTextField.heightAnchor.constraint(equalToConstant: 46),
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
            
        ])
        
    }

    }

// MARK: UITextFieldDelegate
extension AddTaskViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        header.addButtonIsEnabled = !(range.location == 0 && string.isEmpty)
        return true
    }
}

extension AddTaskViewController: UITextViewDelegate {
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

