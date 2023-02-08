//
//  AddOrderViewController.swift
//  HotCoffee
//
//  Created by Marshall Kurniawan on 09/02/23.
//

import Foundation
import UIKit

class AddOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var vm = AddCoffeeOrderViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //wajib buat nampilin datanya
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    //ini itu "subbab"nya buat tiap row nyebutnya section
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
}
