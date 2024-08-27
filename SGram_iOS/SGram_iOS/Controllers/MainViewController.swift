import Foundation
import SnapKit
import Then
import UIKit


class MainViewController: UIViewController {
    private var webSocket: URLSessionWebSocketTask?
   let moveButton = UIButton().then {
       $0.backgroundColor = .blue
       $0.setTitle("채팅하러가기", for: .normal)
       $0.setTitleColor(.brown, for: .focused)
       $0.tintColor = .black
   }
    
    @objc func buttonDidTap() {
        let session = URLSession(
            configuration: .default,
            delegate: self,
            delegateQueue: OperationQueue()
        )
        
        guard let url = URL(string: "ws://172.20.10.5:8080/ws/chat") else { return }
        
        webSocket = session.webSocketTask(with: url)
        webSocket?.resume()
//        self.navigationController?.pushViewController(NameViewController(), animated: true)
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

extension MainViewController: URLSessionWebSocketDelegate {
    func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didOpenWithProtocol protocol: String?
    ) {
//        receive()
        send()
    }

    func receive() {
        
        webSocket?.receive(completionHandler: { [weak self] result in
            
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    print("Got data: \(data)")
                case .string(let message):
                    print("Got string: \(message)")
                @unknown default:
                    break
                }
            case .failure(let error):
                print("Receive error: \(error)")
            }
            
            self?.receive()
        })
        
    }

    func send() {
        
        let message: [String: Any] = [
            "message": Token.accessToken!
        ]
        let jsonData = try? JSONSerialization.data(
            withJSONObject: message,
            options: .prettyPrinted
        )
        
        self.webSocket?.send(.string("sfa")) { error in
            if let error = error {
                print("Send error: \(error)")
            }
        }
    }
}
