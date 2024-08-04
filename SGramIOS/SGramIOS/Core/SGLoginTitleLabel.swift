import UIKit
import SnapKit
import Then


class SGLoginTitleLabel: UILabel {
    let label = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 40)
        $0.numberOfLines = 2
        $0.textColor = .red
    }

    init(text: String) {
        super.init(frame: .zero)
        
        
        label.text = "\(text)하자!"
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    func layout() {
        self.addSubview(label)

        label.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}


