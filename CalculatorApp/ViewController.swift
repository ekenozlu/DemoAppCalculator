//
//  ViewController.swift
//  CalculatorApp
//
//  Created by Eken Özlü on 23.05.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var calculatorWorkings: UILabel!
    @IBOutlet weak var calculatorResults: UILabel!
    
    @IBOutlet weak var allClearButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var percentageButton: UIButton!
    @IBOutlet weak var divideButton: UIButton!
    @IBOutlet weak var multiplyButton: UIButton!
    @IBOutlet weak var substractionButton: UIButton!
    @IBOutlet weak var additionButton: UIButton!
    @IBOutlet weak var resultButton: UIButton!
    @IBOutlet weak var decimalButton: UIButton!
    
    @IBOutlet weak var zeroButton: UIButton!
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    @IBOutlet weak var fiveButton: UIButton!
    @IBOutlet weak var sixButton: UIButton!
    @IBOutlet weak var sevenButton: UIButton!
    @IBOutlet weak var eightButton: UIButton!
    @IBOutlet weak var nineButton: UIButton!
    
    var workings: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearAll()
    }
    
    func addToWorkings(value: String) {
        workings = workings + value
        calculatorWorkings.text = workings
    }
    
    @IBAction func tapAction(_ sender: UIButton){
        if(sender == allClearButton){
            clearAll()
        }
        else if(sender == deleteButton){
            deleteFunc()
        }
        else if(sender == resultButton){
            resultFunc()
        }
        else if(sender == decimalButton){
            decimalFunc()
        }
        else if(sender == percentageButton || sender == divideButton || sender == multiplyButton ||
           sender == substractionButton || sender == additionButton){
            operationFunc(operationValue: (sender.titleLabel?.text)!)
        }
        else {
            numberFunc(numberValue: (sender.titleLabel?.text)!)
        }
    }
    
    func clearAll() {
        workings = ""
        calculatorWorkings.text = ""
        calculatorResults.text = ""
    }
    
    func deleteFunc() {
        if(!workings.isEmpty){
            workings.removeLast()
            calculatorWorkings.text = workings
        }
    }
    
    func resultFunc() {
        if(validInput()){
            let checkedWorkingsForPercent = workings.replacingOccurrences(of: "%", with: "*0.01")
            let expression = NSExpression(format: checkedWorkingsForPercent)
            let result = expression.expressionValue(with: nil, context: nil) as! Double
            let resultString = formatResult(result: result)
            calculatorResults.text = resultString
        }
        else{
            let alert = UIAlertController(title: "Invalid Calculation", message: "Calculator unable to do math based on this input", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default,handler: { _ in
                self.clearAll()
            }))
            self.present(alert, animated: true)
        }
    }
    
        func validInput() -> Bool {
            var count = 0
            var funcCharIndexes = [Int]()
            
            for char in workings {
                if(specialCharacter(char: char)){
                    funcCharIndexes.append(count)
                }
                count += 1
            }

            var previous: Int = -1
            
            for index in funcCharIndexes {
                if(index == 0){
                    return false
                }
                if(index == workings.count-1){
                    return false
                }
                if(previous != -1){
                    if(index - previous == 1){
                        return false
                    }
                    
                }
                previous = index
            }
            return true
        }
    
        func specialCharacter(char: Character) -> Bool {
            if (char == "*" || char == "/" || char == "%" || char == "+" || char == "-"){
                return true
            }
            return false
        }
    
        func formatResult(result: Double) -> String {
            if(result.truncatingRemainder(dividingBy: 1) == 0){
                return String(format: "%.0f", result)
            }
            else {
                return String(format: "%.2f", result)
            }
        }
    
    func decimalFunc() {
        if(calculatorResults.text!.isEmpty){
            if(!calculatorWorkings.text!.isEmpty){
                addToWorkings(value: ".")
            }
        }
        else {
            calculatorWorkings.text = "0."
            workings = calculatorWorkings.text!
            calculatorResults.text = ""
        }
    }
    
    func operationFunc(operationValue: String) {
        if(calculatorResults.text!.isEmpty){
            if(!calculatorWorkings.text!.isEmpty){
                addToWorkings(value: operationValue)
            }
        }
        else {
            calculatorWorkings.text = calculatorResults.text! + operationValue
            workings = calculatorWorkings.text!
            calculatorResults.text = ""
        }
    }
    
    func numberFunc(numberValue: String) {
        if(calculatorResults.text!.isEmpty){
                addToWorkings(value: numberValue)
        }
        else {
            clearAll()
            addToWorkings(value: numberValue)
        }
    }
}

