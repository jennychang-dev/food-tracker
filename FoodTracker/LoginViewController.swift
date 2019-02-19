import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // welcome back if I have your details
        
        if let username = UserDefaults.standard.object(forKey: "username") {
            
            welcomeLabel.text = "welcome back \(username)"
            let launchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "navigation") as? UINavigationController
            
            present(launchVC!, animated: true, completion: nil)
            
        } else {

            // else load sign up page
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signup") as? SignUpViewController
            present(viewController!, animated: true, completion: nil)
        
        }
    }
}
