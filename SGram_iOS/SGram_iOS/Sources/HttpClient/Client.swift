import Foundation
import Moya

let MY = MoyaProvider<listService>()

// 요청 본문을 위한 구조체 정의
struct SignInRequest: Encodable {
    let account_id: String
    let password: String
}

struct SignUpRequest: Encodable {
    let userId: String
    let password: String
    let nickName: String
}

enum listService {
    case signIn(userID: String, password: String)
    case signUp(userID: String, password: String, nickname: String)
}

extension listService: TargetType {
    var baseURL: URL {
        return URL(string: "http://192.168.137.164:8087")!
    }

    var path: String {
        switch self {
        case .signIn:
            return "/auth/signin"
        case .signUp:
            return "/auth/signup"
        }
    }

    var method: Moya.Method {
        switch self {
        case .signIn, .signUp:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .signIn(let userID, let password):
            let requestBody = SignInRequest(account_id: userID, password: password)
            return .requestJSONEncodable(requestBody)
        case .signUp(let userID, let password, let nickname):
            let requestBody = SignUpRequest(userId: userID, password: password, nickName: nickname)
            return .requestJSONEncodable(requestBody)
        }
    }

    var headers: [String: String]? {
        switch self {
        case .signIn, .signUp:
            return Header.tokenIsEmpty.header()
        }
    }
}


func isValidCredentials(accountID: String, password: String) -> Bool {
    let accountIDRegex = "^[a-zA-Z]{1,20}$"
    let passwordRegex = "^(?=.*[!@#$%^&*])[A-Za-z\\d!@#$%^&*]{8,}$"

    let accountIDTest = NSPredicate(format: "SELF MATCHES %@", accountIDRegex)
    let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)

    return accountIDTest.evaluate(with: accountID) && passwordTest.evaluate(with: password)
}


func signInUser(userID: String, password: String) {
    if isValidCredentials(accountID: userID, password: password) {
        MY.request(.signIn(userID: userID, password: password)) { result in
            switch result {
            case .success(let response):
                
                print("Response: \(response)")
            case .failure(let error):
                
                print("Error: \(error)")
            }
        }
    } else {
        print("Invalid credentials.")
    }
}


let userID = "yong08"
let password = "12345678**"


signInUser(userID: userID, password: password)
