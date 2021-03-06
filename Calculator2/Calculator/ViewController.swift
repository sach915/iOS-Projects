//
//  ViewController.swift
//  Calculator
//
//  Created by Sach Vaidya on 6/15/17.
//  Copyright © 2017 Sach Vaidya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel! // IMPLICITLY UNWRAPPED OPTIONAL
    //of type optional uilabel because ios needs a quick second to set the optional and connect ui to code. Whenenver it needs to be used you need to unwrap it with ! again
    
    @IBOutlet weak var descriptionDisplay: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    var decimalPressed = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        //print("\(digit) was called")
        let textCurrentlyInDisplay = display!.text!
        
        if userIsInTheMiddleOfTyping
        {
            //Handling decimal values in display
            if decimalPressed
            {
                if digit != "."
                {
                    display!.text = textCurrentlyInDisplay + digit
                }
            }
            else if digit == "."
            {
                display!.text = textCurrentlyInDisplay + digit
                decimalPressed = true
            }
            else
            {
                display!.text = textCurrentlyInDisplay + digit
            }
        }
        else{
            if digit == "."
            {
                display!.text = "0."
                decimalPressed = true
            }
            else{
                display!.text = digit
            }
            userIsInTheMiddleOfTyping = true;
        }
        
    }
    var displayValue: Double{
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
            // newValue is default for RHS when using assignment operator
        }
    }
    
    //Initialize a private member variable of type calcbrain
    private var brain = CalculatorBrain()
    var dictValues : Dictionary<String,Double>? = nil
    var variableSaved: Bool = false
    
    @IBAction func performOperation(_ sender: UIButton) {
        
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
        }
        
        userIsInTheMiddleOfTyping = false
        decimalPressed = false
        
        if let mathematicalSymbol = sender.currentTitle{
            brain.performOperation(mathematicalSymbol)
            
            let evaluation:(Double?,Bool,String)
            
            if(dictValues != nil)
            {
                evaluation = brain.evaluate(using: dictValues)
            }
            else 
            {
                evaluation = brain.evaluate()
            }
            
            if(evaluation.0 != nil)
            {
                displayValue = evaluation.0!
            }
            
            
            descriptionDisplay!.text = evaluation.2
            
        }
    }
    
    @IBAction func saveVariable(_ sender: UIButton) {
        brain.setOperand(variable: "M")
        dictValues = nil
        variableSaved = true
    }
    
    
    
    @IBAction func evaluateVariable(_ sender: UIButton) {
        //print(displayValue)
        
        if(variableSaved)
        {
            dictValues = ["M":displayValue]
            let (result,_,description) = brain.evaluate(using: dictValues)
            
            if result != nil{
                displayValue = result!
                descriptionDisplay!.text = description
            }
            
            userIsInTheMiddleOfTyping = false
            variableSaved = false
        }
        
    }
}


