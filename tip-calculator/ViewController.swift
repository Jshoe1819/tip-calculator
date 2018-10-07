//
//  ViewController.swift
//  tip-calculator
//
//  Created by Jacob Shoemaker on 10/6/18.
//  Copyright © 2018 Jacob Shoemaker. All rights reserved.
//

//format of bill total input
//format of tip input
//change tip % if tip input
//change tip % when slider change
//change tip input when slider change
//change split when split slider change
//adjust total cost
//adjust split cost
//adjust split cost if round changed
//adjust split cost if round to change

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var stackBottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var billTotalTextField: UITextField!
    @IBOutlet weak var roundSelectorController: UISegmentedControl!
    @IBOutlet weak var incrementSelectorController: UISegmentedControl!
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        billTotalTextField.becomeFirstResponder()
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            stackBottomLayoutConstraint.constant = keyboardHeight + 20
        }
    }
    @IBAction func roundSelectControllerPressed(_ sender: Any) {
        let index = roundSelectorController.selectedSegmentIndex
        print(index)
        
        if index == 0 {
            //do other cost stuff
            incrementSelectorController.isEnabled = true
        } else if index == 2 {
            incrementSelectorController.isEnabled = true
        } else {
            incrementSelectorController.isEnabled = false
        }
        
        
    }
    


}

