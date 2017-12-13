//
//  FormToolbar.swift
//  FormToolbar
//
//  Created by Suguru Kishimoto on 2/18/17.
//  Copyright © 2017 Suguru Kishimoto. All rights reserved.
//

import UIKit

final public class FormToolbar: UIToolbar {
    
    /// Direction
    /// 
    /// Back/Forward arrow button type.
    ///
    /// - upDown: Back/Forward are "^" "v"
    /// - leftRight: Back/Forward are "<" ">"
    public enum Direction {
        case upDown
        case leftRight
    }
    
    private class FormItem {
        weak var input: FormInput?
        weak var previousInput: FormInput?
        weak var nextInput: FormInput?
    }

    private var _backButton: UIBarButtonItem?
    private var backButton: UIBarButtonItem {
        if let button = _backButton {
            return button
        }
        let button = UIBarButtonItem(barButtonHiddenItem: self.backButtonType, target: self, action: #selector(backButtonDidTap(_:)))
        _backButton = button
        return button
    }

    private var _fixedSpacer: UIBarButtonItem?
    private var fixedSpacer: UIBarButtonItem {
        if let spacer = _fixedSpacer {
            return spacer
        }
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = self.direction == .upDown ? 8.0 : 20.0
        _fixedSpacer = spacer
        return spacer
    }

    private var _forwardButton: UIBarButtonItem?
    private var forwardButton: UIBarButtonItem {
        if let button = _forwardButton {
            return button
        }
        let button = UIBarButtonItem(barButtonHiddenItem: self.forwardButtonType, target: self, action: #selector(forwardButtonDidTap(_:)))
        _forwardButton = button
        return button
    }
    
    private lazy var flexibleSpacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

    private var _doneButton: UIBarButtonItem?
    private var doneButton: UIBarButtonItem {
        if let button = _doneButton {
            return button
        }
        let button = UIBarButtonItem(title: self.doneButtonTitle, style: .done, target: self, action: #selector(doneButtonDidtap(_:)))
        _doneButton = button
        return button
    }
    
    private var formItems: [FormItem] = []
    
    private var backButtonType: UIBarButtonHiddenItem = .prev
    private var forwardButtonType: UIBarButtonHiddenItem = .next
    
    /// Back button's tint color.
    public var backButtonTintColor: UIColor? {
        didSet {
            backButton.tintColor = backButtonTintColor
        }
    }
    
    /// Forward button's tint color.
    public var forwardButtonTintColor: UIColor? {
        didSet {
            forwardButton.tintColor = forwardButtonTintColor
        }
    }

    /// Done button's tint color.
    public var doneButtonTintColor: UIColor? {
        didSet {
            doneButton.tintColor = doneButtonTintColor
        }
    }
    
    /// Set buttons' tint color
    ///
    /// - Parameter color: UIColor
    public func setButtonsTintColor(_ color: UIColor) {
        backButtonTintColor = color
        forwardButtonTintColor = color
        doneButtonTintColor = color
    }

    
    /// Back/Forward button arrow direction
    public var direction: Direction = .leftRight {
        didSet {
            switch direction {
            case .upDown:
                backButtonType = .up
                forwardButtonType = .down
            case .leftRight:
                backButtonType = .prev
                forwardButtonType = .next
            }
            _backButton = nil
            _forwardButton = nil
            _fixedSpacer = nil
            updateBarItems()
        }
    }
    
    /// Done button's title
    /// Default is `"Done"`.
    public var doneButtonTitle: String = "Done" {
        didSet {
            _doneButton = nil
            updateBarItems()
        }
    }
    
    private var currentFormItem: FormItem? {
        return formItems.filter { $0.input?.responder.isFirstResponder ?? false }.first
    }
    
    /// Get current input.
    public var currentInput: FormInput? {
        return currentFormItem?.input
    }

    /// Get previous input.
    public var previousInput: FormInput? {
        return currentFormItem?.previousInput
    }

    /// Get next input.
    public var nextInput: FormInput? {
        return currentFormItem?.nextInput
    }
    
    /// Initializer
    ///
    /// - Parameters:
    ///   - inputs: An array of FormInput.
    ///   - attachToolbarToInputs: If it is true, automatically add self to `input.inputAccessoryView`. 
    ///     default is `true`
    required convenience public init(inputs: [FormInput], attachToolbarToInputs: Bool = true) {
        self.init(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 44.0)))
        
        set(inputs: inputs, attachToolbarToInputs: attachToolbarToInputs)
        
        updateBarItems()
        update()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Set new form inputs to toolbar
    ///
    /// - Parameters:
    ///   - inputs: An array of FormInput.
    ///   - attachToolbarToInputs: If it is true, automatically add self to `input.inputAccessoryView`.
    ///     default is `true`
    public func set(inputs: [FormInput], attachToolbarToInputs: Bool = true) {
        
        // remove toolbar before releasing
        formItems.forEach { $0.input?.inputAccessoryView = nil }
        
        formItems = inputs.map { input in
            let formItem = FormItem()
            formItem.input = input
            return formItem
        }
        
        do {
            var lastFormItem: FormItem?
            formItems.forEach { formItem in
                lastFormItem?.nextInput = formItem.input
                formItem.previousInput = lastFormItem?.input
                lastFormItem = formItem
            }
        }
        
        if attachToolbarToInputs {
            inputs.forEach { $0.inputAccessoryView = self }
        }
    }
    
    /// Update toolbar's buttons.
    public func update() {
        guard let currentInput = currentInput else {
            backButton.isEnabled = false
            forwardButton.isEnabled = false
            return
        }

        backButton.isEnabled = false
        forwardButton.isEnabled = false

        for (index, formItem) in formItems.enumerated() {
            guard let input = formItem.input else {
                continue
            }
            
            if input.isEqual(currentInput) {
                let isFirstForm = index == 0
                let isLastForm = index == (formItems.count - 1)
                backButton.isEnabled = !isFirstForm && formItem.previousInput != nil
                forwardButton.isEnabled = !isLastForm && formItem.nextInput != nil
                break
            }
        }
    }
    
    /// Go back to previous input.
    public func goBack() {
        if let currentFormItem = currentFormItem {
            currentFormItem.input?.responder.resignFirstResponder()
            currentFormItem.previousInput?.responder.becomeFirstResponder()
        }
    }
    
    /// Go forward to next input.
    public func goForward() {
        if let currentFormItem = currentFormItem {
            currentFormItem.input?.responder.resignFirstResponder()
            currentFormItem.nextInput?.responder.becomeFirstResponder()
        }
    }
    
    private func updateBarItems() {
        let buttonItems: [UIBarButtonItem] = [backButton, fixedSpacer, forwardButton, flexibleSpacer, doneButton]
        setItems(buttonItems, animated: false)
    }
    
    @objc private func backButtonDidTap(_: UIBarButtonItem) {
        goBack()
    }
    
    @objc private func forwardButtonDidTap(_: UIBarButtonItem) {
        goForward()
    }
    
    @objc private func doneButtonDidtap(_: UIBarButtonItem) {
        currentFormItem?.input?.responder.resignFirstResponder()
    }
}
