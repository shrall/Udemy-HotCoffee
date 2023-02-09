//
//  AddOrderViewModel.swift
//  HotCoffee
//
//  Created by Marshall Kurniawan on 09/02/23.
//

import Foundation

struct AddOrderViewModel {
    var name: String?
    var email: String?
    var selectedType: String?
    var selectedSize: String?

    var types: [String] {
        return OrderType.allCases.map { $0.rawValue.capitalized }
    }

    var sizes: [String] {
        return OrderSize.allCases.map { $0.rawValue.capitalized }
    }
}
