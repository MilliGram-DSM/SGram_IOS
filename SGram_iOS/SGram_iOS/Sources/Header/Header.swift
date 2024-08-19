import Moya
import Foundation

class AuthService {
    let provider = MoyaProvider<AuthAPI>()
    
    func login(
        accountId: String,
        password: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        provider.request(.login(accountId: accountId, password: password)) { result in
            switch result {
            case let .success(response):
                // 로그인 성공 처리
                if response.statusCode == 200 {
                    do {
                        //asdfadsf
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(NSError(domain: "", code: response.statusCode, userInfo: nil)))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func signup(account_id: String, password: String, phone: String, completion: @escaping (Result<String, Error>) -> Void) {
        provider.request(.signup(accountId: account_id, password: password, phone: phone)) { result in
            switch result {
            case let .success(response):
                // 회원가입 성공 처리
                if response.statusCode == 201 {
                    do {
                        if let json = try response.mapJSON() as? [String: Any],
                           let token = json["token"] as? String { // 서버에서 "token"을 반환한다고 가정
                            // 토큰을 저장 (UserDefaults 등을 사용)
                            UserDefaults.standard.set(token, forKey: "authToken")
                            completion(.success(token))
                        } else {
                            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(NSError(domain: "", code: response.statusCode, userInfo: nil)))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
