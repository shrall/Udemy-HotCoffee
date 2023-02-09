//
//  OrdersTableViewController.swift
//  HotCoffee
//
//  Created by Marshall Kurniawan on 09/02/23.
//

import Foundation
import UIKit

class OrdersTableViewController: UITableViewController, AddOrderDelegate {
    var orderListVM = OrderListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateOrders()
    }
    
    func addOrderViewControllerDidSave(order: Order, controller: UIViewController) {
        let orderVM = OrderViewModel(order: order)
        self.orderListVM.ordersVM.append(orderVM)
        self.tableView.insertRows(at: [IndexPath.init(row: self.orderListVM.ordersVM.count - 1, section: 0)], with: .automatic)
        controller.dismiss(animated: true)
    }
    
    func addOrderViewControllerDidClose(controller: UIViewController) {
        controller.dismiss(animated: true)
    }

    private func populateOrders() {
        WebService().load(resource: Order.all) { [weak self] result in
            switch result {
            case .success(let orders):
                self?.orderListVM.ordersVM = orders.map(OrderViewModel.init)
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController,
              let addOrderVC = navC.viewControllers.first as? AddOrderViewController
        else {
            fatalError("Error performing segue")
        }
        
        addOrderVC.delegate = self
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderListVM.ordersVM.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = self.orderListVM.orderVM(at: indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        
        content.text = vm.type
        content.secondaryText = vm.size
        
        cell.contentConfiguration = content
        
        return cell
    }
}
