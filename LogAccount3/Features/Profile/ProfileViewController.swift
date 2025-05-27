import UIKit

class ProfileViewController: UIViewController {
    
    var userName = Persistence.getLoggedUser()?.name
    var userDataofBirth = Persistence.getLoggedUser()?.dateOfBirth
    var userEmail = Persistence.getLoggedUser()?.email
    
    
    lazy var nameComponent : NamedTextField = {
        var view = NamedTextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.nameTextField.layer.borderWidth = 0
        view.placeholder = userName
        view.nameTextField.isEnabled = false
        return view
    }()
    
    lazy var dateLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Date of Birth"
        label.font = UIFont(name: "SFPro-Regular", size: 16)
        label.textColor = .labelPrimary

        return label
    }()
    
    // MARK: Date
    lazy var birthDatePicker: UIDatePicker = {
        var datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "en_US_POSIX")
        datePicker.date = userDataofBirth ?? Date()
        datePicker.isEnabled = false
        return datePicker
    }()
    
    lazy var birthStack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [dateLabel, birthDatePicker])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        return stack
    }()
    
    // MARK: Email
    lazy var emailComponent : NamedTextField = {
        var view = NamedTextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.name = "Email"
        view.placeholder = userEmail
        view.nameTextField.layer.borderWidth = 0
        view.nameTextField.isEnabled = false
        return view
    }()
    
    lazy var bigStack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [
            nameComponent, birthStack, emailComponent
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()
    
    //MARK: Logout button
    lazy var signOutButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Out", for: .normal)
        button.configuration = .filled()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.accent, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFPro-Regular-Semibold", size: 17)
        button.layer.cornerRadius = 8
        button.tintColor = .backgroundTertiary
        button.layer.borderWidth = 0
        button.addTarget(self, action: #selector(tappedButtonSignOut), for: .touchUpInside)
        return button
    }()
    
    //MARK: Delete button
    lazy var deleteButton : UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Delete Account", for: .normal)
        button.configuration = .filled()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFPro-Regular-Semibold", size: 17)
        button.layer.cornerRadius = 8
        button.tintColor = .backgroundTertiary
        button.layer.borderWidth = 0
        button.addTarget(self, action: #selector(tappedButtonDelet), for: .touchUpInside)
        return button
    }()
    
    
    lazy var buttonStack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [
            signOutButton, deleteButton
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .backgroundSecondary
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(bigStack)
        view.addSubview(buttonStack)
        
        
        NSLayoutConstraint.activate([
        
            emailComponent.nameTextField.heightAnchor.constraint(equalToConstant: 50),
            nameComponent.nameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            
            bigStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            bigStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            bigStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            signOutButton.heightAnchor.constraint(equalToConstant: 50),
            deleteButton.heightAnchor.constraint(equalToConstant: 50),
            
            buttonStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 621),
            buttonStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            buttonStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
        ])
    }
    
    
    @objc func tappedButtonSignOut() {
        let loginViewController = UINavigationController(rootViewController: LoginViewController())
        
        let getLoggedUser = Persistence.getLoggedUser()
            
        if let loggedUser = getLoggedUser {
            Persistence.saveUser(newUser: loggedUser)
        }
        
         
        UserDefaults.standard.removeObject(forKey: Persistence.userLog)
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginViewController)
    }
    
    @objc func tappedButtonDelet() {
        let loginViewController = UINavigationController(rootViewController: LoginViewController())
        Persistence.deleteUser()
        UserDefaults.standard.removeObject(forKey: Persistence.userLog)
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginViewController)
    }

}

