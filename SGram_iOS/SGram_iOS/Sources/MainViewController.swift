import Foundation
import SnapKit
import Then
import UIKit


class MainViewController: UIViewController {
   let moveButton = UIButton().then {
       $0.backgroundColor = .blue
       $0.setTitle("채팅하러가기", for: .normal)
       $0.setTitleColor(.brown, for: .focused)
   }
   
   
   
   override func viewDidLoad() {
       super.viewDidLoad()
       
       
   }
}
