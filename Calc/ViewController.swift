//
//  ViewController.swift
//  Calc
//
//  Created by Илья Аношин on 11.10.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var displayResultLabel: UILabel!
    var stillTyping = false
    var firstOperand: Double = 0
    var secondOperand: Double = 0
    var operationSign: String = ""
    var dotIsPlaced = false
    
    var currentInput: Double {
        get {
            return Double(displayResultLabel.text!)!
        }
        set {
            let value = "\(newValue)"
            let valueArray = value.components(separatedBy: ".")
            if valueArray[1] == "0" {
                displayResultLabel.text = "\(valueArray[0])"
            } else {
                displayResultLabel.text = "\(newValue)"
            }
           
            stillTyping = false
        }
    }

    @IBAction func numberPressed(_ sender: UIButton) {
        let number = sender.currentTitle!
        
        if displayResultLabel.text == "0" && stillTyping {
                displayResultLabel.text = number
                stillTyping = false
            }
        
        if stillTyping {
            if displayResultLabel.text!.count < 20 {
            displayResultLabel.text = displayResultLabel.text! + number
        }
        } else {
            displayResultLabel.text = number
            stillTyping = true
        }
 }
  
    @IBAction func twoOperandsSignPressed(_ sender: UIButton) {
        operationSign = sender.currentTitle!
        firstOperand = currentInput
        stillTyping = false
        dotIsPlaced = false
    }
    
    func operateWithTwoOperands (operation: (Double, Double) -> Double){
        currentInput = operation(firstOperand, secondOperand)
        stillTyping = false
    }
    
    func divideByZeroFailure() {
        let zeroDivideFailure = UIAlertController(title: "Ошибка!", message: "Невозможно разделить на 0!", preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction (title: "Окей", style: UIAlertAction.Style.default,
            handler: nil)
            zeroDivideFailure.addAction(okButton)
        
        self.present(zeroDivideFailure,
            animated: true, completion: nil)
    }
    
    
    @IBAction func equalitySignPressed(_ sender: UIButton) {
        if stillTyping {
            secondOperand = currentInput
        }
        
        dotIsPlaced = false
        
        
        if secondOperand == 0 && operationSign == "÷"{
            self.divideByZeroFailure()
        } else {
        switch operationSign {
        case "+":
            operateWithTwoOperands {$0 + $1}
        case "-":
            operateWithTwoOperands {$0 - $1}
        case "×":
            operateWithTwoOperands {$0 * $1}
        case "÷":
            operateWithTwoOperands {$0 / $1}
        
        default: break
        }
    }
    }
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        firstOperand = 0
        secondOperand = 0
        currentInput = 0
        operationSign = ""
        stillTyping = false
        displayResultLabel.text = "0"
        dotIsPlaced = false
    }
    
    @IBAction func plusMinusButtonPressed(_ sender: UIButton) {
        currentInput = -currentInput
    }
    
    @IBAction func percentageButtonPressed(_ sender: UIButton) {
        if firstOperand == 0 {
            currentInput = currentInput/100
        } else {
            secondOperand = firstOperand * currentInput / 100
        }
        stillTyping = false
    }
    
    func squareRootFailure() {
        let invalidSqrtSign = UIAlertController(title: "Ошибка!", message: "Невозможно извлечь квадратный корень из отрицательного числа!", preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction (title: "Окей", style: UIAlertAction.Style.default,
            handler: nil)
            invalidSqrtSign.addAction(okButton)
        
        self.present(invalidSqrtSign,
            animated: true, completion: nil)
    }
    
    @IBAction func squareRootButtonPressed(_ sender: UIButton) {
        if currentInput < 0 {
            self.squareRootFailure()
        } else{
        currentInput = sqrt(currentInput)
        }
    }
    
    @IBAction func dotButtonPressed(_ sender: UIButton) {
        if stillTyping && !dotIsPlaced {
            displayResultLabel.text = displayResultLabel.text! + "."
            dotIsPlaced = true
        } else if !stillTyping && !dotIsPlaced {
            displayResultLabel.text = "0."
        }
        stillTyping = true
    }
    
}

 
