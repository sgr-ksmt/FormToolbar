//
//  ViewController.swift
//  Demo
//
//  Created by Suguru Kishimoto on 2/18/17.
//  Copyright © 2017 Suguru Kishimoto. All rights reserved.
//

import UIKit
import FormToolbar

class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    
    @IBOutlet private weak var form1: UITextField!
    @IBOutlet private weak var form2: UITextField!
    @IBOutlet private weak var form3: UITextView! {
        didSet {
            form3.layer.borderColor = UIColor.lightGray.cgColor
            form3.layer.borderWidth = 1.0 / UIScreen.main.scale
            form3.layer.cornerRadius = 4.0
        }
    }
    @IBOutlet private weak var form4: UITextField!
    @IBOutlet private weak var form5: UITextField!
    
    @IBOutlet private weak var control: UISegmentedControl!
    @IBOutlet private weak var doneButtonTitleForm: UITextField!

    private lazy var toolbar: FormToolbar = {
        return FormToolbar(inputs: self.inputs)
    }()
    
    private var inputs: [FormInput] {
        return [form1, form2, form3, form4, form5]
    }
    
    private weak var activeInput: FormInput?
    
    override func loadView() {
        super.loadView()
        form1.delegate = self
        form2.delegate = self
        form3.delegate = self
        form4.delegate = self
        form5.delegate = self
        
        doneButtonTitleForm.addTarget(self, action: #selector(doneButtonTitleFormDidChange(_:)), for: .editingChanged)
        control.addTarget(self, action: #selector(controlDidChange(_:)), for: .valueChanged)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        toolbar.updateToolbar(currentInput: textField)
        activeInput = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == doneButtonTitleForm {
            return false
        }
        toolbar.goForward()
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        toolbar.updateToolbar(currentInput: textView)
        activeInput = textView
    }
    
    @objc private func doneButtonTitleFormDidChange(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            toolbar.doneButtonTitle = text
        }
    }
    
    @objc func controlDidChange(_ control: UISegmentedControl) {
        toolbar.direction = control.selectedSegmentIndex == 0 ? .leftRight : .upDown
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 16.0, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
