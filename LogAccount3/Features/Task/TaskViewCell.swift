//
//  TaskViewCell.swift
//  LogAccount3
//
//  Created by Ana Carolina Palhares Poletto on 08/05/25.
//
import UIKit

class TaskViewCell: UITableViewCell {
    
    static let reuseIdentifier = "TaskCell-Identifies"
    
    lazy var button: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.tintColor = .labelSecondary
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var label: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "SFPro-Regular-Semibold", size: 16)
        label.textColor = .label
        return label
    }()
    
    lazy var stack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [button, label])
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.spacing = 12
        return stack
    }()

    func config(labelText: String,
                isDone: Bool,
                buttonAction: @escaping () -> Void) {
        
        label.text = labelText
        
        button.tintColor = isDone ? .accent : .labelSecondary
        button.setImage(UIImage(systemName: isDone ? "checkmark.circle.fill" : "circle") , for: .normal)
        self.isDone = isDone
        
        self.action = buttonAction
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isDone = false
    
    
    var action: () -> Void = {
        
    }
    
    @objc func buttonTapped() {
        
        action()
        
        isDone.toggle()

        button.setImage(UIImage(systemName: isDone ? "checkmark.circle.fill" : "circle") , for: .normal)
        
    }

}

extension TaskViewCell: ViewCodeProtocol {
    func addSubViews() {
        contentView.addSubview(stack)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            stack.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    
}
