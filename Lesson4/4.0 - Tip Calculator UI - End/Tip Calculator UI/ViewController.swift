//
//  ViewController.swift
//  Tip Calculator UI
//
//  Created by Paul Solt on 10/10/17.
//  Copyright © 2017 Paul Solt. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    // Outlets
    @IBOutlet weak var tip1Label: UILabel!
    @IBOutlet weak var tip2Label: UILabel!
    @IBOutlet weak var tip3Label: UILabel!
    @IBOutlet weak var billTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        billTextField.delegate = self
        
        // Listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardDidChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardDidChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardDidChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // Actions
    @IBAction func calculateTipButtonPressed(_ sender: Any) {
        print("Calculate Tip!")

        hideKeyboard()
        calculateAllTips()
    }
    
    // UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        calculateAllTips()
        return true
    }
    
    
    // Methods
    
    func calculateAllTips() {
        // Get the subtotal as a number
        guard let subtotal = convertCurrencyToDouble(input: billTextField.text!) else {
            print("Error invalid number: \(billTextField.text!)")
            return
        }
        
        print("The subtoal is: \(subtotal)")
        
        // Calculate tips
        let tip1 = calculateTip(subtotal: subtotal, tipPercentage: 10.0)
        let tip2 = calculateTip(subtotal: subtotal, tipPercentage: 15.0)
        let tip3 = calculateTip(subtotal: subtotal, tipPercentage: 20.0)
        
        // Update the UI
        tip1Label.text = convertDoubleToCurrency(amount: tip1)
        tip2Label.text = convertDoubleToCurrency(amount: tip2)
        tip3Label.text = convertDoubleToCurrency(amount: tip3)
    }
    
    /// - parameter tipPercentage: a value from 0 to 100
    func calculateTip(subtotal: Double, tipPercentage: Double) -> Double {
        return subtotal * (tipPercentage / 100.0)
    }
    
    func convertCurrencyToDouble(input: String) -> Double? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        
        return numberFormatter.number(from: input)?.doubleValue
    }
    
    func convertDoubleToCurrency(amount: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        
        return numberFormatter.string(from: NSNumber(value: amount))!
    }
    
    func hideKeyboard() {
        print("Hide keyboard")
        billTextField.resignFirstResponder()
    }
    
    @objc func keyboardDidChange(notification: Notification) {
        print("keyboardDidChange \(notification.name)")
        
        // Actual keyboard height
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        // Show or Hide
        
        if notification.name == UIResponder.keyboardWillShowNotification ||
            notification.name == UIResponder.keyboardWillChangeFrameNotification {
            view.frame.origin.y = -keyboardRect.height
        } else {
            view.frame.origin.y = 0
        }
    }
    
    
}

