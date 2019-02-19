import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func submitLogin(_ sender: Any) {
        
        if usernameTextField.text != "" && passwordTextField.text != "" {
            
            signUp(username: usernameTextField.text!, password: passwordTextField.text!)
        }
    }
    
    func signUp(username: String, password: String) {
        
        
        let ctm = CloudTrackerManager()
        ctm.signUpRequest(username: username, password: password)
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "navigation") as? UINavigationController
        present(viewController!, animated: true, completion: nil)
    }
    
    
}
