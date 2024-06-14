import UIKit

protocol OneTimeCodeDelegate: AnyObject {
    func codeFilled()
    func codeCleared()
}

class OneTimeCodeViewController: UIViewController, UITextFieldDelegate {
    
    weak var delegate: OneTimeCodeDelegate?
    
    private var codeTextField1: MyTextField!
    private var codeTextField2: MyTextField!
    private var codeTextField3: MyTextField!
    private var codeTextField4: MyTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // Initialize text fields
        codeTextField1 = createCodeTextField()
        codeTextField2 = createCodeTextField()
        codeTextField3 = createCodeTextField()
        codeTextField4 = createCodeTextField()
        
        // Set delegates
        codeTextField1.delegate = self
        codeTextField2.delegate = self
        codeTextField3.delegate = self
        codeTextField4.delegate = self
        
        codeTextField1.myDelegate = self
        codeTextField2.myDelegate = self
        codeTextField3.myDelegate = self
        codeTextField4.myDelegate = self
        
        // Disable all except first
        codeTextField2.isEnabled = false
        codeTextField3.isEnabled = false
        codeTextField4.isEnabled = false

        // Add text fields to the view
        let stackView = UIStackView(arrangedSubviews: [codeTextField1, codeTextField2, codeTextField3, codeTextField4])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 17
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        // Add constraints
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor),
            codeTextField1.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        codeTextField1.becomeFirstResponder()
    }
    
    // Create a text field with the necessary properties
    private func createCodeTextField() -> MyTextField {
        let textField = MyTextField()
        textField.backgroundColor = .neobisExtralightGray
        textField.font = AppFont.font(type: .Regular, size: 32)
        textField.textColor = .neobisDarkGray
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        textField.layer.borderColor = UIColor.neobisRed.cgColor
        textField.layer.cornerRadius = 16
        textField.autocorrectionType = .no
        textField.textContentType = .oneTimeCode // To enable SMS autofill
        return textField
    }

    // Handle the text field's behavior when text is changed
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.count == 1 {
            guard [0,1,2,3,4,5,6,7,8,9].contains(Int(string)) else { return false }
            textField.text = string
            moveToNextTextField(from: textField)
            checkEmptyFields()
            return false
        } else if string.count == 0 {
            textField.text = ""
            moveToPreviousTextField(from: textField)
            delegate?.codeCleared()
            return false
        }
        return false
    }

    // Move to the next text field
    private func moveToNextTextField(from textField: UITextField) {
        switch textField {
        case codeTextField1:
            codeTextField1.isEnabled = false
            codeTextField2.isEnabled = true
            codeTextField2.becomeFirstResponder()
        case codeTextField2:
            codeTextField2.isEnabled = false
            codeTextField3.isEnabled = true
            codeTextField3.becomeFirstResponder()
        case codeTextField3:
            codeTextField3.isEnabled = false
            codeTextField4.isEnabled = true
            codeTextField4.becomeFirstResponder()
        case codeTextField4:
            codeTextField4.resignFirstResponder()
        default:
            break
        }
    }

    // Move to the previous text field
    private func moveToPreviousTextField(from textField: UITextField) {
        switch textField {
        case codeTextField4:
            codeTextField4.isEnabled = false
            codeTextField3.isEnabled = true
            codeTextField3.becomeFirstResponder()
        case codeTextField3:
            codeTextField3.isEnabled = false
            codeTextField2.isEnabled = true
            codeTextField2.becomeFirstResponder()
        case codeTextField2:
            codeTextField2.isEnabled = false
            codeTextField1.isEnabled = true
            codeTextField1.becomeFirstResponder()
        case codeTextField1:
            codeTextField1.resignFirstResponder()
        default:
            break
        }
    }
    
    private func checkEmptyFields() {
        if codeTextField1.text != "",
           codeTextField2.text != "",
           codeTextField3.text != "",
           codeTextField4.text != "" { delegate?.codeFilled() }
    }
    
    func getCode() -> String {
        let dig1 = codeTextField1.text ?? ""
        let dig2 = codeTextField2.text ?? ""
        let dig3 = codeTextField3.text ?? ""
        let dig4 = codeTextField4.text ?? ""
        
        return dig1+dig2+dig3+dig4
    }
    
    func changeBorderColor(isAlert: Bool) {
        if isAlert {
            codeTextField1.layer.borderWidth = 1
            codeTextField2.layer.borderWidth = 1
            codeTextField3.layer.borderWidth = 1
            codeTextField4.layer.borderWidth = 1
        } else {
            codeTextField1.layer.borderWidth = 0
            codeTextField2.layer.borderWidth = 0
            codeTextField3.layer.borderWidth = 0
            codeTextField4.layer.borderWidth = 0
        }
    }
    
}

protocol MyTextFieldDelegate: AnyObject {
    func textFieldDidDelete(from textField: UITextField)
}

class MyTextField: UITextField {

    weak var myDelegate: MyTextFieldDelegate?

    override func deleteBackward() {
        super.deleteBackward()
        if let text = self.text, text == "" {
            myDelegate?.textFieldDidDelete(from: self)
        }
    }

}

extension OneTimeCodeViewController: MyTextFieldDelegate {
    func textFieldDidDelete(from textField: UITextField) {
        moveToPreviousTextField(from: textField)
    }
}
