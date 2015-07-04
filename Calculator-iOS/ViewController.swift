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
            self.userStartedTyping = false
            self.userAppendedDot = false
            
            if newValue == 0 {
                self.display.text = "0"
            } else {
                self.display.text = "\(newValue)"
            }
        }
    }
    
    var userStartedTyping = false
    var userAppendedDot = false
    
    //  The calculator model
    var brain = CalcBrain()
    
    //  
    //  This method is called when pressing on a button.
    //
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userStartedTyping {
            self.display.text = self.display.text! + digit
        } else {
            self.display.text = digit
            self.userStartedTyping = true
        }
    }
    
    @IBAction func appendDot(sender: UIButton) {
        if !userAppendedDot {
            self.userAppendedDot = true
            
            if userStartedTyping {
                self.display.text = self.display.text! + "."
            } else {
                self.userStartedTyping = true
                self.display.text = "0."
            }
        }
    }
    
    @IBAction func enter() {
        self.userStartedTyping = false
        
        if let result = self.brain.pushOperand(displayValue) {
            self.displayValue = result
        } else {
            self.displayValue = 0
        }
    }
    
    @IBAction func performOperation(sender: UIButton) {
        if self.userStartedTyping {
            self.enter()
        }
        
        if let operation = sender.currentTitle {
            if let result = self.brain.performOperation(operation) {
                self.displayValue = result
            } else {
                self.displayValue = 0
            }
        }
    }
    
    @IBAction func reset() {
        self.brain.reset()
        self.userStartedTyping = false
        self.userAppendedDot = false
        self.displayValue = 0
    }
    
}
