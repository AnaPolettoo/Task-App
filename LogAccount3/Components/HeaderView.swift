//
//  HeaderView.swift
//  LogAccount3
//
//  Created by Ana Carolina Palhares Poletto on 03/05/25.
//

import UIKit

class HeaderView: UIView {
    // MARK: Subviews
    private lazy var cancelButton: UIButton = {
        var button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "SFProRounded-Semibold", size: 17)
        return label
    }()
    
    public lazy var addButton: UIButton = {
        var button = UIButton()
        
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        
        button.setTitle("Add", for: .disabled)
        button.setTitleColor(.systemGray, for: .disabled)
        button.isEnabled = false
        
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var stack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [cancelButton, titleLabel, addButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .equalCentering
        return stack
    }()
    
    private lazy var separator: UIView = {
        var separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .separator
        return separator
    }()
    
    // MARK: Properties
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var addButtonIsEnabled: Bool = false {
        didSet {
            addButton.isEnabled = addButtonIsEnabled
        }
    }
    
    var cancelButtonAction: () -> Void = {}
    var addButtonAction: () -> Void = {}

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Functions
    @objc func cancelButtonTapped() {
        cancelButtonAction()
    }
    
    @objc func addButtonTapped() {
        addButtonAction()
    }
    
}

extension HeaderView: ViewCodeProtocol {
    
    func addSubViews() {
        addSubview(stack)
        addSubview(separator)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: self.topAnchor),
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            separator.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 11),
            separator.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 0.25)
        ])
    }
    
}
