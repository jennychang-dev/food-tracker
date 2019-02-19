import Foundation

class CloudTrackerManager {
    
    var request: URLRequest!
    
    func compileURLComponents(path: String) -> URL {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "cloud-tracker.herokuapp.com"
        urlComponents.path = path
        
        
        guard let url = urlComponents.url else {
            fatalError("could not create url from components")
        }
        return url
        
    }
    
    func signUpRequest(username: String, password: String) {
        
        let url = compileURLComponents(path: "/signup")
        request = URLRequest(url: url)
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
    
    func login() {
        
    }

func postMeal() {
    
    let url = compileURLComponents(path: "/users/me/meals")
    request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    var headers = request.allHTTPHeaderFields ?? [:]
    headers = ["token":"C4BaoGmKEiFumUP9ysoDx5cC", "Content-Type": "application/json"]
    request.allHTTPHeaderFields = headers
    
    let bodyData: [String: Any] =
         [
            "calories": 500,
            "description": "funny",
            "title": "halloooo",
            "rating": 5
            ]

    
    guard let postJSON = try? JSONSerialization.data(withJSONObject: bodyData, options: []) else {
        print("could not serialize json")
        return
    }
    
    request.httpBody = postJSON
    
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    let task = session.dataTask(with: request) { (responseData, response, responseError) in
        guard responseError == nil else {
            print("\(responseError)")
            return
        }
        

        if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
            print("response: ", utf8Representation)

        }
    }
    
    task.resume()
    print("ATTEMPTING TO PERFORM TASK!!!!")
    
}

func encodeData(bodyData: [String: String]) {
    let encoder = JSONEncoder()
    
    do {
        let jsonData = try encoder.encode(bodyData)
        request.httpBody = jsonData
        print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
    } catch {
        print("\(error)")
    }
    
}



}
