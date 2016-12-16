//
//  FoaasOperationsTableViewController.swift
//  BoardingPass
//
//  Created by Cris on 11/27/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import UIKit

class FoaasOperationsTableViewController: UITableViewController {
    
    let apiManager = FoaasAPIManager()
    var operations: [FoaasOperation] = []
    
    // its good to get used to defining strings as lets when you need to reuse them. less chance of a typo
    private let operationCellIdentifier: String = "operationsCell"
    
    // always have your vars 1st, followed by overriden view lifecycle functions (in a VC)
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        createDoneButton()
        self.title = "Operations"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: operationCellIdentifier)
        getOperations()
    }
    
    func getOperations() {
        apiManager.getOperations{ (data: [FoaasOperation]?) in
            guard let theOperations = data else { return }
            self.operations = theOperations
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func createDoneButton() {
        let rightButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(handleDoneButton))
        navigationItem.rightBarButtonItem = rightButton
    }
    
    func handleDoneButton() {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return operations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: operationCellIdentifier, for: indexPath)
        let op = self.operations[indexPath.row]
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        cell.textLabel?.text = op.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = PreviewViewController()
        let operation = operations[indexPath.row]
        destinationVC.operation = operation
        
        // your tablevc's parent view controller is considered to be the navigation controller
        // so we can try to unwrap self.navigationController in order to pop on a new VC
        guard let navController = self.navigationController else { return }
        navController.pushViewController(destinationVC, animated: true)
    }
    
}
