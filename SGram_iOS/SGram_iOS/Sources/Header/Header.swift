
// @main 어트리뷰트를 사용하여 프로그램의 시작점 정의
@main
struct MainApp {
    static func main() {
        let exampleResponseData = """
        {
            "access_token": "Bearer eyJ0eXAiOiJhY2Nlc3MiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJqeWsxMDI5IiwiaWF0IjoxNjk2MDgxOTE4LCJleHAiOjE2OTYwODkxMTh9.NGn0ZjFwFB2Iy30Iej2QOQli_bj3A-aW-P_esZ8XU5k",
            "refresh_token": "Bearer eyJ0eXAiOiJhY2Nlc3MiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJqeWsxMDI5IiwiaWF0IjoxNjk2MDgxOTE4LCJleHAiOjE2OTYxNjgzMTh9.yF-I1Y8ZlAEYwmQBtPMLtvbhrfnlwjbCmr5hsCEkOa4"
        }
        """.data(using: .utf8)
        
        handleResponse(statusCode: 200, responseData: exampleResponseData)
    }
}



import Foundation

struct Token {
    static var _accessToken: String?
    static var accessToken: String? {
        get {
            _accessToken = UserDefaults.standard.string(forKey: "accessToken")
            return _accessToken
        }

        set(newToken) {
            UserDefaults.standard.set(newToken, forKey: "accessToken")
            UserDefaults.standard.synchronize()
            _accessToken = UserDefaults.standard.string(forKey: "accessToken")
        }
    }

    static var _refreshToken: String?
    static var refreshToken: String? {
        get {
            _refreshToken = UserDefaults.standard.string(forKey: "refreshToken")
            return _refreshToken
        }

        set(newRefreshToken) {
            UserDefaults.standard.set(newRefreshToken, forKey: "refreshToken")
            UserDefaults.standard.synchronize()
            _refreshToken = UserDefaults.standard.string(forKey: "refreshToken")
        }
    }
    
    static func removeToken() {
        accessToken = nil
        refreshToken = nil
    }
}

enum Header {
    case accessToken, tokenIsEmpty

    func header() -> [String: String]? {
        guard let token = Token.accessToken else {
            return ["Content-Type": "application/json"]
        }
        
        switch self {
        case .accessToken:
            return ["Authorization": "Bearer " + token, "Content-Type": "application/json"]
        case .tokenIsEmpty:
            return ["Content-Type": "application/json"]
        }
    }
}

// 네트워크 요청을 수행하는 함수
func makeNetworkRequest(completion: @escaping (Result<String, Error>) -> Void) {
    let url = URL(string: "https://api.example.com/endpoint")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = Header.accessToken.header()
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return
        }

        switch httpResponse.statusCode {
        case 200:
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let accessToken = json["access_token"] as? String {
                    Token.accessToken = accessToken
                }
                if let refreshToken = json["refresh_token"] as? String {
                    Token.refreshToken = refreshToken
                }
                completion(.success("Tokens saved successfully."))
            }
        case 201:
            completion(.success("Resource created."))
        case 204:
            completion(.success("No content."))
        case 400:
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Bad Request"])))
        case 401:
            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Unauthorized: Token issue."])))
        case 403:
            completion(.failure(NSError(domain: "", code: 403, userInfo: [NSLocalizedDescriptionKey: "Forbidden: Access denied."])))
        case 404:
            completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Not Found."])))
        case 409:
            completion(.failure(NSError(domain: "", code: 409, userInfo: [NSLocalizedDescriptionKey: "Conflict: Already exists."])))
        default:
            completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Unexpected error."])))
        }
    }
    
    task.resume()
}

// 사용 예시
makeNetworkRequest { result in
    switch result {
    case .success(let message):
        print(message)
    case .failure(let error):
        print("Error: \(error.localizedDescription)")
    }
}
