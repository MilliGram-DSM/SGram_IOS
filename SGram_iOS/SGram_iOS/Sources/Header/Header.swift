<<<<<<< Updated upstream

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



=======
>>>>>>> Stashed changes
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

    func header() -> [String : String]? {
        guard let token = Token.accessToken else {
            return ["Content-Type" : "application/json"]
        }
        
        switch self {
        case .accessToken:
            return ["Authorization" : "Bearer " + token, "Content-Type" : "application/json"]
        case .tokenIsEmpty:
            return ["Content-Type" : "application/json"]
        }
    }
}

// API 응답 처리 함수
func handleResponse(statusCode: Int, responseData: Data?) {
    switch statusCode {
    case 200:
        guard let data = responseData else { return }
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let accessToken = json["access_token"] as? String,
               let refreshToken = json["refresh_token"] as? String {
                Token.accessToken = accessToken
                Token.refreshToken = refreshToken
                print("Access Token: \(accessToken)")
                print("Refresh Token: \(refreshToken)")
            }
        } catch {
            print("JSON 파싱 실패: \(error.localizedDescription)")
        }
    case 201:
        print("201 Created")
    case 204:
        print("204 No Content")
    case 400:
        print("400 Bad Request: 요청이 잘못되었습니다.")
    case 401:
        print("401 Unauthorized: 토큰에 문제가 존재합니다.")
    case 403:
        print("403 Forbidden: 접근 권한이 없습니다.")
    case 404:
        print("404 Not Found: 찾을 수 없습니다.")
    case 409:
        print("409 Conflict: 이미 존재하는 리소스입니다.")
    default:
        print("알 수 없는 상태 코드: \(statusCode)")
    }
}

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

struct token {
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

enum header {
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
//makeNetworkRequest { result in
//    switch result {
//    case .success(let message):
//        print(message)
//    case .failure(let error):
//        print("Error: \(error.localizedDescription)")
//    }
//}
