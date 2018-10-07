//
//  ViewController.swift
//  tip-calculator
//
//  Created by Jacob Shoemaker on 10/6/18.
//  Copyright © 2018 Jacob Shoemaker. All rights reserved.
//

//change tip % if tip input - model
//change tip % when slider change
//change tip input when slider change - model
//change total cost with tip change - model
//change split when split slider change
//adjust total cost - model
//adjust split cost if round changed - model
//adjust split cost if round to change - model

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var stackBottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var billTotalTextField: UITextField!
    @IBOutlet weak var roundSelectorController: UISegmentedControl!
    @IBOutlet weak var incrementSelectorController: UISegmentedControl!
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var tipTotalTextField: UITextField!
    @IBOutlet weak var tipPercentLabel: UILabel!
    @IBOutlet weak var tipSlider: UISlider!
    @IBOutlet weak var splitSlider: UISlider!
    @IBOutlet weak var splitLabel: UILabel!
    @IBOutlet weak var splitCostLabel: UILabel!
    
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
        tipTotalTextField.delegate = self
        tipTotalTextField.addTarget(self, action: #selector(ViewController.tipTotalTextFieldDidChange(_:)), for: UIControl.Event.editingChanged)
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
            } else if text == "$0" {
                billTotalTextField.text = "$"
                totalCostLabel.text = "$"
            }
            else if text != "" {
                totalCostLabel.text = text
            } else {
                totalCostLabel.text = "$0.00"
            }
            
        }
        
    }
    
    @objc func tipTotalTextFieldDidChange(_ textField: UITextField) {
        //use model to calculate tip%
        if let text = tipTotalTextField.text {
            if text.first == "$" {
                let tipDouble = Double(text.dropFirst())
                print(tipDouble)
            } else {
                let tipDouble = Double(text)
                print(tipDouble)
            }
            
            if text.count == 1 && !text.contains("$") {
                if text.first == "." {
                    tipTotalTextField.text = "$0\(text)"
                    //tipPercentLabel.text = "\(tipTotalTextField.text as! Double / billTotalTextField.text as! Double)"
                } else {
                    tipTotalTextField.text = "$\(text)"
                    //totalCostLabel.text = "$\(text)"
                }
            } else if text == "$." {
                tipTotalTextField.text = "$0."
                //totalCostLabel.text = "$0."
            } else if text == "$0" {
                tipTotalTextField.text = "$"
                //totalCostLabel.text = "$"
            }
            else if text != "" {
                //totalCostLabel.text = text
            } else {
                //totalCostLabel.text = "$0.00"
            }
            
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            //print("hi: \(string)")
            let decimalIndex = text.firstIndex(of: ".")
            if decimalIndex != nil && string == "." {
                return false
            } else if decimalIndex != nil && text.distance(from: decimalIndex!, to: text.endIndex) == 3 && string != "" {
                return false
            } else if text == "" && string == "0" {
                return false
            } else if text == "$" && string == "0" {
                return false
            }
            else {
                return true
            }
        }
        return true
    }
    
    @IBAction func roundSelectControllerPressed(_ sender: Any) {
        let index = roundSelectorController.selectedSegmentIndex
        //print(index)
        
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

