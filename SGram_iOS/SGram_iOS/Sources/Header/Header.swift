import Moya
import Foundation

class AuthService {
    let provider = MoyaProvider<AuthAPI>(plugins: [MoyaLogginPlugin()])
    
    func login(
        accountId: String,
        password: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        provider.request(
            .login(
                accountId: accountId,
                password: password
            )
        ) { result in
            switch result {
            case let .success(response):
                if response.statusCode == 200 {
                    do {
                        let data = try JSONDecoder().decode(LoginModel.self, from: response.data)
                        print(data.accessToken)
                        UserDefaults.standard.set(data.accessToken, forKey: "Key")
                        print(UserDefaults.standard.set(data.accessToken, forKey: "Key"))
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
    
    func signup(
        account_id: String,
        password: String,
        phone: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        provider.request(
            .signup(
                accountId: account_id,
                password: password,
                phone: phone
            )
        ) { result in
            switch result {
            case let .success(response):
                completion(.success(()))

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
