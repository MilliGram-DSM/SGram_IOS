//import UIKit
//import SocketIO
//
//class chatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//
//    var tableView: UITableView!
//    var inputTextField: UITextField!
//    var sendButton: UIButton!
//    var messages: [String] = []
//    var manager: SocketManager!
//    var socket: SocketIOClient!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        
//        manager = SocketManager(socketURL: URL(string: "http://니엄마1234567.com:8000")!, config: [.log(true), .compress])
//        socket = manager.defaultSocket
//        
//        socket.on(clientEvent: .connect) { data, ack in
//            print("Socket connected")
//        }
//        
//        socket.on("message") { data, ack in
//            if let message = data[0] as? String {
//                self.messages.append(message)
//                self.tableView.reloadData()
//                self.scrollToBottom()
//            }
//        }
//        
//        socket.connect()
//        
//        
//        tableView = UITableView(frame: self.view.bounds, style: .plain)
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        
//        
//        inputTextField = UITextField(frame: CGRect(x: 20, y: self.view.bounds.height - 60, width: self.view.bounds.width - 100, height: 40))
//        inputTextField.borderStyle = .roundedRect
//        inputTextField.placeholder = "메시지를 입력하세요"
//        
//        
//        sendButton = UIButton(frame: CGRect(x: self.view.bounds.width - 70, y: self.view.bounds.height - 60, width: 60, height: 40))
//        sendButton.setTitle("전송", for: .normal)
//        
//        
//        sendButton.setTitleColor(.white, for: .normal)
//        sendButton.backgroundColor = .blue
//        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
//        
//        
//        self.view.addSubview(tableView)
//        self.view.addSubview(inputTextField)
//        self.view.addSubview(sendButton)
//        
//    }
//    
//    @objc func sendMessage() {
//        guard let text = inputTextField.text, !text.isEmpty else { return }
//        
//        
//        socket.emit("message", text)
//        messages.append("나: \(text)")
//        
//        
//        
//        tableView.reloadData()
//        inputTextField.text = ""
//        scrollToBottom()
//    }
//    
//    func scrollToBottom() {
//        if messages.count > 0 {
//            tableView.scrollToRow(at: IndexPath(row: messages.count - 1, section: 0), at: .middle, animated: true)
//        }
//    }
//    
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return messages.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = messages[indexPath.row]
//        return cell
//    }
//}
//
//







import UIKit
import SocketIO

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tableView: UITableView!
    var inputTextField: UITextField!
    var sendButton: UIButton!
    var messages: [(String, String)] = [] // 아이디, 메시지
    var manager: SocketManager!
    var socket: SocketIOClient!
    var userId: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSocket()
        setupUI()
        loadMessages() // 저장된 메시지를 불러오기
    }

    func setupSocket() {
        manager = SocketManager(socketURL: URL(string: "http://니엄마1234567.com:8000")!, config: [.log(true), .compress])
        socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) { data, ack in
            print("Socket connected")
        }

        socket.on("userId") { data, ack in
            if let id = data[0] as? String {
                self.userId = id
                print("User ID: \(id)")
            }
        }

        socket.on("message") { data, ack in
            if let messageData = data[0] as? [String: Any],
               let message = messageData["message"] as? String,
               let senderId = messageData["userId"] as? String {
                self.messages.append((senderId, message))
                self.tableView.reloadData()
                self.scrollToBottom()
                self.saveMessages() // 메시지를 저장
            }
        }

        socket.connect()
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
        guard let text = inputTextField.text, !text.isEmpty, let userId = userId else { return }

        let messageData: [String: Any] = ["userId": userId, "message": text]
        socket.emit("message", messageData)
        messages.append((userId, "나: \(text)"))
        
        tableView.reloadData()
        inputTextField.text = ""
        scrollToBottom()
        saveMessages() // 메시지를 저장
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

    // 메시지 저장
    func saveMessages() {
        let messagesToSave = messages.map { ["userId": $0.0, "message": $0.1] }
        UserDefaults.standard.set(messagesToSave, forKey: "chatMessages")
    }

    // 저장된 메시지 불러오기
    func loadMessages() {
        if let savedMessages = UserDefaults.standard.array(forKey: "chatMessages") as? [[String: String]] {
            messages = savedMessages.map { ($0["userId"] ?? "", $0["message"] ?? "") }
            tableView.reloadData()
        }
    }
}
