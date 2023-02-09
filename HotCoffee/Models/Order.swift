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

struct Order: Codable {
    let name: String
    let email: String
    let type: OrderType
    let size: OrderSize
}

extension Order {
    init?(_ vm: AddOrderViewModel) {
        // ini ngeset value dari order yang dibuat dapet value dari vm
        guard let name = vm.name,
              let email = vm.email,
              let selectedType = OrderType(rawValue: vm.selectedType!.lowercased()),
              let selectedSize = OrderSize(rawValue: vm.selectedSize!.lowercased())
        else {
            return nil
        }

        // kalo valuenya ada, buat object Order
        self.name = name
        self.email = email
        self.type = selectedType
        self.size = selectedSize
    }
}

extension Order {
    //ini var yang valuenya langsung directly ngambil sesuai sama yang di dapet dari API
    static var all: Resource<[Order]> = {
        
        guard let url = URL(string: "https://warp-wiry-rugby.glitch.me/orders") else {
            fatalError("URL is incorrect")
        }
        
        return Resource<[Order]>(url: url)
    }()
    
    static func create(vm: AddOrderViewModel) -> Resource<Order?> {
        let order = Order(vm)

        guard let url = URL(string: "https://warp-wiry-rugby.glitch.me/orders") else {
            fatalError("URL is incorrect")
        }

        guard let data = try? JSONEncoder().encode(order) else {
            fatalError("Error encoding order")
        }

        var resource = Resource<Order?>(url: url)
        resource.httpMethod = HTTPMethod.post
        resource.body = data
        
        return resource
    }
}
