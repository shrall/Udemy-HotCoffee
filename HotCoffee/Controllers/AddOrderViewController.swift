//
//  AddOrderViewController.swift
//  HotCoffee
//
//  Created by Marshall Kurniawan on 09/02/23.
//

import Foundation
import UIKit

protocol AddOrderDelegate {
    func addOrderViewControllerDidSave(order: Order, controller: UIViewController)
    func addOrderViewControllerDidClose(controller: UIViewController)
}

class AddOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var vm = AddOrderViewModel()
    
    var delegate: AddOrderDelegate?
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    
    private var orderSizesSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
        // wajib buat nampilin datanya
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func setupUI() {
        // ini nge set ada apa aja choicesnya
        self.orderSizesSegmentedControl = UISegmentedControl(items: self.vm
            .sizes)
        
        // ini itu biar bisa di set manual constraint/location/etcnya
        self.orderSizesSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        // ini masukin segmented controlnya ke view
        self.view.addSubview(self.orderSizesSegmentedControl)
        
        // ini set topanchor dari segmentedcontrolnya ke bottom anchornya tableview
        self.orderSizesSegmentedControl.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 20).isActive = true
        
        // ini ngeset horizontally aligned sama screen viewnya
        self.orderSizesSegmentedControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    // ini itu "subbab"nya buat tiap row nyebutnya section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.vm.types.count)
        return self.vm.types.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTypeTableViewCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        
        content.text = self.vm.types[indexPath.row]
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // ini run ketika select suatu row
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // ini run ketika deselect suatu row
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    @IBAction func save() {
        // ini ngambil value dari text field
        let name = self.nameTextField.text
        let email = self.emailTextField.text
        
        // ini ngambil value dari segmented control yang selected
        let selectedSize = self.orderSizesSegmentedControl.titleForSegment(at: self.orderSizesSegmentedControl.selectedSegmentIndex)
        
        guard let indexPath = self.tableView.indexPathForSelectedRow else {
            fatalError("Error in selecting coffee")
        }
        
        // set value tadi di vm
        self.vm.name = name
        self.vm.email = email
        self.vm.selectedSize = selectedSize
        self.vm.selectedType = self.vm.types[indexPath.row]
        
        WebService().load(resource: Order.create(vm: self.vm)) { result in
            switch result {
            case .success(let order):
                if let order = order, let delegate = self.delegate {
                    DispatchQueue.main.async {
                        delegate.addOrderViewControllerDidSave(order: order, controller: self)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func close() {
        if let delegate = self.delegate {
            delegate.addOrderViewControllerDidClose(controller: self)
        }
    }
}
