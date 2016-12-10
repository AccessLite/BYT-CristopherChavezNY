 //
 //  FoaasViewController.swift
 //  BoardingPass
 //
 //  Created by Cris on 11/27/16.
 //  Copyright © 2016 Cris. All rights reserved.
 //
 
 import UIKit
 
 class FoaasViewController: UIViewController {
    
    let API = FoaasAPIManager()
    
    lazy var BYTLabel: UILabel = {
        let BYTL = UILabel()
        BYTL.translatesAutoresizingMaskIntoConstraints = false
        BYTL.textAlignment = .left
        BYTL.font = UIFont.systemFont(ofSize: 60, weight: 0.2)
        BYTL.adjustsFontSizeToFitWidth = true
        BYTL.minimumScaleFactor = 0.50
        BYTL.lineBreakMode = .byWordWrapping
        BYTL.numberOfLines = 0
        BYTL.textColor = .darkGray
        BYTL.sizeToFit()
        return BYTL
    }()
    
    lazy var  BYTSubtitleLabel: UILabel = {
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
    
    func handleOcto() {
        let navController = UINavigationController(rootViewController: FoaasOperationsTableViewController())
        self.present(navController, animated: true, completion: nil)
    }
    
    func setupViews() {
        view.addSubview(BYTLabel)
        view.addSubview(BYTSubtitleLabel)
        view.addSubview(octoButton)
        
        BYTLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        BYTLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        BYTLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 65).isActive = true
        BYTLabel.bottomAnchor.constraint(greaterThanOrEqualTo: BYTSubtitleLabel.topAnchor).isActive = true
        
        BYTSubtitleLabel.topAnchor.constraint(equalTo: BYTLabel.bottomAnchor).isActive = true
        BYTSubtitleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        
        octoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        octoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        octoButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        octoButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        registerForNotifications()
    }
    
    internal func registerForNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(updateFoaas(sender:)), name: Notification.Name(rawValue: "FoaasObjectDidUpdate"), object: nil)
        
            APICall()
    }
    
    internal func updateFoaas(sender: Notification) {
        if let dict = sender.userInfo?["info"] as? [String : Any],
            let message = dict["url"] as? String {
            APICall(url: message)
        }
    }
    
    func APICall(url: String = "http://www.foaas.com/awesome/:Louis") {
        guard let url = URL(string: url) else { return }
        API.getFoaas(url: url) { (data: Foaas) in
            DispatchQueue.main.async {
                self.BYTLabel.text = data.message
                let sub =  data.subtitle.replacingOccurrences(of: "- :", with: "")
                self.BYTSubtitleLabel.text = "From\n\(sub)"
                dump("From\n\(sub)")
                self.reloadInputViews()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 }
