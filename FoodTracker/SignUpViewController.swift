import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        let returnValue = UserDefaults.standard.string(forKey: "username")
//        print(returnValue)
//    }

    @IBAction func submitLogin(_ sender: Any) {
        
        if usernameTextField.text != "" && passwordTextField.text != "" {
            
            signUp(username: usernameTextField.text!, password: passwordTextField.text!)
        }
    }
    
    func signUp(username: String, password: String) {
        
        // create the url
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "cloud-tracker.herokuapp.com"
        urlComponents.path = "/signup"
        guard let url = urlComponents.url else {
            fatalError("Could not create URL from components")
        }
        
        // specify request as being a POST method
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers

        let bodyData = [
            "username": "\(username)",
            "password": "\(password)"
        ]
        
        let encoder = JSONEncoder()
        
        do {
            let jsonData = try encoder.encode(bodyData)
            request.httpBody = jsonData
            print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
        } catch {
            print("\(error)")
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                print("\(responseError)")
                return
            }
            
            // APIs usually respond with the data you just sent in your POST request
            if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
                print("response: ", utf8Representation)
                
                guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String,Any> else {
                    print("data returned is not json")
                    return
                }
                
                if let token = json["token"] {
                    print(token)
                    
                    UserDefaults.standard.set(username, forKey: "username")
                    UserDefaults.standard.set(password, forKey: "password")
                    UserDefaults.standard.set(token, forKey: "token")
                }
                
            }
        }
        
        task.resume()
    
        
    }
    
    

}
