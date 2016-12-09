//
//  PreviewViewController.swift
//  BoardingPass
//
//  Created by Cris on 11/27/16.
//  Copyright © 2016 Cris. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController, UITextFieldDelegate {
    
    var operation: FoaasOperation!
    let apiManager = FoaasAPIManager()
    
    // needed better var naming; more inline with conventions this way
    var operationPathURL = String()
    let baseURL = "http://www.foaas.com"
    var editedMessage = String()
    var editedSubtitle = String()
    
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.operationPathURL = operation.urlString
        createSelectButton()
        setUpViews()
        apiCall()
    }
    
    
    // MARK: - Configure Views
    func setUpViews() {
        view.addSubview(previewLabel)
        view.addSubview(previewTextView)
        view.addSubview(nameLabel)
        view.addSubview(textFieldOne)
        view.addSubview(fromLabel)
        view.addSubview(textFieldTwo)
        view.addSubview(referenceLabel)
        view.addSubview(textFieldThree)
        
        // in the future, you may want to leave yourself a few comments to describe the 
        // layout you're trying to achieve. it can help you troubleshoot in the future
        previewLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 75).isActive = true
        previewLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        previewLabel.rightAnchor.constraint(equalTo: view.rightAnchor,  constant: -8).isActive = true
        
        // i.e. pin previewTextView to left/right, height = 1/4 of screen
        previewTextView.rightAnchor.constraint(equalTo:  view.rightAnchor).isActive = true
        previewTextView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        previewTextView.topAnchor.constraint(equalTo: previewLabel.bottomAnchor).isActive = true
        previewTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: CGFloat(0.25)).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: previewTextView.bottomAnchor, constant: 20).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: view.rightAnchor,  constant: -8).isActive = true
        
        textFieldOne.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        textFieldOne.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        textFieldOne.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true
        
        fromLabel.topAnchor.constraint(equalTo: textFieldOne.bottomAnchor, constant: 20).isActive = true
        fromLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        fromLabel.rightAnchor.constraint(equalTo: view.rightAnchor,  constant: -8).isActive = true
        
        textFieldTwo.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        textFieldTwo.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        textFieldTwo.topAnchor.constraint(equalTo: fromLabel.bottomAnchor, constant: 10).isActive = true
        
        referenceLabel.topAnchor.constraint(equalTo: textFieldTwo.bottomAnchor, constant: 20).isActive = true
        referenceLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        referenceLabel.rightAnchor.constraint(equalTo: view.rightAnchor,  constant: -8).isActive = true
        
        textFieldThree.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        textFieldThree.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        textFieldThree.topAnchor.constraint(equalTo: referenceLabel.bottomAnchor, constant: 10).isActive = true
        
    }
    

    func apiCall() {
        let operationURL = operation.urlString
        let newoperationURl = operationURL.replacingOccurrences(of: ":from", with: "from")
        let newoperationURl2 = newoperationURl.replacingOccurrences(of: ":name", with: "name")
        let newoperationURl3 = newoperationURl2.replacingOccurrences(of: ":reference", with: "reference")
        
        guard let url = URL(string: "\(baseURL)\(newoperationURl3)") else { return }
        apiManager.getFoaas(url: url) { (data: Foaas) in
            DispatchQueue.main.async {
                self.previewTextView.text = "\(data.message) \n\(data.subtitle)"
                self.editedMessage = data.message
                self.editedSubtitle = data.subtitle
                self.reloadInputViews()
            }
        }
    }
    
    
    // MARK: - Button
    func createSelectButton() {
        self.title = operation.name
        let rightButton = UIBarButtonItem(title: "Select", style: UIBarButtonItemStyle.done, target: self, action: #selector(handleSelectButton))
        navigationItem.rightBarButtonItem = rightButton
    }
    
    func handleSelectButton() {
        
        // calling self.present causes a modal presentation of a new VC on top of your existing nav stack. 
        // do this enough times and your app will crash due to a memory warning
        
        // self.dismiss is called on the top-most VC in whatever VC stack you have, making this the appropriate choice
        self.dismiss(animated: true, completion: nil)
        let foaasInfo: [String : Any] = [ "url" : "\(baseURL)\(operationPathURL)" ]
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: Notification.Name(rawValue: "FoaasObjectDidUpdate"), object: nil, userInfo: [ "info" : foaasInfo ])
    }
    
    
    // MARK: - Textfield Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Im not going to comment on your implementation of the fields at the moment, considering week 2's goal is to 
    // refactor and improve it. But be aware your API call will fail if there is a space in any part of the url's path
    // make sure you're adding percent encoding to the string you want to use as a url
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        dump(operationPathURL)
        switch textField {
        case self.textFieldOne:
            self.editedMessage = self.editedMessage.replacingOccurrences(of: "name", with: text)
            self.editedSubtitle = self.editedSubtitle.replacingOccurrences(of: "name", with: text)
            self.operationPathURL = self.operationPathURL.replacingOccurrences(of: "name", with: text)
            self.previewTextView.text = "\(editedMessage) \n\(editedSubtitle)"
            
        case self.textFieldTwo:
            self.editedMessage = self.editedMessage.replacingOccurrences(of: "from", with: text)
            self.editedSubtitle = self.editedSubtitle.replacingOccurrences(of: "from", with: text)
            self.operationPathURL = self.operationPathURL.replacingOccurrences(of: "from", with: text)
            self.previewTextView.text = "\(editedMessage) \n\(editedSubtitle)"
            
        case textFieldThree:
            self.editedMessage = self.editedMessage.replacingOccurrences(of: "reference", with: text)
            self.editedSubtitle = self.editedSubtitle.replacingOccurrences(of: "reference", with: text)
            self.operationPathURL = self.operationPathURL.replacingOccurrences(of: "reference", with: text)
            self.previewTextView.text = "\(editedMessage) \n\(editedSubtitle)"
        default:
            break
        }
    }
    
    
    // MARK: - Lazy Loading
    lazy var previewLabel: UILabel = {
        let pl = UILabel()
        pl.translatesAutoresizingMaskIntoConstraints = false
        pl.font = UIFont(name: "HelveticaNeue-BoldItalic", size: 20)
        pl.text = "Preview:"
        return pl
    }()
    
    lazy var nameLabel: UILabel = {
        let pl = UILabel()
        pl.translatesAutoresizingMaskIntoConstraints = false
        pl.font = UIFont.systemFont(ofSize: 20)
        pl.text = "<name>"
        return pl
    }()
    
    lazy var fromLabel: UILabel = {
        let pl = UILabel()
        pl.translatesAutoresizingMaskIntoConstraints = false
        pl.font = UIFont.systemFont(ofSize: 20)
        pl.text = "<from>"
        return pl
    }()
    
    lazy var referenceLabel: UILabel = {
        let pl = UILabel()
        pl.translatesAutoresizingMaskIntoConstraints = false
        pl.font = UIFont.systemFont(ofSize: 20)
        pl.text = "<reference>"
        return pl
    }()
    
    lazy var previewTextView: UITextView = {
        let ptv = UITextView()
        ptv.translatesAutoresizingMaskIntoConstraints = false
        ptv.isEditable = false
        ptv.isSelectable = false
        ptv.font = UIFont.systemFont(ofSize: 20)
        ptv.sizeToFit()
        return ptv
    }()
    
    lazy var textFieldOne: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Name"
        return tf
    }()
    
    lazy var textFieldTwo: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "from"
        return tf
    }()
    
    lazy var textFieldThree: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "reference"
        return tf
    }()
    
}
