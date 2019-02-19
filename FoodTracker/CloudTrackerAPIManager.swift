import Foundation

class CloudTrackerManager {
    
    var request: URLRequest!
    var totalMeals = [[String: Any]]()
    var meals = [Meal]()
    
    //////////////////////////////////////////////////////////
    //    COMPILE URL
    ////////////////////////////////////////////////////////
    
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
    
    //////////////////////////////////////////////////////////
    //    PERFORM SIGN UP REQUEST
    ////////////////////////////////////////////////////////
    
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
                print("\(String(describing: responseError))")
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
    
    //////////////////////////////////////////////////////////
    //    POST THE MEAL TO CLOUD TRACKER
    ////////////////////////////////////////////////////////
    
    func postMeal(meal: Meal) {
        
        let url = compileURLComponents(path: "/users/me/meals")
        request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        var headers = request.allHTTPHeaderFields ?? [:]
        headers = ["token":"C4BaoGmKEiFumUP9ysoDx5cC", "Content-Type": "application/json"]
        request.allHTTPHeaderFields = headers
        
        let bodyData: [String: Any] =
            [
                "calories": meal.calories,
                "description": meal.details,
                "title": meal.name,
                "rating": meal.rating
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
                print("\(String(describing: responseError))")
                return
            }
            
            
            if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
                print("response: ", utf8Representation)
            }
        }
        
        task.resume()
        print("ATTEMPTING TO PERFORM TASK!!!!")
        
    }
    
    //////////////////////////////////////////////////////////
    //    FETCH ALL MEALS
    ////////////////////////////////////////////////////////
    
    func fetchAllMeals(completion: @escaping (_ result: String) -> Void) {
        
        let url = compileURLComponents(path: "/users/me/meals")
        request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        var headers = request.allHTTPHeaderFields ?? [:]
        headers = ["token":"C4BaoGmKEiFumUP9ysoDx5cC", "Content-Type": "application/json"]
        request.allHTTPHeaderFields = headers
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                print("\(String(describing: responseError))")
                return
            }
            
            if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
                
                print("response: ", utf8Representation)
            
                guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]] else {
                print("data returned is not json")
                    return
                }
                
                for meal in json {
                    
                    let newMeal = Meal(name: meal["title"] as! String, photo: nil, rating: meal["rating"] as! Int, calories: meal["calories"] as! Int, details: meal["description"] as! String)
                    self.meals.append(newMeal!)
                    
                }
                completion("finished now print...")

            }
            print("TOTAL NUMBER OF MEALS IS \(self.meals.count)")
        }
        
        task.resume()
        print("ATTEMPTING TO PERFORM TASK!!!!")
        
        
    }
    
    }

//func takeMyDataAndReturnMeals(json: [[String: Any]]) {
//
//    var totalMeals
//
//    for meal in json {
//        print(meal["calories"] ?? 0)
//    }
//
//
//
//}

//    func encodeData(bodyData: [String: String]) {
//        let encoder = JSONEncoder()
//
//        do {
//            let jsonData = try encoder.encode(bodyData)
//            request.httpBody = jsonData
//            print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
//        } catch {
//            print("\(error)")
//        }
//
//    }
    

