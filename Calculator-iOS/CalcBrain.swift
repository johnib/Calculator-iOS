//
//  CalcBrain.swift
//  Calculator
//
//  Created by Jonathan Yaniv on 7/1/15.
//  Copyright (c) 2015 Jonathan Yaniv. All rights reserved.
//

import Foundation

class CalcBrain {
    
    //  An Op can be any operand (a number) or an operator (+, √, sin, etc..)
    private enum Op: Printable {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    //  The stack that keeps all operands and operators entered by the user.
    private var opStack = [Op]()
    
    //  The dictionary that keeps all known operators.
    private var knownOps = [String:Op]()
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("÷") { $1 / $0 })
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("−") { $1 - $0 })
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("sin", sin))
        learnOp(Op.UnaryOperation("cos", cos))
    }
    
    private func evaluate(var stack: Array<Op>) -> (result: Double?,
        remaining: [Op]) {
            
            if !stack.isEmpty {
                let op = stack.removeLast()
                switch op {
                case .Operand(let operand):
                    return (operand, stack)
                    
                case .UnaryOperation(_, let operation):
                    let evalResult = evaluate(stack)
                    if let operand = evalResult.result {
                        return (operation(operand), evalResult.remaining)
                    }
                    
                case .BinaryOperation(_, let operation):
                    let evalResult1 = evaluate(stack)
                    if let op1 = evalResult1.result {
                        let evalResult2 = evaluate(evalResult1.remaining)
                        if let op2 = evalResult2.result {
                            return (operation(op1, op2), evalResult2.remaining)
                        }
                    }
                }
            }
            
            return (nil, stack)
    }
    
    //
    //  Evaluates the opStack
    //
    private func evaluate() -> Double? {
        let (result, remaining) = evaluate(opStack)
        println("\(opStack) = \(result) with remaining \(remaining)")
        
        return result
    }
    
    //
    //  Adds the specified operand to the opStack.
    //
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        let result = evaluate()
        
        return result
    }
    
    //
    //  Adds the specified operation to the opStack to be evaluated.
    //
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        
        let result = evaluate()
        
        return result
    }
    
    //
    //  Resets the ops' stack
    //
    func reset() {
        opStack = [Op]()
    }
}
