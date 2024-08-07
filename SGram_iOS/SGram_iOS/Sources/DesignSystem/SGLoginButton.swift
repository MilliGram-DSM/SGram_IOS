import UIKit
import SnapKit
import Then

class SGLoginButton: UIButton {
    
    
    
    var buttonTitle: String {
        get { buttonTitleLabel.text ?? "" }
        set { buttonTitleLabel.text = newValue }
    }
    
    private let backView = UIView().then {
        $0.backgroundColor = .clear
        $0.isUserInteractionEnabled = false
    }
    private let buttonTitleLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 15)
        $0.textColor = .white
        $0.isUserInteractionEnabled = false
    }
    
    private let arrowImageView = UIImageView().then {
        $0.image = UIImage(systemName: "dumbbell")
        $0.tintColor = .white
        $0.isUserInteractionEnabled = false
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        self.backgroundColor = .blue
        self.layer.cornerRadius = 8
        
        addSubview(backView)
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        [
            buttonTitleLabel,
            arrowImageView,
            
        ].forEach { backView.addSubview($0) }
        
    }
    
    
    @objc private func buttonTapped() {
        
        print("Button tapped")
        
        }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        backView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(18)
            $0.left.equalTo(buttonTitleLabel.snp.right).offset(4)
            $0.right.equalToSuperview()
        }
       
        buttonTitleLabel.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.verticalEdges.equalToSuperview().inset(3)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
