<<<<<<< Updated upstream
=======
//import Foundation
//import Moya
//
//
//
//// 유효성 검사 함수
//func validateCredentials(accountId: String, password: String) -> Bool {
//    // account_id 유효성 검사
//    let accountIdRegex = "^[a-zA-Z]{1,20}$" // 영문자만 허용, 최대 20자
//    let accountIdPredicate = NSPredicate(format: "SELF MATCHES %@", accountIdRegex)
//
//    if !accountIdPredicate.evaluate(with: accountId) {
//        return false // 조건 불충족 시 false 반환
//    }
//
//    // password 유효성 검사
//    // 비밀번호는 빈 문자열이 아니어야 하며, 특수문자를 허용
//    if password.isEmpty {
//        return false // 조건 불충족 시 false 반환
//    }
//
//    return true // 모든 조건을 충족할 경우 true 반환
//}
//
//let provider = MoyaProvider<listService>()
//
//enum listService {
//    case signIn(userId: String, password: String)
//    case signUp(userId: String, password: String, phone: String)
//}
//
//extension listService: TargetType {
//    var baseURL: URL {
//        return URL(string: "https://api.example.com")!  // base URL
//    }
//    
//    var path: String {
//        switch self {
//        case .signIn:
//            return "/login"
//        case .signUp:
//            return "/join"
//        }
//    }
//    
//    var method: Moya.Method {
//        switch self {
//        case .signIn, .signUp:
//            return .post
//        }
//    }
//    
//    var task: Task {
//        switch self {
//        case .signIn(let userId, let password):
//            return .requestParameters(parameters: ["account_id": userId, "password": password], encoding: JSONEncoding.default)
//        case .signUp(let userId, let password, let phone):
//            return .requestParameters(parameters: ["account_id": userId, "password": password, "phone": phone], encoding: JSONEncoding.default)
//        }
//    }
//    
//    var headers: [String: String]? {
//        return Header.tokenIsEmpty.header()
//    }
//    
//    var validationType: ValidationType {
//        return .successCodes
//    }
//}
//
//// 로그인 요청 함수
//func signIn(accountId: String, password: String) {
//    guard validateCredentials(accountId: accountId, password: password) else {
//        print("유효하지 않은 계정 ID 또는 비밀번호입니다.")
//        return
//    }
//
//    provider.request(.signIn(userId: accountId, password: password)) { result in
//        switch result {
//        case .success(let response):
//            // 응답 처리
//            print("로그인 성공: \(response)")
//        case .failure(let error):
//            print("로그인 실패: \(error.localizedDescription)")
//        }
//    }
//}
//

// 프로그램의 시작점 정의
//@main
//struct MyApp {
//    static func main() {
//        
//        let exampleAccountId = "yong08"
//        let examplePassword = "12345678**"
//        signIn(accountId: exampleAccountId, password: examplePassword)
//    }
//}






>>>>>>> Stashed changes
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
            return header.tokenIsEmpty.header()
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

<<<<<<< Updated upstream

signInUser(userID: userID, password: password)
=======
// signInUser 함수 호출
//signInUser(userID: userID, password: password)
>>>>>>> Stashed changes
