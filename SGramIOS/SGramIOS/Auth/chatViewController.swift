import UIKit
import SocketIO

class chatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tableView: UITableView!
    var inputTextField: UITextField!
    var sendButton: UIButton!
    var messages: [String] = []
    var manager: SocketManager!
    var socket: SocketIOClient!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        manager = SocketManager(socketURL: URL(string: "http://니엄마1234567.com:8000")!, config: [.log(true), .compress])
        socket = manager.defaultSocket
        
        
        socket.on(clientEvent: .connect) { data, ack in
            print("Socket connected")
        }
        
        socket.on("message") { data, ack in
            if let message = data[0] as? String {
                self.messages.append(message)
                self.tableView.reloadData()
                self.scrollToBottom()
            }
        }
        
        socket.connect()
        
        
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
    
    @objc func sendMessage() {
        guard let text = inputTextField.text, !text.isEmpty else { return }
        
        
        socket.emit("message", text)
        messages.append("나: \(text)")
        
        
        tableView.reloadData()
        inputTextField.text = ""
        scrollToBottom()
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
        cell.textLabel?.text = messages[indexPath.row]
        return cell
    }
}

