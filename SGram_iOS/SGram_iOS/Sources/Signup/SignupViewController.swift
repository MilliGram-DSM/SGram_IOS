import UIKit
import SnapKit
import Then

class SignupViewController: UIViewController {
    let authService = AuthService()
    
    private let titleLabel = SGLoginTitleLabel(text: "회원가입")
    
    private let idInputTF = SGLoginTextField(type: .id)
    
    private let pwInputTF = SGLoginTextField(type: .pw)
    
    private let telTF = SGLoginTextField(type: .tel)
    
//    private let suggestionView = SGSuggestionView(message: "벌써 가입했다면?", buttonTitle: "로그인")
    private let suggestionButton = UIButton().then {
        $0.setTitle("로그인 GOGO", for: .normal)
        $0.addTarget(self, action: #selector(suggestionButtonDidTap), for: .touchUpInside)
        $0.setTitleColor(.blue, for: .normal)
    }
    
    private let nextbutton = SGLoginButton().then {
        $0.buttonTitle = "회원가입"
        $0.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
    }

    @objc func nextButtonPressed(_ sender: UIButton) {
        authService.signup(
            account_id: idInputTF.textField.text!,
            password: pwInputTF.textField.text!,
            phone: telTF.textField.text!
        ) { result in
            switch result {
            case .success(let success):
                self.navigationController?.popViewController(animated: true)
            case .failure(let failure):
                print(failure)
                return
            }
        }
    }
    
    @objc func suggestionButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        self.navigationItem.hidesBackButton = true
        
        [titleLabel, idInputTF, pwInputTF, suggestionButton, nextbutton, telTF].forEach { view.addSubview($0) }
        
        self.view.backgroundColor = .white
        
        
        layout()
    }
    
    func layout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(80)
            $0.width.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
        }
        
        idInputTF.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.width.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
        }
        
        pwInputTF.snp.makeConstraints {
            $0.top.equalTo(idInputTF.snp.bottom).offset(20)
            $0.width.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
        }
        
        
        telTF.snp.makeConstraints {
            $0.top.equalTo(pwInputTF.snp.bottom).offset(20)
            $0.width.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
        }
        
        suggestionButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(telTF.snp.bottom).offset(20)
        }
        
        nextbutton.snp.makeConstraints {
            $0.top.equalTo(suggestionButton.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
    }
    
}
