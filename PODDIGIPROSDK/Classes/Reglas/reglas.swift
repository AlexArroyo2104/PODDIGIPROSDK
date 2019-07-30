//
//  PasswordValidatorEngine.swift
//  GenericPasswordRow
//
//  Created by Diego Ernst on 9/1/16.
//  Copyright © 2016 Diego Ernst. All rights reserved.
//

import UIKit
import Foundation

// MARK: - REQUERIDO
public struct ReglaRequerido<T: Equatable>: RuleType {
    public init(msg: String = "Campo requerido!", id: String? = nil) {
        self.validationError = ValidationError(msg: msg)
        self.id = id
    }
    public var id: String?
    public var validationError: ValidationError
    public func isValid(value: T?) -> ValidationError? {
        if let str = value as? String {
            return str.isEmpty ? validationError : nil
        }
        return value != nil ? nil : validationError
    }
}

// MARK: - MIN LONGITUD
public struct ReglaMinLongitud: RuleType {
    
    let min: UInt
    
    public var id: String?
    public var validationError: ValidationError
    
    public init(minLength: UInt, msg: String? = nil, id: String? = nil) {
        let ruleMsg = msg ?? "El campo debe contener al menos \(minLength) caracteres"
        min = minLength
        validationError = ValidationError(msg: ruleMsg)
        self.id = id
    }
    
    public func isValid(value: String?) -> ValidationError? {
        guard let value = value else { return nil }
        return value.count < Int(min) ? validationError : nil
    }
}

// MARK: - RANGE NUMBER
public struct ReglaRangoNumerico: RuleType {
    
    let min: UInt
    let max: UInt
    
    public var id: String?
    public var validationError: ValidationError
    
    public init(minNumber: UInt, maxNumber: UInt, msg: String? = nil, id: String? = nil) {
        let ruleMsg = msg ?? "El campo debe estar entre el rango de: \(minNumber)-\(maxNumber)"
        max = maxNumber
        min = minNumber
        validationError = ValidationError(msg: ruleMsg)
        self.id = id
    }
    
    public func isValid(value: String?) -> ValidationError? {
        guard let value = value else { return nil }
        let n = Int(value)
        if n == nil { return nil }
        return n! >= Int(min) && n! <= Int(max) ? nil : validationError
    }
}

// MARK: - MAX LONGITUD
public struct ReglaMaxLongitud: RuleType {
    
    let max: UInt
    
    public var id: String?
    public var validationError: ValidationError
    
    public init(maxLength: UInt, msg: String? = nil, id: String? = nil) {
        let ruleMsg = msg ?? "El campo debe contener máximo \(maxLength) caracteres"
        max = maxLength
        validationError = ValidationError(msg: ruleMsg)
        self.id = id
    }
    
    public func isValid(value: String?) -> ValidationError? {
        guard let value = value else { return nil }
        return value.count > Int(max) ? validationError : nil
    }
}

// MARK: - EXACTA LONGITUD
public struct ReglaExactaLongitud: RuleType {
    let length: UInt
    
    public var id: String?
    public var validationError: ValidationError
    
    public init(exactLength: UInt, msg: String? = nil, id: String? = nil) {
        let ruleMsg = msg ?? "El campo debe contener exactamente \(exactLength) caracteres"
        length = exactLength
        validationError = ValidationError(msg: ruleMsg)
        self.id = id
    }
    
    public func isValid(value: String?) -> ValidationError? {
        guard let value = value else { return nil }
        return value.count != Int(length) ? validationError : nil
    }
}

// MARK: REGEXP
open class ReglaExpReg: RuleType {
    
    public var regExpr: String = ""
    public var id: String?
    public var validationError: ValidationError
    public var allowsEmpty = true
    
    public init(regExpr: String, allowsEmpty: Bool = true, msg: String = "Valor inválido!", id: String? = nil) {
        self.validationError = ValidationError(msg: msg)
        self.regExpr = regExpr
        self.allowsEmpty = allowsEmpty
        self.id = id
    }
    
    public func isValid(value: String?) -> ValidationError? {
        if let value = value, !value.isEmpty {
            let predicate = NSPredicate(format: "SELF MATCHES %@", regExpr)
            guard predicate.evaluate(with: value) else {
                return validationError
            }
            return nil
        } else if !allowsEmpty {
            return validationError
        }
        return nil
    }
}
////
// FECHAS
////

// MARK: - Fecha Nomenclatura
public struct FechaNomenclatura: RuleType {
    
    let min: UInt
    
    public var id: String?
    public var validationError: ValidationError
    
    public init(minLength: UInt, msg: String? = nil, id: String? = nil) {
        let ruleMsg = msg ?? "El campo debe contener al menos \(minLength) caracteres"
        min = minLength
        validationError = ValidationError(msg: ruleMsg)
        self.id = id
    }
    
    public func isValid(value: String?) -> ValidationError? {
        guard let value = value else { return nil }
        return value.count < Int(min) ? validationError : nil
    }
}
