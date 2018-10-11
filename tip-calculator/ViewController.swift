//
//  ViewController.swift
//  tip-calculator
//
//  Created by Jacob Shoemaker on 10/6/18.
//  Copyright © 2018 Jacob Shoemaker. All rights reserved.
//

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
                    updateTip()
                    updateTotalCost()
                    updateSplitCost()
                } else {
                    billTotalTextField.text = "$\(text)"
                    totalCostLabel.text = "$\(text)"
                    updateTip()
                    updateTotalCost()
                    updateSplitCost()
                }
            } else if text == "$." {
                billTotalTextField.text = "$0."
                totalCostLabel.text = "$0."
                updateTip()
                updateTotalCost()
                updateSplitCost()
            } else if text == "$0" {
                billTotalTextField.text = "$"
                totalCostLabel.text = "$"
                updateTip()
                updateTotalCost()
                updateSplitCost()
            }
            else if text != "" {
                totalCostLabel.text = text
                updateTip()
                updateTotalCost()
                updateSplitCost()
            } else {
                totalCostLabel.text = "$0.00"
                updateTip()
                updateTotalCost()
                updateSplitCost()
            }
            
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
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
    
    func updateTip() {
        if let text = billTotalTextField.text {
            if text != "" && text != "$"{
                let start = text.index(text.startIndex, offsetBy: 1)
                let end = text.endIndex
                let range = start..<end
                let calculation = Double(tipSlider.value) / 100.0 * Double(text[range])!
                tipTotalTextField.text = "$\(String(format: "%.2f", calculation))"
            }
            
        } else {
            tipTotalTextField.text = ""
        }
    }
    
    func updateTotalCost() {
        if let text = billTotalTextField.text {
            if let tipText = tipTotalTextField.text {
                if text != "" && text != "$" {
                    let start = text.index(text.startIndex, offsetBy: 1)
                    let end = text.endIndex
                    let range = start..<end
                    let tipStart = tipText.index(tipText.startIndex, offsetBy: 1)
                    let tipEnd = tipText.endIndex
                    let tipRange = tipStart..<tipEnd
                    let calculation = Double(text[range])! + Double(tipText[tipRange])!
                    totalCostLabel.text = "$\(String(format: "%.2f", calculation))"
                } else {
                    totalCostLabel.text = "$0.00"
                }
                
            }
        }
        
    }
    
    func updateSplitCost() {
        if let text = totalCostLabel.text {
            if text != "" || text != "$" {
                
                let startTotal = text.index(text.startIndex, offsetBy: 1)
                let endTotal = text.endIndex
                let rangeTotal = startTotal..<endTotal
                let calculation = Double(text[rangeTotal])! / Double(splitSlider.value)

                let roundTo = incrementSelectorController.selectedSegmentIndex
                let roundDirection = roundSelectorController.selectedSegmentIndex
                
                var denominator = 4.0
                
                if roundTo == 1 {
                    denominator = 2.0
                } else if roundTo == 2 {
                    denominator = 1.0
                }
                
                if roundDirection == 0 {
                    
                    if let billText = billTotalTextField.text {
                        if billText != "" && billText != "$" {
                            let startBill = billText.index(billText.startIndex, offsetBy: 1)
                            let endBill = billText.endIndex
                            let rangeBill = startBill..<endBill
                            
                            if floor(calculation * denominator) / denominator * Double(splitSlider.value ) <= Double(billText[rangeBill])! {
                                print(floor(calculation * denominator) / denominator)
                                print(Double(billText[rangeBill])!)
                                splitCostLabel.text = "$\(String(format: "%.2f", calculation))"
                            } else {
                                splitCostLabel.text = "$\(String(format: "%.2f",floor(calculation * denominator) / denominator))"
                            }
                            
                        }
                    }
                    
                } else if roundDirection == 2 {
                    splitCostLabel.text = "$\(String(format: "%.2f",ceil(calculation * denominator) / denominator))"
                } else {
                    splitCostLabel.text = "$\(String(format: "%.2f", calculation))"
                }
                
            }
            
        } else {
            tipTotalTextField.text = ""
        }
    }

    @IBAction func tipSliderSlid(_ sender: Any) {
        let roundedValue = round(tipSlider.value)
        tipSlider.value = roundedValue
        tipPercentLabel.text = "\(Int(tipSlider.value))%"
        updateTip()
        updateTotalCost()
        updateSplitCost()
    }
    
    @IBAction func splitSliderSlid(_ sender: Any) {
        let roundedValue = round(splitSlider.value)
        splitSlider.value = roundedValue
        
        splitLabel.text = "\(Int(splitSlider.value))"
        updateSplitCost()
    }
    
    
    @IBAction func roundSelectControllerPressed(_ sender: Any) {
        let index = roundSelectorController.selectedSegmentIndex
        
        if index == 0 {
            updateSplitCost()
            incrementSelectorController.isEnabled = true
        } else if index == 2 {
            updateSplitCost()
            incrementSelectorController.isEnabled = true
        } else {
            updateSplitCost()
            incrementSelectorController.selectedSegmentIndex = 0
            incrementSelectorController.isEnabled = false
        }
        
    }
    
    @IBAction func incrementSelectControllerPressed(_ sender: Any) {
        updateSplitCost()
    }
    
    
}

