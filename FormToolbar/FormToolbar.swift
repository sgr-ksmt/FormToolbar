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
            self.formItems.forEach { formItem in
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
            self.backButton.isEnabled = false
            self.forwardButton.isEnabled = false
            return
        }
        
        for (index, formItem) in self.formItems.enumerated() {
            guard let input = formItem.input else {
                continue
            }
            
            if input.isEqual(currentInput) {
                let isFirstForm = index == 0
                let isLastForm = index == (self.formItems.count - 1)
                self.backButton.isEnabled = !isFirstForm || formItem.previousInput != nil
                self.forwardButton.isEnabled = !isLastForm || formItem.nextInput != nil
                break
            }
        }
    }
    
    private func updateItems() {
        let buttonItems: [UIBarButtonItem] = [
            self.backButton, self.fixedSpacer, self.forwardButton, self.flexibleSpacer, self.doneButton
        ]
        self.setItems(buttonItems, animated: false)
    }
    
    private func detectCurrentFormItem() -> FormItem? {
        return self.formItems.filter { ($0.input as? UIResponder)?.isFirstResponder ?? false }.first
    }
    
    @objc private func backButtonDidTap(_: UIBarButtonItem) {
        if let currentFormItem = self.detectCurrentFormItem() {
            (currentFormItem.input as? UIResponder)?.resignFirstResponder()
            (currentFormItem.previousInput as? UIResponder)?.becomeFirstResponder()
        }
    }
    
    @objc private func forwardButtonDidTap(_: UIBarButtonItem) {
        if let currentFormItem = self.detectCurrentFormItem() {
            (currentFormItem.input as? UIResponder)?.resignFirstResponder()
            (currentFormItem.nextInput as? UIResponder)?.becomeFirstResponder()
        }
    }
    
    @objc private func doneButtonDidtap(_: UIBarButtonItem) {
        if let currentFormItem = self.detectCurrentFormItem() {
            (currentFormItem.input as? UIResponder)?.resignFirstResponder()
        }
    }
    
}
