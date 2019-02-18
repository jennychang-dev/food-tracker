import Foundation

var request: URLRequest!

func compileURLComponents(path: String) {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "cloud-tracker.herokuapp.com"
    urlComponents.path = "/signup"
    guard let url = urlComponents.url else {
        fatalError("Could not create URL from components")
    }
    
}

func getRequest() {
    
    
}

func postRequest() {
    
}
