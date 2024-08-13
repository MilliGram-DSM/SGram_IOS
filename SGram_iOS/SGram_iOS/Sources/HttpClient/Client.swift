import Moya
import Foundation

enum AuthAPI {
    case login(email: String, password: String)
    case signup(email: String, password: String)
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.example.com")!
    }

    var path: String {
        switch self {
        case .login:
            return "/login"
        case .signup:
            return "/signup"
        }
    }

    var method: Moya.Method {
        switch self {
        case .login, .signup:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .login(let email, let password), .signup(let email, let password):
            let params: [String: Any] = ["email": email, "password": password]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }

    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }

    var validationType: ValidationType {
        return .successCodes
    }
}
