import Foundation
import SnapKit
import Then
import UIKit


class MainViewController: UIViewController {
   let moveButton = UIButton().then {
       $0.backgroundColor = .blue
       $0.setTitle("채팅하러가기", for: .normal)
       $0.setTitleColor(.brown, for: .focused)
       $0.tintColor = .black
   }
    
    @objc func buttonDidTap() {
        self.navigationController?.pushViewController(ChatViewController(), animated: true)
    }
   
   
   override func viewDidLoad() {
       super.viewDidLoad()
              
       view.backgroundColor = .white
       
       view.addSubview(moveButton)
       
       moveButton.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
       
       moveButton.snp.makeConstraints {
           $0.center.equalToSuperview()
           
       }
       
   }
}
