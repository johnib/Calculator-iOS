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
    
    //  The history label
    @IBOutlet weak var history: UILabel!
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        
        set {
            self.userStartedTyping = false
            
            if newValue == 0 {
                self.display.text = "0"
            } else {
                self.display.text = "\(newValue)"
            }
        }
    }
    
    var userStartedTyping = false { didSet { self.userAppendedDot = false } }
    var userAppendedDot = false
    
    //  The calculator model
    var brain = CalcBrain()
    
    //  
    //  This method is called when pressing on a button.
    //
    @IBAction func appendDigit(sender: UIButton) {
        let digit = self.getDigitFrom(sender)
        
        if userStartedTyping {
            self.display.text = self.display.text! + digit
        } else {
            self.display.text = digit
            self.userStartedTyping = true
        }
    }
    
    //
    //  This private method evaluates the Double value of the given number
    //  button.
    //
    private func getDigitFrom(sender: UIButton) -> String {
        var digit: String
        
        switch sender.currentTitle! {
        case "∏": digit = "\(M_PI)"
        case "e": digit = "\(M_E)"
        default: digit = sender.currentTitle!
        }

        return digit
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
    
    //
    //  This method changes the sign of the current displayed nubmer.
    //
    @IBAction func changeSign(sender: UIButton) {
        let currentDisplayedNumber = self.displayValue
        
        self.displayValue = -currentDisplayedNumber
    }
    
    @IBAction func reset() {
        self.brain.reset()
        self.history.text = ""
        self.userStartedTyping = false
        self.displayValue = 0
    }
    
}
