//
//  FormToolbar.swift
//  FormToolbar
//
//  Created by Suguru Kishimoto on 2/18/17.
//  Copyright © 2017 Suguru Kishimoto. All rights reserved.
//

import UIKit

final public class FormToolbar: UIToolbar {
    
    public enum Direction {
        case upDown
        case leftRight
    }
    
    class FormItem {
        weak var input: UITextInput?

        weak var previousInput: UITextInput?

        weak var nextInput: UITextInput?
    }
    
    private lazy var backButton: UIBarButtonItem! = {
        let button = UIBarButtonItem(barButtonHiddenItem: self.backButtonType, target: self, action: #selector(backButtonDidTap(_:)))
        return button
    }()
    
    private lazy var fixedSpacer: UIBarButtonItem = {
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 16.0
        return spacer
    }()
    
    private lazy var forwardButton: UIBarButtonItem! = {
        let button = UIBarButtonItem(barButtonHiddenItem: self.forwardButtonType, target: self, action: #selector(forwardButtonDidTap(_:)))
        return button
    }()
    
    private lazy var flexibleSpacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    private lazy var doneButton: UIBarButtonItem! = {
        let button = UIBarButtonItem(title: self.doneButtonTitle, style: .done, target: self, action: #selector(doneButtonDidtap(_:)))
        return button
    }()
    
    private var formItems: [FormItem] = []
    
    private var backButtonType: UIBarButtonHiddenItem = .prev
    private var forwardButtonType: UIBarButtonHiddenItem = .next
    
    public var direction: Direction = .upDown {
        didSet {
            switch direction {
            case .upDown:
                backButtonType = .up
                forwardButtonType = .down
            case .leftRight:
                backButtonType = .prev
                forwardButtonType = .next
            }
            backButton = nil
            forwardButton = nil
            updateItems()
        }
    }
    
    public var doneButtonTitle: String = "Done" {
        didSet {
            doneButton = nil
            updateItems()
        }
    }
    
    
    required convenience public init(inputs: [UITextInput]) {
        self.init(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 44.0)))
        self.formItems = inputs.map { input in
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
        
        updateItems()
        update(currentInput: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func update(currentInput: UITextInput?) {
        guard let currentInput = currentInput else {
            backButton.isEnabled = false
            forwardButton.isEnabled = false
            return
        }
        
        for (index, formItem) in formItems.enumerated() {
            guard let input = formItem.input else {
                continue
            }
            
            if input.isEqual(currentInput) {
                let isFirstForm = index == 0
                let isLastForm = index == (formItems.count - 1)
                backButton.isEnabled = !isFirstForm || formItem.previousInput != nil
                forwardButton.isEnabled = !isLastForm || formItem.nextInput != nil
                break
            }
        }
    }
    
    public func goBack() {
        if let currentFormItem = detectCurrentFormItem() {
            currentFormItem.input.flatMap(castToResponder)?.resignFirstResponder()
            currentFormItem.previousInput.flatMap(castToResponder)?.becomeFirstResponder()
        }
    }
    
    public func goForward() {
        if let currentFormItem = detectCurrentFormItem() {
            currentFormItem.input.flatMap(castToResponder)?.resignFirstResponder()
            currentFormItem.nextInput.flatMap(castToResponder)?.becomeFirstResponder()
        }
    }
    
    private func updateItems() {
        let buttonItems: [UIBarButtonItem] = [backButton, fixedSpacer, forwardButton, flexibleSpacer, doneButton]
        setItems(buttonItems, animated: false)
    }
    
    private func detectCurrentFormItem() -> FormItem? {
        return formItems.filter { $0.input.flatMap(castToResponder)?.isFirstResponder ?? false }.first
    }
    
    @objc private func backButtonDidTap(_: UIBarButtonItem) {
        goBack()
    }
    
    @objc private func forwardButtonDidTap(_: UIBarButtonItem) {
        goForward()
    }
    
    @objc private func doneButtonDidtap(_: UIBarButtonItem) {
        detectCurrentFormItem()?.input.flatMap(castToResponder)?.resignFirstResponder()
    }
}

private func castToResponder(_ value: Any) -> UIResponder? {
    return value as? UIResponder
}

