//
//  FormInput.swift
//  FormToolbar
//
//  Created by Suguru Kishimoto on 2/18/17.
//  Copyright © 2017 Suguru Kishimoto. All rights reserved.
//

import Foundation

public protocol FormInput: UITextInput {
    var inputAccessoryView: UIView? { get set }
    var responder: UIResponder { get }
    var view: UIView { get }
}

extension UITextField: FormInput {
    public var responder: UIResponder {
        return self as UIResponder
    }
    
    public var view: UIView {
        return self as UIView
    }
}

extension UITextView: FormInput {
    public var responder: UIResponder {
        return self as UIResponder
    }
    
    public var view: UIView {
        return self as UIView
    }
}
