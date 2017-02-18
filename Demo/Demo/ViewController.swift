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
    
    @IBOutlet private weak var form1: UITextField!
    @IBOutlet private weak var form2: UITextField!
    @IBOutlet private weak var form3: UITextView!
    @IBOutlet private weak var form4: UITextField!
    @IBOutlet private weak var form5: UITextField!
    
    @IBOutlet private weak var control: UISegmentedControl!
    @IBOutlet private weak var doneButtonTitleForm: UITextField!

    lazy var toolbar: FormToolbar = {
        FormToolbar(inputs: self.inputs)
    }()
    
    var inputs: [FormInput] {
        return [form1, form2, form3, form4, form5]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        toolbar.update(currentInput: textField)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        toolbar.update(currentInput: textView)
    }
}

