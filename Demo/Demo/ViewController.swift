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

    lazy var toolbar: FormToolbar = {
        return FormToolbar(inputs: self.inputs)
    }()
    
    var inputs: [FormInput] {
        return [form1, form2, form3, form4, form5]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form1.delegate = self
        form2.delegate = self
        form3.delegate = self
        form4.delegate = self
        form5.delegate = self
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

