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
    
    static func removeToken() {
        accessToken = nil
    }
}

enum Header {
    case accessToken, tokenIsEmpty

    func header() -> [String : String]? {
        guard let token = Token.accessToken else {
            return ["Contect-Type" : "application/json"]
        }
        
        switch self {
        case .accessToken:
            return ["Authorization" : "Bearer " + token, "Contect-Type" : "application/json"]

        case .tokenIsEmpty:
            return ["Contect-Type" : "application/json"]
        }
    }
}
