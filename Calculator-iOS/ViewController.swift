//
//  ViewController.swift
//  Calculator
//
//  Created by Jonathan Yaniv on 7/1/15.
//  Copyright (c) 2015 Jonathan Yaniv. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //  Result display label
    @IBOutlet weak var display: UILabel!
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        
        set {
            userStartedTyping = false
            
            if newValue == 0 {
                display.text = "0"
            } else {
                display.text = "\(newValue)"
            }
        }
    }
    
    var userStartedTyping = false
    
    var brain = CalcBrain()
    
    //  
    //  This method is called when pressing on a button.
    //
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userStartedTyping {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userStartedTyping = true
        }
    }
    
    @IBAction func enter() {
        userStartedTyping = false
        
        if let result = self.brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    @IBAction func performOperation(sender: UIButton) {
        if userStartedTyping {
            enter()
        }
        
        if let operation = sender.currentTitle {
            if let result = self.brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }
    
    @IBAction func reset() {
        self.brain.reset()
        displayValue = 0
    }
    
}
