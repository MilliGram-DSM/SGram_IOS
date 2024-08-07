import Foundation
import SnapKit
import Then
import UIKit

class LoginViewController: UIViewController {
    
    let  viewModel = ViewModel()
    
    private let titleLabel = SGLoginTitleLabel(text: "회원가입")
    private let idInputTF = SGLoginTextField(type: .id)
    private let pwInputTF = SGLoginTextField(type: .pw)
    
    private let loginbutton = SGLoginButton().then {
        $0.addTarget(nil, action: #selector(loginButtontap), for: .touchUpInside)

    }
    private let suggestionView = SGSuggestionView(message: "아직 가입안했냐?", buttonTitle: "회원가입")
       
    
    
    
    @objc func loginButtontap(){
        self.navigationController?.pushViewController(SignupViewController(), animated: true)
    }
    
  

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loginbutton.buttonTitle = "로그인"
      
        

        view.backgroundColor = .white
        layout()
    }
    
    
    func layout() {
        [titleLabel, idInputTF, pwInputTF, loginbutton, suggestionView].forEach { view.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(80.0)
            $0.width.equalToSuperview().inset(24.0)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(58.0)
        }
        
        idInputTF.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(38)
            $0.width.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(71)
        }
        
        pwInputTF.snp.makeConstraints {
            $0.top.equalTo(idInputTF.snp.bottom).offset(20.0)
            $0.width.equalToSuperview().inset(24.0)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(71.0)
        }
        
        loginbutton.snp.makeConstraints {
            $0.top.equalTo(pwInputTF.snp.bottom).offset(110)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(52)
        }
        
        suggestionView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(180)
        }
    }
}
