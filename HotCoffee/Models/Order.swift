//
//  Order.swift
//  HotCoffee
//
//  Created by Marshall Kurniawan on 09/02/23.
//

import Foundation

enum OrderType: String, Codable, CaseIterable {
    case cappuccino
    case latte
    case espresso
    case doppio
}

enum OrderSize: String, Codable, CaseIterable {
    case small
    case medium
    case large
}

struct Order: Codable{
    let name: String
    let email: String
    let type: OrderType
    let size: OrderSize
}
