//
//  ViewController.swift
//  Calculator
//
//  Created by Dan Christal on 2016-03-01.
//  Copyright © 2016 Dan Christal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var IsUserTypingDigit = false
    var brain = CalculatorBrain()
    
    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var display: UILabel!

    @IBAction func appendDigit(sender: UIButton) {

        let digit = sender.currentTitle!

        if(display.text!.rangeOfString(".") != nil && digit.containsString(".")){return}
        if IsUserTypingDigit {
            display.text = display.text! + digit
        }
        else {
            display.text = digit
            IsUserTypingDigit = true
        }

    }

    
    var displayValue: Double? {
        get {
            if let possibleDouble = NSNumberFormatter().numberFromString(display.text!){
            return possibleDouble.doubleValue
            } else {
                return nil
            }
        }
        set {
            if newValue != nil{
                display.text = String(format: "%g", newValue!)
                history.text = brain.showHistory()
                IsUserTypingDigit = false
            }
            else {
                brain.reset()
                history.text! = " "
                display.text = "0"
              //  display.text = String(format: "%g", newValue!)
               
            }
        }
    }
    @IBAction func changeSign(sender: UIButton) {
        if !displayValue!.isZero{
            if IsUserTypingDigit {
                display.text = String(format: "%g",(displayValue! * -1))
            } else {
                operate(sender)
            }
        }
        
    }

    @IBAction func backspace(sender: UIButton) {
        if IsUserTypingDigit{
            display.text! = String(display.text!.characters.dropLast())
            if display.text!.isEmpty == true {
                displayValue = 0
            }
        }
    }

    
    
    @IBAction func clearProgram() {
        brain.reset()
        displayValue = 0
    }
    
    @IBAction func operate(sender: UIButton) {
        
        if IsUserTypingDigit {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
                history.text!.appendContentsOf("=")

            } else {
                displayValue = 0
            }
        
        }
    }
    

    @IBAction func enter() {
        IsUserTypingDigit = false
        if (displayValue != nil) {
            if let result = brain.pushOperand(displayValue!){
                displayValue = result
            }
        }else {
            displayValue = 0
        }
        
    }


}
