//
//  ViewCodeProtocol.swift
//  AcademyPetshopViewCode
//
//  Created by Igor Vicente on 29/04/25.
//

import Foundation

protocol ViewCodeProtocol {
    func addSubViews()
    func setupConstraints()
    func setup()
}

extension ViewCodeProtocol {
    func setup() {
        addSubViews()
        setupConstraints()
    }
}
