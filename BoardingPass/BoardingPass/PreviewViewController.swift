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
    var operationHalf = String()
    var builder: FoaasPathBuilder!
    let website = "http://www.foaas.com"
    var editedMessage = String()
    var editedSubtitle = String()
    var name = ":name"
    var from = ":from"
    var reference = ":reference"
    var pathBuilder: FoaasPathBuilder!
    
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
        tf.placeholder = "From"
        return tf
    }()
    
    lazy var textFieldThree: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Reference"
        return tf
    }()
    
    func setUpViews() {
        view.addSubview(previewLabel)
        view.addSubview(previewTextView)
        view.addSubview(nameLabel)
        view.addSubview(textFieldOne)
        view.addSubview(fromLabel)
        view.addSubview(textFieldTwo)
        view.addSubview(referenceLabel)
        view.addSubview(textFieldThree)
        
        previewLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 75).isActive = true
        previewLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        previewLabel.rightAnchor.constraint(equalTo: view.rightAnchor,  constant: -8).isActive = true
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpKeyboardNotification()
        view.backgroundColor = .white
        self.operationHalf = operation.urlString
        createSelectButton()
        setUpViews()
        APICallWithDataManager()
        pathBuilder = FoaasPathBuilder(operation: self.operation)
        // Do any additional setup after loading the view.
    }
    
    func APICallWithDataManager() {
        let operationURL = operation.urlString
        let newoperationURl = operationURL.replacingOccurrences(of: from, with: "from")
        let newoperationURl2 = newoperationURl.replacingOccurrences(of: name, with: "name")
        let newoperationURl3 = newoperationURl2.replacingOccurrences(of: reference, with: "reference")
        name = "name"
        from = "from"
        reference = "reference"
        guard let url = URL(string: "\(website)\(newoperationURl3)") else { return }
        FoaasDataManager.shared.getFoaas(url: url) { (data: Foaas) in
            DispatchQueue.main.async {
                self.previewTextView.text = "\(data.message) \n\(data.subtitle)"
                self.editedMessage = data.message
                self.editedSubtitle = data.subtitle
                self.reloadInputViews()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
//        dump(operationHalf)
        switch textField {
        case self.textFieldOne:
            guard textFieldOne.text != "" else { return }
            self.editedMessage = self.editedMessage.replacingOccurrences(of: name, with: text)
            self.editedSubtitle = self.editedSubtitle.replacingOccurrences(of: name, with: text)
            self.operationHalf = self.operationHalf.replacingOccurrences(of: name, with: text)
            self.previewTextView.text = "\(editedMessage) \n\(editedSubtitle)"
            name = text
//            builder.update(key: name, value: text)
            
        case self.textFieldTwo:
            guard textFieldTwo.text != "" else { return }
            self.editedMessage = self.editedMessage.replacingOccurrences(of: from, with: text)
            self.editedSubtitle = self.editedSubtitle.replacingOccurrences(of: from, with: text)
            self.operationHalf = self.operationHalf.replacingOccurrences(of: from, with: text)
            self.previewTextView.text = "\(editedMessage) \n\(editedSubtitle)"
            from = text
//            builder.update(key: from, value: text)

            
        case textFieldThree:
            guard textFieldThree.text != "" else { return }
            self.editedMessage = self.editedMessage.replacingOccurrences(of: reference, with: text)
            self.editedSubtitle = self.editedSubtitle.replacingOccurrences(of: reference, with: text)
            self.operationHalf = self.operationHalf.replacingOccurrences(of: reference, with: text)
            self.previewTextView.text = "\(editedMessage) \n\(editedSubtitle)"
            reference = text

        default:
            break
        }
    }
    
    func setUpKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden), name: .UIKeyboardWillHide, object: nil)
    }
    
    lazy var yValue: CGFloat = {
       return self.view.frame.origin.y
    }()
    
    func keyboardShown() {
            view.frame = CGRect(x: view.frame.origin.x, y: yValue - 200, width: view.frame.size.width, height: view.frame.size.height)
    }
    func keyboardHidden() {
        view.frame = CGRect(x: view.frame.origin.x, y: yValue, width: view.frame.size.width, height: view.frame.size.height)
    }
    
    func createSelectButton() {
        self.title = operation.name
        let rightButton = UIBarButtonItem(title: "Select", style: UIBarButtonItemStyle.done, target: self, action: #selector(handleSelectButton))
        navigationItem.rightBarButtonItem = rightButton
    }
    
    func handleSelectButton() {
        let foaasInfo: [String : Any] = [ "url" : "\(website)\(operationHalf)" ]
        dump("\(website)\(operationHalf)")
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: Notification.Name(rawValue: "FoaasObjectDidUpdate"), object: nil, userInfo: [ "info" : foaasInfo ])
        dismiss(animated: true, completion: nil)
    }
    
}
