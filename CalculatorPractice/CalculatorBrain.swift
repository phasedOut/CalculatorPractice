//
//  CalculatorBrain.swift
//  CalculatorPractice
//
//  Created by Yuji Sakai on 2017/10/09.
//  Copyright © 2017 Yuji Sakai. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator: Double?
    
    private var resultIsPending = false
    
    var description: String?
    
    var temp: String = ""
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
        case clear
        case clearEverything
    }
    
    private var operations: Dictionary<String,Operation> =
    [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "±" : Operation.unaryOperation{ -$0 },
        "×" : Operation.binaryOperation{$0 * $1},
        "÷" : Operation.binaryOperation{$0 / $1},
        "−" : Operation.binaryOperation{$0 - $1},
        "+" : Operation.binaryOperation{$0 + $1},
        "=" : Operation.equals,
        "C" : Operation.clear,
        "C/E" : Operation.clearEverything
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                if description != nil {
                    description! += symbol
                } else {
                    description = symbol
                }
                accumulator = value
            case .unaryOperation(let function):
                if description != nil {
                    if resultIsPending {
                        temp = description! + "\(symbol)(\(accumulator!))"
                        description = temp //change to String(accumulator!)to revert
                    } else {
                        description = "\(symbol)(\(description!))"
                    }
                } else {
                    description = "\(symbol)(\(accumulator!))"
                }
                
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }

            case .binaryOperation(let function):
                if accumulator != nil {
                    resultIsPending = true
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!, symbol: symbol)
                    
                    if description != nil {
                        description = description! + " \(symbol)" //+ " ..."
                    } else {
                        description = String(describing: pendingBinaryOperation!.firstOperand) + " \(symbol)" //+ " ..."
                    }
                    
                    
                    accumulator = nil
                }
            case .equals:
                resultIsPending = false
                performPendingBinaryOperation()
            case .clear:
                clear()
            case .clearEverything:
                clearEverything()
            }
        }
    }
    
    private mutating func clear() {
        accumulator = 0
    }
    private mutating func clearEverything() {
        accumulator = 0
        pendingBinaryOperation = nil
        description = nil
        temp = ""
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            //description = String(describing: pendingBinaryOperation!.firstOperand) + String(describing: pendingBinaryOperation!.symbol) + String(accumulator!) //+ "=" //change to String(accumulator!)to revert
            if description != nil {
                description = description! + String(accumulator!)
            } else {
                description = String(describing: pendingBinaryOperation!.firstOperand) + String(describing: pendingBinaryOperation!.symbol) + String(accumulator!) //+ "=" //change to String(accumulator!)to revert
            }
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        let symbol: String
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    var descriptionResult: String? {
        get {
            if description != nil {
                if resultIsPending {
                    return description! + " ... "
                } else {
                    return description! + " = "
                }
            } else {
                return ""
            }
        }
    }
    
}
