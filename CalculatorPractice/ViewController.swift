//
//  ViewController.swift
//  CalculatorPractice
//
//  Created by Yuji Sakai on 2017/10/09.
//  Copyright © 2017 Yuji Sakai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    
    private var brain = CalculatorBrain()
    
    private var userIsUsingADecimalPoint = false
    
    var displayValue: Double {
        get {
            return Double(display.text!) ?? 0.0
        }
        set {
            display.text! = String(newValue)
        }
    }
    
    @IBAction func touchButton(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if digit == "." {
            if userIsUsingADecimalPoint {
                return
            } else {
                userIsUsingADecimalPoint = true
            }
        }
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text
            display.text = textCurrentlyInDisplay! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }
        userIsUsingADecimalPoint = false
    }
}

