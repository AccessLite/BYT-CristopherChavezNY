 //
 //  FoaasViewController.swift
 //  BoardingPass
 //
 //  Created by Cris on 11/27/16.
 //  Copyright © 2016 Cris. All rights reserved.
 //
 
 import UIKit
 
 private let profanityMode = false
 
 
 class FoaasViewController: UIViewController, UIGestureRecognizerDelegate {
    
    lazy var BYTLabel: UILabel = {
        let BYTL = UILabel()
        BYTL.translatesAutoresizingMaskIntoConstraints = false
        BYTL.textAlignment = .left
        BYTL.font = UIFont.systemFont(ofSize: 60, weight: 0.2)
        BYTL.adjustsFontSizeToFitWidth = true
        BYTL.minimumScaleFactor = 0.30
        BYTL.numberOfLines = 20
        BYTL.textColor = .darkGray
        BYTL.baselineAdjustment = UIBaselineAdjustment.alignBaselines
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapResponse))
        tapGesture.numberOfTapsRequired = 1
        BYTL.isUserInteractionEnabled = true
        BYTL.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
        
        return BYTL
    }()
    
    func tapResponse(sender: UITapGestureRecognizer) {
        
        if let message = BYTLabel.text,
            let subtitle = BYTSubtitleLabel.text {
            
            let message = "\(message) \n\(subtitle)"
            let activityViewController = UIActivityViewController(activityItems: [message] , applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    lazy var  BYTSubtitleLabel: UILabel = {
        let st = UILabel()
        st.translatesAutoresizingMaskIntoConstraints = false
        st.textAlignment = .right
        st.textColor = .lightGray
        st.numberOfLines = 2
        st.font = UIFont.systemFont(ofSize: 48, weight: 0.2)
        st.minimumScaleFactor = 0.30
        st.adjustsFontSizeToFitWidth = true
        
        return st
    }()
    
    lazy var octoButton: UIButton = {
        let ob = UIButton(type: .system)
        ob.translatesAutoresizingMaskIntoConstraints = false
        ob.setBackgroundImage(UIImage(named: "Octopus-Cute"), for: UIControlState.normal)
        ob.addTarget(self, action: #selector(handleOcto(sender:)), for: .touchDown)
        return ob
    }()
    
    func handleOcto(sender: UIButton) {
        // create references to the different transforms
        let newTransform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        let originalTransform = sender.imageView!.transform
        
        UIView.animate(withDuration: 0.1, animations: {
            // animate to newTransform
            self.octoButton.transform = newTransform
        }, completion: { (complete) in
            // return to original transform
            self.octoButton.transform = originalTransform
            let navController = UINavigationController(rootViewController: FoaasOperationsTableViewController())
            self.present(navController, animated: true, completion: nil)
            
        })
    }
    
    
    
    func setupViews() {
        view.addSubview(BYTLabel)
        view.addSubview(BYTSubtitleLabel)
        view.addSubview(octoButton)
        
        BYTLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        BYTLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        BYTLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        BYTLabel.bottomAnchor.constraint(equalTo: BYTSubtitleLabel.topAnchor).isActive = true
        BYTLabel.heightAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.height * 0.75 ).isActive = true
        
        BYTSubtitleLabel.heightAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.height * 0.20).isActive = true
        BYTSubtitleLabel.topAnchor.constraint(equalTo: BYTLabel.bottomAnchor).isActive = true
        BYTSubtitleLabel.bottomAnchor.constraint(equalTo: octoButton.topAnchor).isActive = true
        BYTSubtitleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        BYTSubtitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
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
        APICallWithDataManager()
        
        setupLongPressGesture()
    }
    
    func setupLongPressGesture() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        self.view.addGestureRecognizer(longPress)
    }
    func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .ended {
            print("longpress")
            //Code below takes the screenshot/ makes the screen flash when done and calls the createScreenShotCompletion
            UIGraphicsBeginImageContextWithOptions(UIScreen.main.bounds.size, false, 0)
            self.view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
            guard let image:UIImage = UIGraphicsGetImageFromCurrentImageContext() else { return }
            
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(createScreenShotCompletion), nil)
            if let wnd = self.view{
                
                let v = UIView(frame: wnd.bounds)
                v.backgroundColor = .white
                v.alpha = 1
                
                wnd.addSubview(v)
                UIView.animate(withDuration: 1, animations: {
                    v.alpha = 0.0
                }, completion: {(finished:Bool) in
                    print("inside")
                    v.removeFromSuperview()
                })
            }
            
        }
    }
    
    internal func createScreenShotCompletion(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: UnsafeMutableRawPointer?) {
        if didFinishSavingWithError != nil {
            //image did not save
            let title = "Screenshot NOT Taken"
            let  message = "There was a problem taking your screenshot."
            let preferredStyle =  UIAlertControllerStyle.alert
            
            let buttonTitle = "Okay"
            let buttonStyle = UIAlertActionStyle.default
            
            createAlert(alertTitle: title, alertMessage: message, alertPrefferedStyle: preferredStyle, buttonTitle: buttonTitle, buttonStyle: buttonStyle, buttonHandler: nil)
            
        } else {
            //image did save
            let title = "Screenshot Taken"
            let  message = "A screenshot was successfully saved to your camera roll."
            let preferredStyle =  UIAlertControllerStyle.alert
            
            let buttonTitle = "Okay"
            let buttonStyle = UIAlertActionStyle.default
            
            createAlert(alertTitle: title, alertMessage: message, alertPrefferedStyle: preferredStyle, buttonTitle: buttonTitle, buttonStyle: buttonStyle, buttonHandler: nil)
        }
    }
    
    func createAlert(alertTitle: String, alertMessage: String, alertPrefferedStyle: UIAlertControllerStyle, buttonTitle: String, buttonStyle: UIAlertActionStyle, buttonHandler:
        ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: alertPrefferedStyle)
        let OkayButton = UIAlertAction(title: buttonTitle, style: buttonStyle, handler: buttonHandler)
        alert.addAction(OkayButton)
        present(alert, animated: true, completion: nil)
    }
    
    internal func registerForNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(updateFoaas(sender:)), name: Notification.Name(rawValue: "FoaasObjectDidUpdate"), object: nil)
    }
    
    internal func updateFoaas(sender: Notification) {
        if let dict = sender.userInfo?["info"] as? [String : Any],
            let message = dict["url"] as? String {
            APICallWithDataManager(url: message)
        }
    }


    func APICallWithDataManager(url: String = "http://www.foaas.com/awesome/:Louis") {
        guard let url = URL(string: url) else { return }
        FoaasDataManager.shared.getFoaas(url: url) { (data: Foaas) in
            DispatchQueue.main.async {
                let message = data.message.replacingOccurrences(of: ":", with: "")
                let sub =  data.subtitle.replacingOccurrences(of: "- :", with: "")
                
                if profanityMode == false {
                    var cleanMessage = message.replacingOccurrences(of: "uck", with: "*ck")
                    cleanMessage = cleanMessage.replacingOccurrences(of: "ick", with: "*ck")
                    cleanMessage = cleanMessage.replacingOccurrences(of: "ock", with: "*ck")
                    cleanMessage = cleanMessage.replacingOccurrences(of: "ass", with: "*ss")
                    cleanMessage = cleanMessage.replacingOccurrences(of: "pussy", with: "p*ssy")
                    let cleanSubtitle = sub.replacingOccurrences(of: "uck", with: "*ck")
                    
                    self.BYTLabel.text = cleanMessage
                    self.BYTSubtitleLabel.text = "From\n\(cleanSubtitle)"
                } else {
                    self.BYTLabel.text = message
                    self.BYTSubtitleLabel.text = "From\n\(sub)"
                }
                self.reloadInputViews()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 }
