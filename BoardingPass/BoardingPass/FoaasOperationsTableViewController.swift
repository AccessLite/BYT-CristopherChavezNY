//
//  FoaasOperationsTableViewController.swift
//  BoardingPass
//
//  Created by Cris on 11/27/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import UIKit

class FoaasOperationsTableViewController: UITableViewController {
    let APICall = FoaasAPIManager()
    var operations: [FoaasOperation] = []
    
    func createDoneButton() {
        let rightButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(handleDoneButton))
        navigationItem.rightBarButtonItem = rightButton
    }
 
    func handleDoneButton() {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDoneButton()
        self.title = "Operations"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "operationsCell")
        getOperations()
    }
    
    func getOperations() {
        APICall.getOperations{ (data: [FoaasOperation]?) in
            guard let theOperations = data else { return }
                self.operations = theOperations
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return operations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "operationsCell", for: indexPath)
        let op = self.operations[indexPath.row]
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        cell.textLabel?.text = op.name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = PreviewViewController()
        let operation = operations[indexPath.row]
        destinationVC.operation = operation
        let navController = UINavigationController(rootViewController: destinationVC)
        self.present(navController, animated: true, completion: nil)
    }

}
