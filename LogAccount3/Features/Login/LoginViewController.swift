import UIKit

class LoginViewController: UIViewController {

    // MARK: Top View
    lazy var topView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        //gradiente backgroud
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.frame
        gradientLayer.colors = [
            UIColor.gradientStart.cgColor,
            UIColor.gradientEnd.cgColor,
        ]

        DispatchQueue.main.async {
            gradientLayer.frame = view.bounds
            view.layer.insertSublayer(gradientLayer, at: 0)
        }

        return view
    }()

    lazy var appleIntelligenceSymbol: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = .appleIntelligent
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Welcome!"
        label.textAlignment = .center
        label.font = UIFont(name: "SFProRounded-Bold", size: 34)
        label.textColor = .white
        return label
    }()

    lazy var BottomView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .backgroundSecondary
        view.layer.cornerRadius = 24

        return view
    }()

    lazy var subTitleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Login"
        label.textAlignment = .center
        label.font = UIFont(name: "SFProRounded-Bold", size: 28)
        label.textColor = .labelPrimary
        return label
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
        view.placeholder = "*********"
        view.delegate = self
        view.nameTextField.isSecureTextEntry = true
        return view
    }()

    lazy var emailPasswordStack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [
            emailComponent, passwordComponent,
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()

    lazy var forgotPasswordLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Forgot Password?"
        label.font = UIFont(name: "SFPro-Regular", size: 15)
        label.textColor = .accent

        return label
    }()
    lazy var loginButton: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.titleLabel?.font = UIFont(name: "SFPro-Regular", size: 17)
        button.layer.cornerRadius = 12
        button.configuration = .filled()
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    lazy var createAccountButton: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Create Account", for: .normal)
        button.setTitleColor(.accent, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFPro-Regular", size: 17)
        button.layer.cornerRadius = 12
        button.configuration = .filled()
        button.tintColor = .backgroundTertiary
        button.addTarget(self, action: #selector(createAccounttappedButton), for: .touchUpInside)
    
        
        return button
    }()
    
    lazy var buttonStack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [
            loginButton, createAccountButton,
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()
    
    lazy var errorLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "The email and password you entered did not match our record. Please try again."
        label.font = UIFont(name: "SFPro-Regular", size: 13)
        label.textColor = .red
        label.isHidden = true
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailComponent.nameTextField.delegate = self
        emailComponent.nameTextField.tag = 0
        
        passwordComponent.nameTextField.delegate = self
        passwordComponent.nameTextField.tag = 1
        

        let tapDismissKeyboard = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )

        view.addGestureRecognizer(tapDismissKeyboard)
        view.backgroundColor = .systemBackground

        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cleanViewValues()
        errorLabel.isHidden = true
        emailComponent.nameTextField.layer.borderColor = UIColor.separator.cgColor
        passwordComponent.nameTextField.layer.borderColor = UIColor.separator.cgColor
    }
    
    func cleanViewValues() {
        emailComponent.text = ""
        passwordComponent.text = ""
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func loginButtonTapped() {
        
        if validLogin(){
            let users = Persistence.getUsersList()
            
            let user = users?.first(where: { $0.email == emailComponent.text})
            
            Persistence.saveLoggedUser(user)
            
            let homeViewController = TabBarController()
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(homeViewController)
        }
        cleanViewValues()
        
    }
    @objc func createAccounttappedButton() {
        let ViewController = CreateAccountViewController()
        navigationController?.pushViewController(ViewController, animated: true)
    }
    
}

extension LoginViewController: ViewCodeProtocol {
    
    func addSubViews() {
        view.addSubview(topView)
        view.addSubview(appleIntelligenceSymbol)
        view.addSubview(titleLabel)
        view.addSubview(BottomView)
        view.addSubview(subTitleLabel)
        view.addSubview(emailComponent)
        view.addSubview(passwordComponent)
        view.addSubview(emailPasswordStack)
        view.addSubview(forgotPasswordLabel)
        view.addSubview(loginButton)
        view.addSubview(createAccountButton)
        view.addSubview(buttonStack)
        view.addSubview(errorLabel)
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            topView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 0
            ),
            topView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: 0
            ),
            topView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            topView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -505
            ),
            
            appleIntelligenceSymbol.heightAnchor.constraint(
                equalToConstant: 50
            ),
            appleIntelligenceSymbol.widthAnchor.constraint(equalToConstant: 50),
            appleIntelligenceSymbol.centerXAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerXAnchor
            ),
            appleIntelligenceSymbol.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 48
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
                constant: 120
            ),
            
            BottomView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 0
            ),
            BottomView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: 0
            ),
            BottomView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 193
            ),
            BottomView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: 0
            ),
            
            subTitleLabel.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            subTitleLabel.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
            subTitleLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 213
            ),
            
            emailComponent.nameTextField.heightAnchor.constraint(equalToConstant: 46),
            passwordComponent.nameTextField.heightAnchor.constraint(equalToConstant: 46),
            
            emailPasswordStack.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            emailPasswordStack.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
            emailPasswordStack.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 279
            ),
            
            
            forgotPasswordLabel.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 244
            ),
            forgotPasswordLabel.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -26
            ),
            forgotPasswordLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 465
            ),
            
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            createAccountButton.heightAnchor.constraint(equalToConstant: 50),
            
            buttonStack.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            buttonStack.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
            buttonStack.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            
            errorLabel.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            errorLabel.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
            errorLabel.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: -222
            ),
            
        ])
        
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            return true
        }
        return true
    }
    
    func validLogin() -> Bool {
        let email = emailComponent.text ?? ""
        let password = passwordComponent.text ?? ""

        if Persistence.loginUser(email: email, password: password) {
            print("Login Success!")
            errorLabel.isHidden = true
            emailComponent.nameTextField.layer.borderColor = UIColor.separator.cgColor
            passwordComponent.nameTextField.layer.borderColor = UIColor.separator.cgColor

            return true
        } else {
            errorLabel.isHidden = false
            emailComponent.nameTextField.layer.borderColor = UIColor.red.cgColor
            passwordComponent.nameTextField.layer.borderColor = UIColor.red.cgColor
            cleanViewValues()
            return false
        }
    }
}
