 //
 //  FoaasViewController.swift
 //  BoardingPass
 //
 //  Created by Cris on 11/27/16.
 //  Copyright © 2016 Cris. All rights reserved.
 //
 
 import UIKit
 
 class FoaasViewController: UIViewController {
    
    // never use capitalized variable names
    let apiManager = FoaasAPIManager()
    
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        registerForNotifications()
        
        // registerForNotifications describes what it does. it shouldn't also make a call to your api function
        apiCall()
    }
    
    internal func registerForNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(updateFoaas(sender:)), name: Notification.Name(rawValue: "FoaasObjectDidUpdate"), object: nil)
    }
    
    
    // MARK: View Config
    func setupViews() {
        // what made you go down the programmatic route? well done, though.
        view.addSubview(bytLabel)
        view.addSubview(bytSubtitleLabel)
        view.addSubview(octoButton)
        
        bytLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        bytLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        bytLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 65).isActive = true
        bytLabel.bottomAnchor.constraint(greaterThanOrEqualTo: bytSubtitleLabel.topAnchor).isActive = true
        
        bytSubtitleLabel.topAnchor.constraint(equalTo: bytLabel.bottomAnchor).isActive = true
        bytSubtitleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        
        octoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        octoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        octoButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        octoButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }

    
    internal func updateFoaas(sender: Notification) {
        if let dict = sender.userInfo?["info"] as? [String : Any],
            let message = dict["url"] as? String {
            apiCall(url: message)
        }
    }
    
    // never have a capitalized function name
    func apiCall(url: String = "http://www.foaas.com/awesome/:Louis") {
        guard let url = URL(string: url) else { return }
        apiManager.getFoaas(url: url) { (data: Foaas) in
            DispatchQueue.main.async {
                self.bytLabel.text = data.message
                let sub = data.subtitle.replacingOccurrences(of: "- :", with: "")
                self.bytSubtitleLabel.text = "From\n\(sub)"
                dump("From\n\(sub)")
            }
        }
    }
    
    func handleOcto() {
        let navController = UINavigationController(rootViewController: FoaasOperationsTableViewController())
        self.present(navController, animated: true, completion: nil)
    }
    
    
    // MARK: - Lazy Inits
    // why use lazy? I mean it is a good choice, but what made you decide to use this?
    lazy var bytLabel: UILabel = {
        let bytL = UILabel()
        bytL.translatesAutoresizingMaskIntoConstraints = false
        bytL.textAlignment = .left
        bytL.font = UIFont.systemFont(ofSize: 60, weight: 0.2)
        bytL.adjustsFontSizeToFitWidth = true
        bytL.minimumScaleFactor = 0.50
        bytL.lineBreakMode = .byWordWrapping
        bytL.numberOfLines = 0
        bytL.textColor = .darkGray
        bytL.sizeToFit()
        return bytL
    }()
    
    lazy var bytSubtitleLabel: UILabel = {
        let st = UILabel()
        st.translatesAutoresizingMaskIntoConstraints = false
        st.textAlignment = .right
        st.textColor = .lightGray
        st.numberOfLines = 0
        st.font = UIFont.systemFont(ofSize: 48, weight: 0.2)
        st.lineBreakMode = .byWordWrapping
        st.sizeToFit()
        return st
    }()
    
    lazy var octoButton: UIButton = {
        let ob = UIButton(type: .system)
        ob.translatesAutoresizingMaskIntoConstraints = false
        ob.setBackgroundImage(UIImage(named: "Octopus-Cute"), for: UIControlState.normal)
        ob.addTarget(self, action: #selector(handleOcto), for: .touchUpInside)
        return ob
    }()
 }
