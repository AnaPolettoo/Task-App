//
//  CheckPassword.swift
//  LogAccount3
//
//  Created by Ana Carolina Palhares Poletto on 29/04/25.
//

import UIKit

class CheckPassword: UIView {
    lazy var check: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = .wrong
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()
    
    lazy var errorLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "error"
        label.font = UIFont(name: "SFPro-Regular", size: 13)
        label.textColor = .labelPrimary
        label.textAlignment = .left
        return label
    }()
    
    lazy var errorStack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [
            check, errorLabel,
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }()
    
    var text: String? {
        didSet {
            errorLabel.text = text
        }
    }
    

    var image: UIImage? {
        didSet {
            check.image = image
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
    
extension CheckPassword: ViewCodeProtocol {
    
    func addSubViews() {
        
        addSubview(errorStack)
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            check.heightAnchor.constraint(equalToConstant: 13),
            check.widthAnchor.constraint(equalToConstant: 13),
        
            
            errorStack.topAnchor.constraint(equalTo: self.topAnchor),
            errorStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            errorStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            errorStack.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
    }
    
    
}
