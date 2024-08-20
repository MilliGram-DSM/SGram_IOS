    import UIKit
    import Starscream

    class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //    func didReceive(event: Starscream.WebSocketEvent, client: any Starscream.WebSocketClient) {
    //        switch event {
    //        case .connected(<#T##[String : String]#>)
    //        }
    //    }
        

        var tableView: UITableView!
        var inputTextField: UITextField!
        var sendButton: UIButton!
        var messages: [(String, String)] = []
        var socket: WebSocket!
        var userId: String?

        override func viewDidLoad() {
            super.viewDidLoad()

            setupWebSocket()
            setupUI()
            loadMessages()
        }

        func setupWebSocket() {
            var request = URLRequest(url: URL(string: "ws://asdf1234567.com:8000/ws")!)
            request.timeoutInterval = 5
            socket = WebSocket(request: request)

            socket.connect()
        }

        func websocketDidConnect(socket: WebSocketClient) {
            print("WebSocket 연결됨")
            
            let userIdRequest = ["action": "getUserId"]
            if let jsonData = try? JSONSerialization.data(withJSONObject: userIdRequest, options: []) {
                socket.write(data: jsonData)
            }
        }

        func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
            print("WebSocket 연결 해제됨: \(String(describing: error))")
        }

        func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
            print("서버로부터 메시지 수신: \(text)")
            
            if let messageData = text.data(using: .utf8) {
                do {
                    if let json = try JSONSerialization.jsonObject(with: messageData, options: []) as? [String: Any],
                       let message = json["message"] as? String,
                       let senderId = json["userId"] as? String {
                        self.messages.append((senderId, message))
                        self.tableView.reloadData()
                        self.scrollToBottom()
                        self.saveMessages()
                    }
                } catch {
                    print("오류: \(error)")
                }
            }
        }

        func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
            print("서버로부터 데이터 수신")
        }

        func setupUI() {
            tableView = UITableView(frame: self.view.bounds, style: .plain)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

            inputTextField = UITextField(frame: CGRect(x: 20, y: self.view.bounds.height - 60, width: self.view.bounds.width - 100, height: 40))
            inputTextField.borderStyle = .roundedRect
            inputTextField.placeholder = "메시지를 입력하세요"

            sendButton = UIButton(frame: CGRect(x: self.view.bounds.width - 70, y: self.view.bounds.height - 60, width: 60, height: 40))
            sendButton.setTitle("전송", for: .normal)
            sendButton.setTitleColor(.white, for: .normal)
            sendButton.backgroundColor = .blue
            sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)

            self.view.addSubview(tableView)
            self.view.addSubview(inputTextField)
            self.view.addSubview(sendButton)
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            loadMessages()
        }

        @objc func sendMessage() {
            guard let text = inputTextField.text, !text.isEmpty, let accountId = userId else { return }

            let messageData: [String: Any] = ["account_id": accountId, "message": text]
            if let jsonData = try? JSONSerialization.data(withJSONObject: messageData, options: []) {
                socket.write(data: jsonData)
            }

            messages.append((accountId, "나: \(text)"))
            tableView.reloadData()
            inputTextField.text = ""
            scrollToBottom()
            saveMessages()
        }

        func scrollToBottom() {
            if messages.count > 0 {
                tableView.scrollToRow(at: IndexPath(row: messages.count - 1, section: 0), at: .middle, animated: true)
            }
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return messages.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let (senderId, message) = messages[indexPath.row]
            cell.textLabel?.text = "\(senderId): \(message)"
            return cell
        }


        func saveMessages() {
            let messagesToSave = messages.map { ["userId": $0.0, "message": $0.1] }
            UserDefaults.standard.set(messagesToSave, forKey: "chatMessages")
        }


        func loadMessages() {
            if let savedMessages = UserDefaults.standard.array(forKey: "chatMessages") as? [[String: String]] {
                messages = savedMessages.map { ($0["userId"] ?? "", $0["message"] ?? "") }
                tableView.reloadData()
            }
        }
    }
