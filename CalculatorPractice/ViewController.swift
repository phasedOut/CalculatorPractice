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
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text! = String(newValue)
        }
    }
    
    @IBAction func touchButton(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text
            display.text = textCurrentlyInDisplay! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        if let mathematicalSymbol = sender.currentTitle {
            switch mathematicalSymbol {
            case "π":
                display.text = String(Double.pi)
            case "e":
                display.text = String(M_E)
            case "√":
                displayValue = sqrt(displayValue)
            default:
                break
            }
        }
    }
    
}

