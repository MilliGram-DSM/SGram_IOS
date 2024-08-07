import UIKit
import SnapKit
import Then

enum TFType {
    case id
    case name
    case pw
    case tel
    case custom(title: String, placeholder: String)
    
    var text: String {
        switch self {
        case .id:
            return "아이디"
        case .name:
            return "닉네임"
        case .pw:
            return "비밀번호"
        case .tel:
            return "전화번호"
        case .custom(let title, let placeholder):
            return title + "," + placeholder
        }
    }
}

class SGLoginTextField: UIView {
    
    var iconClick = true
    
    let titleLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 16)
    }
    
    let backView = UIView().then {
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 8.0
    }
    
    let textField = UITextField().then {
        $0.font = .systemFont(ofSize: 16)
        $0.isSecureTextEntry = false
        $0.keyboardType = .default
        
    }
    

    
    init(type: TFType) {
        super.init(frame: .zero)
        
        titleLabel.text = type.text
        textField.attributedPlaceholder = NSAttributedString(string: type.text, attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        
        switch type {
        case .id:
            break
        case .name:
            break
        case .pw:
            textField.isSecureTextEntry = true
          
            textField.rightViewMode = .always
        case .tel:
            textField.keyboardType = .numberPad
        case .custom:
            let texts = type.text.components(separatedBy: ",")
            titleLabel.text = texts[0]
            textField.attributedPlaceholder = NSAttributedString(string: texts[1], attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        }
        
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        [titleLabel, backView].forEach { self.addSubview($0) }
        backView.addSubview(textField)
        
        titleLabel.snp.makeConstraints {
            $0.top.width.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(19.0)
        }
        
        backView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8.0)
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        textField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12.0)
            $0.width.equalToSuperview().inset(12)
            $0.centerX.equalToSuperview()
        }
    }
    
    @objc private func togglePasswordVisibility() {
        if iconClick {
            textField.isSecureTextEntry = false
        } else {
            textField.isSecureTextEntry = true
        }
        iconClick = !iconClick
    }
    
    public func currentText() -> String {
        return textField.text ?? ""
    }
}
