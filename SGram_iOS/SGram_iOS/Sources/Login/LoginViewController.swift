import Foundation
import SnapKit
import Then
import UIKit
import Moya

class LoginViewController: UIViewController {
    
    
    private let provider = MoyaProvider<AuthAPI>()

    
    
    private let titleLabel = SGLoginTitleLabel(text: "로그인")
    private let idInputTF = SGLoginTextField(type: .id)
    private let pwInputTF = SGLoginTextField(type: .pw)
    
    private let loginbutton = SGLoginButton().then {
        $0.addTarget(nil, action: #selector(loginButtontap), for: .touchUpInside)

    }
    private let suggestionView = SGSuggestionView(message: "회원가입을 안했다면?", buttonTitle: "회원가입")
    
    
    private let SignupButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(.blue, for: .normal)
        $0.addTarget(self, action: #selector(goSignup), for: .touchUpInside)
    }
    
    @objc func goSignup() {
        self.navigationController?.pushViewController(SignupViewController(), animated: true)
    }
    
   


    @objc func loginButtontap(){
        self.navigationController?.pushViewController(MainViewController(), animated: true)
    }
    
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        loginbutton.buttonTitle = "로그인"
        
        func touchLoginButton(){
            guard let userId = (idInputTF as? UITextField)?.text, !userId.isEmpty else { return }
            guard let userPw = (pwInputTF as? UITextField)?.text, !userPw.isEmpty else { return }
           
            provider.request(.signIn(userId: userId, password: userPw)) { res in
                   switch res {
                   case .success(let result):
                       switch result.statusCode {
                       case 200:
                           let decoder = JSONDecoder()
                           if let data = try? decoder.decode(LoginViewModel.self, from: result.data) {
                               Token.accessToken = data.accessToken
                               DispatchQueue.main.async {
                                   self.dismiss(animated: true)
                               }
                           } else {
                               print("Login: decoder error")
                           }
                       default:
                           print("Login: status \(result.statusCode)")
                       }
                   case .failure(let err):
                       print("Login respons fail: \(err.localizedDescription)")
                   }
               }
           }
        
        
        view.backgroundColor = .white
        layout()
    }
    
    
    
    func layout() {
        [titleLabel, idInputTF, pwInputTF, loginbutton, SignupButton].forEach { view.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(80)
            $0.width.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(58)
        }
        
        idInputTF.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(38)
            $0.width.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(71)
        }
        
        pwInputTF.snp.makeConstraints {
            $0.top.equalTo(idInputTF.snp.bottom).offset(20)
            $0.width.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(71)
        }
        
        loginbutton.snp.makeConstraints {
            $0.top.equalTo(pwInputTF.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(52)
        }
        
        SignupButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(loginbutton.snp.bottom).offset(30)
        }
        
//        suggestionView.snp.makeConstraints {
//            $0.centerX.equalToSuperview()
//            $0.bottom.equalToSuperview().inset(180)
//        }
    }
}
