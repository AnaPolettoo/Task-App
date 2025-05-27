import UIKit

class CreateAccountViewController:
    
    UIViewController {
    lazy var background: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .backgroundSecondary
        return view
    }()

    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Create Account"
        label.textAlignment = .center
        label.font = UIFont(name: "SFProRounded-Bold", size: 34)
        label.textColor = .labelPrimary
        return label
    }()

    // MARK: Name
    lazy var nameComponent : NamedTextField = {
        var view = NamedTextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
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
    
    lazy var birthDatePicker: UIDatePicker = {
        var datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "en_US_POSIX")
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
        view.placeholder = "abc@abc.com"
        view.delegate = self
        return view
    }()
    
    // MARK: Password
    lazy var passwordComponent : NamedTextField = {
        var view = NamedTextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.name = "Password"
        view.placeholder = "Must be 8 characters"
        view.delegate = self
        return view
    }()
    
    lazy var termLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "I accept the term and privacy policy"
        label.font = UIFont(name: "SFPro-Regular", size: 16)
        label.textColor = .labelPrimary
        return label
    }()
    
    lazy var termSwitch: UISwitch = {
        var switchControl = UISwitch()
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.isOn = false
        return switchControl
    }()

    lazy var termStack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [termSwitch, termLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 16
        return stack
    }()

    
    lazy var longError : CheckPassword = {
        var view = CheckPassword()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "At least 8 characters"
        return view
    }()
    
    lazy var numeberError : CheckPassword = {
        var view = CheckPassword()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "At least 1 number"
        return view
    }()
    
    lazy var upperError : CheckPassword = {
        var view = CheckPassword()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "At least 1 uppercase letter"
        return view
    }()
    
    lazy var specialError : CheckPassword = {
        var view = CheckPassword()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "At least 1 special character"
        return view
    }()
    
    
    lazy var invalidPassword: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [
            longError, numeberError, specialError, upperError
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    
    lazy var bigStack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [
            nameComponent, birthStack, emailComponent, passwordComponent, invalidPassword, termStack
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    
    lazy var createAccountButton: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Create Account", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.titleLabel?.font = UIFont(name: "SFPro-Regular", size: 17)
        button.layer.cornerRadius = 12
        button.configuration = .filled()
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        return button
    }()    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordComponent.nameTextField.delegate = self
        passwordComponent.nameTextField.tag = 1

        let tapDismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))

        view.addGestureRecognizer(tapDismissKeyboard)
        view.backgroundColor = .systemBackground


        setup()
    }

    
    
    func cleanViewValues() {
        nameComponent.text = ""
        birthDatePicker.date = .now
        termSwitch.isOn = false
        emailComponent.text = ""
        passwordComponent.text = ""
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func createButtonTapped() {
        
        if let name = nameComponent.text, let email = emailComponent.text, let password = passwordComponent.text, !name.isEmpty, !email.isEmpty, !password.isEmpty {
        
            let newAccount = User(name: nameComponent.text ?? "Lara", dateOfBirth: birthDatePicker.date, email: emailComponent.text ?? "lara@gmail.com", password: passwordComponent.text ?? "123456", terms: termSwitch.isOn, userTaskList: [])
            
            Persistence.saveUser(newUser: newAccount)
        
            guard let users = Persistence.getUsersList() else { return }
            users.forEach { print($0) }
            
            navigationController?.popViewController(animated: true)
            cleanViewValues()
        }

    }
    
}

extension CreateAccountViewController: ViewCodeProtocol {
    
    func addSubViews() {
        view.addSubview(background)
        view.addSubview(titleLabel)

        view.addSubview(nameComponent)
        view.addSubview(emailComponent)
        view.addSubview(passwordComponent)

        view.addSubview(bigStack)
        
        view.addSubview(createAccountButton)
        
        
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            background.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 0
            ),
            background.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: 0
            ),
            background.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            background.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: 0
            ),
            
            titleLabel.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
            titleLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 32
            ),
            
            nameComponent.nameTextField.heightAnchor.constraint(equalToConstant: 46),
            emailComponent.nameTextField.heightAnchor.constraint(equalToConstant: 46),
            passwordComponent.nameTextField.heightAnchor.constraint(equalToConstant: 46),
            
            bigStack.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            bigStack.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
            bigStack.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 141
            ),
            
            
            createAccountButton.heightAnchor.constraint(equalToConstant: 50),
            createAccountButton.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            createAccountButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
            createAccountButton.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: -66
            ),
                
            
        ])
        
    }
    
}
extension CreateAccountViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            return true
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.tag == 1 {
            
            guard let text = textField.text else { return }
            
            if text.count < 8 {
                longError.image = .wrong
            }   else {
                longError.image = .check
            }
            
            let hasNumber = text.contains(where: { ("0"..."9").contains($0) })
            let hasUpper = text.contains(where: { ("A"..."Z").self.contains($0) })
            let hasSpecialChar = text.contains(where: { !("0"..."9").contains($0) && !("a"..."z").contains($0) && !("A"..."Z").contains($0) })
            
            if !hasNumber {
                numeberError.image = .wrong
    
            } else {
                numeberError.image = .check
            }
            
            if !hasUpper {
                upperError.image = .wrong
                
            } else{
                upperError.image = .check
            }
            
            if !hasSpecialChar {
                specialError.image = .wrong
                
            } else {
                specialError.image = .check
            }
            
        }
    }
}

