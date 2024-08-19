import UIKit
import SnapKit
import Then

class SignupViewController: UIViewController {
    
    private let titleLabel = SGLoginTitleLabel(text: "회원가입")
    
    private let idInputTF = SGLoginTextField(type: .id)
    
    private let pwInputTF = SGLoginTextField(type: .pw)
    
    private let telTF = SGLoginTextField(type: .tel)
    
    private let suggestionView = SGSuggestionView(message: "벌써 가입했다면?", buttonTitle: "로그인")
    
    private let nextbutton = SGLoginButton().then {
        $0.buttonTitle = "회원가입"
        $0.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
    }

    @objc func nextButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        self.navigationItem.hidesBackButton = true
        
        [titleLabel, idInputTF, pwInputTF, suggestionView, nextbutton, telTF].forEach { view.addSubview($0) }
        
        self.view.backgroundColor = .white
        
        suggestionView.buttonTapped = {
            self.navigationController?.popViewController(animated: true)
        }
        
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
        
        suggestionView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(telTF.snp.bottom).offset(20)
        }
        
        nextbutton.snp.makeConstraints {
            $0.top.equalTo(suggestionView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
    }
    
}
