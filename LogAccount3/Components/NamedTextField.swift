//
//  NamedTextField.swift
//  LogAccount3
//
//  Created by Ana Carolina Palhares Poletto on 24/04/25.
//
import UIKit

class NamedTextField: UIView {
    lazy var nameLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Full Name"
        label.font = UIFont(name: "SFPro-Regular-Semibold", size: 16)
        label.textColor = .labelPrimary

        return label
    }()
    
    lazy var nameTextField: UITextField = {
       var textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Your name here"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .backgroundTertiary
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        textField.layer.borderColor = UIColor.separator.cgColor
        
        return textField
    }()
    
    lazy var nameStack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [
            nameLabel, nameTextField,
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    
    var placeholder: String? {
        didSet {
            nameTextField.placeholder = placeholder
        }
    }
    
    var text: String? {
        get {
            nameTextField.text
        }
        set {
            nameTextField.text = newValue
        }
    }
    
    var delegate: UITextFieldDelegate? {
        didSet {
            nameTextField.delegate = delegate
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension NamedTextField: ViewCodeProtocol {
    
    func addSubViews() {
        addSubview(nameStack)
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            nameStack.topAnchor.constraint(equalTo: self.topAnchor),
            nameStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            nameStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            nameStack.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
    }
    
    
}
