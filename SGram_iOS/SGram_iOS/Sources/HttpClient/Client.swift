import Moya
import Foundation

enum AuthAPI {
    case login(account_id: String, password: String)
    case signup(account_id: String, password: String, phone: String)
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
        case .login(let account_id, let password):
            let params: [String: Any] = ["email": account_id, "password": password]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .signup(let account_id, let password, let phone):
            let params: [String: Any] = ["email": account_id, "password": password, "phone": phone]
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
