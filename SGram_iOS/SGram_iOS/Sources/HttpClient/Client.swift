import Moya
import Foundation

enum AuthAPI {
    case login(accountId: String, password: String)
    case signup(accountId: String, password: String, phone: String)
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://172.20.10.3:8080")!
    }

    var path: String {
        switch self {
        case .login:
            return "/login"
        case .signup:
            return "/join"
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
        case let .login(accountId, password):
            return .requestParameters(
                parameters: [
                    "account_id": accountId,
                    "password": password
                ],
                encoding: JSONEncoding.default
            )

        case let .signup(accountId, password, phone):
            return .requestParameters(
                parameters: [
                    "account_id": accountId,
                    "password": password,
                    "phone": phone
                ],
                encoding: JSONEncoding.default
            )
        }
    }

    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }

    var validationType: ValidationType {
        return .successCodes
    }
}
