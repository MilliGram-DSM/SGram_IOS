import UIKit
import SnapKit
import Then

class SGSuggestionView: UIView {
    
    public var buttonTapped: (() -> Void)?
    
    private let messageLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .black
    }
    
    private let moveButton = UIButton(type: .system).then {
        $0.setTitleColor(.blue, for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
        $0.addTarget(SGSuggestionView.self, action: #selector(nextButtonPressed), for: .touchUpInside)
    }
    
    
    init(message: String, buttonTitle: String) {
        super.init(frame: .zero)
        
        messageLabel.text = message
        moveButton.setTitle(buttonTitle, for: .normal)
        
        [messageLabel, moveButton].forEach { addSubview($0) }
    }
    
    @objc func nextButtonPressed() {
        buttonTapped?()
//        navigationController?.pushViewController(SignupViewController, animated: true)
//        print("네이스")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        messageLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.left.equalToSuperview()
        }
        moveButton.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.left.equalTo(messageLabel.snp.right).offset(4)
            $0.right.equalToSuperview()
        }
    }
    
    public func setButtonTappedAction(buttonTapped: @escaping () -> Void) {
        self.buttonTapped = buttonTapped
    }
}
