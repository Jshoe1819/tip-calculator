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
//adjust split cost if round changed
//adjust split cost if round to change

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var stackBottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var billTotalTextField: UITextField!
    @IBOutlet weak var roundSelectorController: UISegmentedControl!
    @IBOutlet weak var incrementSelectorController: UISegmentedControl!
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var tipTotalTextField: UITextField!
    
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
        billTotalTextField.delegate = self
        billTotalTextField.addTarget(self, action: #selector(ViewController.billTotalTextFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        //tipTotalTextField.delegate = self
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            stackBottomLayoutConstraint.constant = keyboardHeight + 20
        }
    }
    
    @objc func billTotalTextFieldDidChange(_ textField: UITextField) {
        
        if let text = billTotalTextField.text {
            
            if text.count == 1 && !text.contains("$") {
                if text.first == "." {
                    billTotalTextField.text = "$0\(text)"
                    totalCostLabel.text = "$\(text)"
                } else {
                    billTotalTextField.text = "$\(text)"
                    totalCostLabel.text = "$\(text)"
                }
            } else if text == "$." {
                billTotalTextField.text = "$0."
                totalCostLabel.text = "$0."
            }
            else if text != "" {
                totalCostLabel.text = text
            } else {
                totalCostLabel.text = "$0.00"
            }
            
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            print("hi: \(string)")
            let decimalIndex = text.firstIndex(of: ".")
            if decimalIndex != nil && string == "." {
                return false
            } else if decimalIndex != nil && text.distance(from: decimalIndex!, to: text.endIndex) == 3 && string != "" {
                return false
            } else if text == "" && string == "0" {
                return false
            } else if text == "$" && string == "0" {
                return false
            } else {
                return true
            }
        }
        return true
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
            incrementSelectorController.selectedSegmentIndex = 0
            incrementSelectorController.isEnabled = false
        }
        
    }

}

