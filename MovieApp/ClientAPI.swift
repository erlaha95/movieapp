
import Foundation

class ClientAPI {
    
    private let basePath = "https://api.themoviedb.org/3/"
    private let apiKey: String? = "02da584cad2ae31b564d940582770598"
    
    func getAllPopularMovies(completion: @escaping (_ success: Bool, _ message: String?) -> ()) {
        get(request: clientURLRequest(path: "movie/popular")) { (success, object) in
            
        }
    }
    
    func login(email: String, password: String, completion: @escaping (_ success: Bool, _ message: String?) -> ()) {
        let loginObject = ["email": email, "password": password]
        
        post(request: clientURLRequest(path: "auth/local", params: loginObject as Dictionary<String, AnyObject>)) { (success, object) -> () in
            
            DispatchQueue.main.async {
                if success {
                    completion(true, nil)
                } else {
                    var message = "there was an error"
                    if let object = object, let passedMessage = object["message"] as? String {
                        message = passedMessage
                    }
                    completion(true, message)
                }
            }
        }
    }
    
    // MARK: private composition methods
    
    private func post(request: NSMutableURLRequest, completion: @escaping(_ success: Bool, _ object: AnyObject?) -> ()) {
        dataTask(request, method: "POST", completion: completion)
    }
    
    private func put(request: NSMutableURLRequest, completion: @escaping(_ success: Bool, _ object: AnyObject?) -> ()) {
        
        dataTask(request, method: "PUT", completion: completion)
    }
    
    private func get(request: NSMutableURLRequest, completion: @escaping(_ success: Bool, _ object: AnyObject?) -> ()) {
        dataTask(request, method: "GET", completion: completion)
    }
    
    private func dataTask(_ request: NSMutableURLRequest, method: String, completion: @escaping(_ success: Bool, _ object: AnyObject?) -> ()) {
        request.httpMethod = method
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: request as URLRequest) { (data, response, error) in
            if let data = data {
                
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                    completion(true, json as AnyObject)
                } else {
                    completion(false, json as AnyObject)
                }
            }
            }.resume()
    }
    
    private func clientURLRequest(path: String, params: Dictionary<String, AnyObject>? = nil) -> NSMutableURLRequest {
        var fullPath = basePath + path
        
        
        
        if let apiKey = apiKey, fullPath.contains("?") {
            fullPath += "&api_key=\(apiKey)"
        } else if let apiKey = apiKey {
            fullPath += "?api_key=\(apiKey)"
        }
        
        let request = NSMutableURLRequest(url: URL(string: fullPath)!)
        
        if let params = params {
            var paramString = ""
            for (key, value) in params {
                
                let escapedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                let escapedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                paramString += "\(escapedKey)=\(escapedValue)&"
            }
            
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = paramString.data(using: .utf8)
        }
        
        return request
    }
}
