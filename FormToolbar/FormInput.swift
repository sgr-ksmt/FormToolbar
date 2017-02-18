//
//  FormInput.swift
//  FormToolbar
//
//  Created by Suguru Kishimoto on 2/18/17.
//  Copyright © 2017 Suguru Kishimoto. All rights reserved.
//

import Foundation

/// FormInput protocol
/// Handle UITextField and UITextView in the same way.
public protocol FormInput: UITextInput {
    var inputAccessoryView: UIView? { get set }
    var responder: UIResponder { get }
    var view: UIView { get }
    var inputtedText: String { get set }
}

extension UITextField: FormInput {
    public var responder: UIResponder {
        return self as UIResponder
    }
    
    public var view: UIView {
        return self as UIView
    }
    
    public var inputtedText: String {
        get {
            return text ?? ""
        }
        set {
            text = newValue
        }
    }
}

extension UITextView: FormInput {
    public var responder: UIResponder {
        return self as UIResponder
    }
    
    public var view: UIView {
        return self as UIView
    }
    
    public var inputtedText: String {
        get {
            return text
        }
        set {
            text = newValue
        }
    }
}
