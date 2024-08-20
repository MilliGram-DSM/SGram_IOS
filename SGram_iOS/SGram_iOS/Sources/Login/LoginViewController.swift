import Foundation
import SnapKit
import Then
import UIKit
import Moya

class LoginViewController: UIViewController {
    let authService = AuthService()

    private let titleLabel = SGLoginTitleLabel(text: "로그인")
    private let idInputTF = SGLoginTextField(type: .id)
    private let pwInputTF = SGLoginTextField(type: .pw)
    
    private let loginbutton = SGLoginButton().then {
        $0.addTarget(self, action: #selector(loginButtontap), for: .touchUpInside)
    }
    
    
    private let signupButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(.blue, for: .normal)
        $0.addTarget(self, action: #selector(goSignup), for: .touchUpInside)
    }
    
    @objc func goSignup() {

        self.navigationController?.pushViewController(SignupViewController(), animated: true)
    }

    @objc func loginButtontap(){
        authService.login(
            accountId: idInputTF.textField.text!,
            password: pwInputTF.textField.text!
        ) { result in
            switch result {
            case let .success(token):
                print("Login successful, token: \(token)")
                self.navigationController?.pushViewController(MainViewController(), animated: true)
            case let .failure(error):
                print("Login failed: \(error)")
            }
        }

    }
    
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        loginbutton.buttonTitle = "로그인"
              
        view.backgroundColor = .white
        layout()
    }
    
    
    
    func layout() {
        [
            titleLabel,
            idInputTF,
            pwInputTF,
            loginbutton,
            signupButton
        ].forEach { view.addSubview($0) }
        
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
        
        signupButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(loginbutton.snp.bottom).offset(30)
        }
    }
}
