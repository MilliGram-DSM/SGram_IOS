import UIKit
import SnapKit
import Then

class SignupViewController: UIViewController {
    
    private let titleLabel = SGLoginTitleLabel(text: "회원가입")
    private let idInputTF = SGLoginTextField(type: .id)
    private let pwInputTF = SGLoginTextField(type: .pw)
    private let suggestionView = SGSuggestionView(message: "벌써 가입했노?", buttonTitle: "그럼 로그인하자")
    private let nextbutton = SGLoginButton().then {
        $0.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        
    }
    
    let numberLabel2 = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.textAlignment = .right
    }
    
    @objc func nextButtonPressed(_ sender: UIButton) {
        navigationController?.pushViewController(UserInfoViewController(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        
        [titleLabel, idInputTF, pwInputTF, suggestionView, nextbutton, numberLabel2 ].forEach { view.addSubview($0) }
        
        nextbutton.buttonTitle = "정보입력하러가자~"
        self.view.backgroundColor = .white
        
        suggestionView.buttonTapped = {
            self.navigationController?.popViewController(animated: true)
        }
        
        layout()
    }
    
    func layout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(80.0)
            $0.width.equalToSuperview().inset(24.0)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(58.0)
        }
        
        idInputTF.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(38.0)
            $0.width.equalToSuperview().inset(24.0)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(71.0)
        }
        
        pwInputTF.snp.makeConstraints {
            $0.top.equalTo(idInputTF.snp.bottom).offset(20.0)
            $0.width.equalToSuperview().inset(24.0)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(71.0)
        }
        
        suggestionView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(350)
        }
        
        nextbutton.snp.makeConstraints {
            $0.top.equalTo(500)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(52)
        }
        
        numberLabel2.snp.makeConstraints {
            $0.top.equalToSuperview().inset(57.5)
            $0.right.equalToSuperview().inset(24)
            $0.left.equalToSuperview().inset(24) // 수정
        }
    }
    
}
