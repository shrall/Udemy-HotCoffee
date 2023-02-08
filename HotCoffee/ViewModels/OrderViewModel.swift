//
//  OrderViewModel.swift
//  HotCoffee
//
//  Created by Marshall Kurniawan on 09/02/23.
//

import Foundation

class OrderListViewModel {
    var ordersVM: [OrderViewModel]
    
    init() {
        self.ordersVM = [OrderViewModel]()
    }
}

extension OrderListViewModel {
    func orderVM(at index: Int) -> OrderViewModel {
        return self.ordersVM[index]
    }
}

struct OrderViewModel {
    let order: Order
}

extension OrderViewModel {
    var name: String {
        return self.order.name
    }
    
    var email: String {
        return self.order.email
    }
    
    var type: String {
        return self.order.type.rawValue.capitalized
    }
    
    var size: String {
        return self.order.size.rawValue.capitalized
    }
}
