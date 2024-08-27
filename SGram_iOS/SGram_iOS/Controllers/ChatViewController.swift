//import UIKit
//import Starscream
//
//class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//
//    var tableView: UITableView!
//    var inputTextField: UITextField!
//    var sendButton: UIButton!
//    var messages: [(String, String)] = []
//    var socket: WebSocket!
//    var userId: String?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setupWebSocket()
//        setupUI()
//        loadMessages()
//    }
//
//    func setupWebSocket() {
//        var request = URLRequest(url: URL(string: "http://172.20.10.3:8080")!)
//        request.timeoutInterval = 5
//        socket = WebSocket(request: request)
//
//        socket.delegate = self 
//        socket.connect()
//    }
//
//    func websocketDidConnect(socket: WebSocketClient) {
//        print("WebSocket 연결됨")
//        
//        
//        let accountIdRequest = ["action": "getaccountId"]
//        if let jsonData = try? JSONSerialization.data(withJSONObject: accountIdRequest, options: []) {
//            socket.write(data: jsonData)
//        }
//    }
//
//    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
//        print("WebSocket 연결 해제됨: \(String(describing: error))")
//    }
//
//    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
//        print("서버로부터 메시지 수신: \(text)")
//        
//        if let messageData = text.data(using: .utf8) {
//            do {
//                if let json = try JSONSerialization.jsonObject(with: messageData, options: []) as? [String: Any] {
//                    
//                    if let userId = json["userId"] as? String {
//                        self.userId = userId
//                        print("사용자 ID: \(userId)")
//                    }
//                    
//                    
//                    if let message = json["message"] as? String,
//                       let senderId = json["userId"] as? String {
//                        DispatchQueue.main.async {
//                            self.messages.append((senderId, message))
//                            self.tableView.reloadData()
//                            self.scrollToBottom()
//                            self.saveMessages()
//                        }
//                    }
//                }
//            } catch {
//                print("오류: \(error)")
//            }
//        }
//    }
//
//    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
//        print("서버로부터 데이터 수신")
//    }
//
//    func setupUI() {
//        tableView = UITableView(frame: self.view.bounds, style: .plain)
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//
//        inputTextField = UITextField(frame: CGRect(x: 20, y: self.view.bounds.height - 60, width: self.view.bounds.width - 100, height: 40))
//        inputTextField.borderStyle = .roundedRect
//        inputTextField.placeholder = "메시지를 입력하세요"
//
//        sendButton = UIButton(frame: CGRect(x: self.view.bounds.width - 70, y: self.view.bounds.height - 60, width: 60, height: 40))
//        sendButton.setTitle("전송", for: .normal)
//        sendButton.setTitleColor(.white, for: .normal)
//        sendButton.backgroundColor = .blue
//        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
//
//        self.view.addSubview(tableView)
//        self.view.addSubview(inputTextField)
//        self.view.addSubview(sendButton)
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        loadMessages()
//    }
//
//    @objc func sendMessage() {
//        guard let text = inputTextField.text, !text.isEmpty, let accountId = userId else { return }
//
//        let messageData: [String: Any] = ["account_id": accountId, "message": text]
//        if let jsonData = try? JSONSerialization.data(withJSONObject: messageData, options: []) {
//            socket.write(data: jsonData)
//        }
//
//        DispatchQueue.main.async {
//            self.messages.append((accountId, "나: \(text)"))
//            self.tableView.reloadData()
//            self.inputTextField.text = ""
//            self.scrollToBottom()
//            self.saveMessages()
//        }
//    }
//
//    func scrollToBottom() {
//        if messages.count > 0 {
//            tableView.scrollToRow(at: IndexPath(row: messages.count - 1, section: 0), at: .middle, animated: true)
//        }
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return messages.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        let (senderId, message) = messages[indexPath.row]
//        cell.textLabel?.text = "\(senderId): \(message)"
//        return cell
//    }
//
//    func saveMessages() {
//        let messagesToSave = messages.map { ["accountId": $0.0, "message": $0.1] }
//        UserDefaults.standard.set(messagesToSave, forKey: "chatMessages")
//    }
//
//    func loadMessages() {
//        if let savedMessages = UserDefaults.standard.array(forKey: "chatMessages") as? [[String: String]] {
//            messages = savedMessages.map { ($0["accountId"] ?? "", $0["message"] ?? "") }
//            tableView.reloadData()
//        }
//    }
//}
//
//extension ChatViewController: WebSocketDelegate {
//    
//    func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocketClient) {
//        switch event {
//        case .connected(let headers):
//            print("WebSocket 연결됨: \(headers)")
//        case .disconnected(let reason, let code):
//            print("WebSocket 연결 해제됨: \(reason) with code: \(code)")
//        case .text(let string):
//            print("텍스트 메시지 수신: \(string)")
//        case .binary(let data):
//            print("바이너리 데이터 수신: \(data.count) bytes")
//        case .pong(let data):
//            print("Pong 수신: \(data?.count) bytes")
//        case .ping(let data):
//            print("Ping 수신: \(data?.count) bytes")
//        case .error(let error):
//            print("WebSocket 오류: \(String(describing: error))")
//        case .cancelled:
//            print("WebSocket 취소됨")
//        case .viabilityChanged(_):
//            print("쓸모없는거")
//        case .reconnectSuggested(_):
//            print("슬모없는거2")
//        case .peerClosed:
//            print("쓸모없는거3")
//        }
//    }
//}







//import UIKit
//import Starscream
//
//final class EmojiViewController: UIViewController {
//  
//  private enum Metric {
//    static let collectionViewItemSize = CGSize(width: 40, height: 40)
//    static let collectionViewSpacing = 16.0
//    static let collectionViewContentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//  }
//  private enum Color {
//    static let white = UIColor.white
//    static let clear = UIColor.clear
//  }
//
//  
//  private let informationLabel: UILabel = {
//    let label = UILabel()
//    label.textColor = .black
//    return label
//  }()
//  private let sendButton: UIButton = {
//    let button = UIButton()
//    button.setTitle("이모지 전송", for: .normal)
//    button.setTitleColor(.systemBlue, for: .normal)
//    button.setTitleColor(.blue, for: .highlighted)
//    button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
//    return button
//  }()
//  private let separatorView: UIView = {
//    let view = UIView()
//    view.backgroundColor = .lightGray
//    return view
//  }()
//  
//  
//  private let emojis = ["😀", "😬", "😁", "😂", "😃", "😄", "😅", "😆", "😇", "😉", "😊", "🙂", "🙃", "☺️", "😋", "😌", "😍", "😘", "😗", "😙", "😚", "😜", "😝", "😛", "🤑", "🤓", "😎", "🤗", "😏", "😶", "😐", "😑", "😒", "🙄", "🤔", "😳", "😞", "😟", "😠", "😡", "😔", "😕", "🙁", "☹️", "😣", "😖", "😫", "😩", "😤", "😮", "😱", "😨", "😰", "😯", "😦", "😧", "😢", "😥", "😪", "😓", "😭", "😵", "😲", "🤐", "😷", "🤒", "🤕", "😴", "💩"]
//  private let collectionView: UICollectionView = {
//    let flowLayout = UICollectionViewFlowLayout()
//    flowLayout.itemSize = Metric.collectionViewItemSize
//    flowLayout.minimumInteritemSpacing = Metric.collectionViewSpacing
//    flowLayout.minimumLineSpacing = Metric.collectionViewSpacing
//    let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
//    view.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
//    view.contentInset = Metric.collectionViewContentInset
//    view.showsHorizontalScrollIndicator = false
//    view.backgroundColor = Color.clear
//    return view
//  }()
//  private var informationLabelText: String = "" {
//    didSet {
//      self.informationLabel.attributedText = NSMutableAttributedString()
//        .resize(string: self.informationLabelText, fontSize: 120)
//    }
//  }
//  private let userName: String
//  private var socket: WebSocket?
//  
//  init() {
//    self.userName = UserDefaults.standard.string(forKey: "name") ?? ""
//    super.init(nibName: nil, bundle: nil)
//  }
//  
//  // 5
//  deinit {
//    socket?.disconnect()
//    socket?.delegate = nil
//  }
//  
//  @available(*, unavailable)
//  required init?(coder: NSCoder) {
//    fatalError()
//  }
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    self.title = "이모지 선택"
//    
//    self.view.backgroundColor = Color.white
//    self.view.addSubview(self.collectionView)
//    self.view.addSubview(self.informationLabel)
//    self.view.addSubview(self.sendButton)
//    self.view.addSubview(self.separatorView)
//    
//    self.collectionView.snp.makeConstraints {
//      $0.left.right.equalToSuperview()
//      $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(250)
//      $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
//    }
//    self.informationLabel.snp.makeConstraints {
//      $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(32)
//      $0.centerX.equalToSuperview()
//    }
//    self.sendButton.snp.makeConstraints {
//      $0.top.equalTo(self.collectionView.snp.top).offset(-50)
//      $0.centerX.equalToSuperview()
//    }
//    self.separatorView.snp.makeConstraints {
//      $0.height.equalTo(1)
//      $0.bottom.equalTo(self.collectionView.snp.top).offset(1)
//      $0.left.right.equalToSuperview()
//    }
//    
//    self.collectionView.dataSource = self
//    self.collectionView.delegate = self
//    
//    // 2 connect to web socket server
//    self.setupWebSocket()
//  }
//  
//  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//    super.touchesEnded(touches, with: event)
//    self.view.endEditing(true)
//  }
//  
//  private func setupWebSocket() {
//    let url = URL(string: "ws://localhost:1337/")!
//    var request = URLRequest(url: url)
//    request.timeoutInterval = 5
//    socket = WebSocket(request: request)
//    socket?.delegate = self
//    socket?.connect()
//  }
//  
//  @objc private func didTapButton() {
//    // 3-2
//    self.sendMessage(self.informationLabelText)
//  }
//  
//  // 3-1
//  private func sendMessage(_ message: String) {
//    self.title = "메세지 전송"
//    socket?.write(string: message)
//  }
//  
//  // 4-1
//  private func receivedMessage(_ message: String, senderName: String) {
//    self.title = "메세지 from (\(senderName))"
//    self.informationLabelText = message
//  }
//}
//
//extension EmojiViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//    self.emojis.count
//  }
//  
//  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EmojiCollectionViewCell
//    cell.prepare(emoji: emojis[indexPath.item])
//    return cell
//  }
//  
//  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//    let message = emojis[indexPath.item]
//    self.informationLabelText = message
//  }
//}
//
//extension EmojiViewController: WebSocketDelegate {
//  func didReceive(event: WebSocketEvent, client: WebSocket) {
//    switch event {
//    case .connected(let headers):
//      client.write(string: userName)
//      print("websocket is connected: \(headers)")
//    case .disconnected(let reason, let code):
//      print("websocket is disconnected: \(reason) with code: \(code)")
//    case .text(let text):
//      // 4-2
//      guard let data = text.data(using: .utf16),
//        let jsonData = try? JSONSerialization.jsonObject(with: data, options: []),
//        let jsonDict = jsonData as? NSDictionary,
//        let messageType = jsonDict["type"] as? String else {
//          return
//      }
//      
//      if messageType == "message",
//        let messageData = jsonDict["data"] as? NSDictionary,
//        let messageAuthor = messageData["author"] as? String,
//        let messageText = messageData["text"] as? String {
//        self.receivedMessage(messageText, senderName: messageAuthor)
//      }
//    case .binary(let data):
//      print("Received data: \(data.count)")
//    case .ping(_):
//      break
//    case .pong(_):
//      break
//    case .viabilityChanged(_):
//      break
//    case .reconnectSuggested(_):
//      break
//    case .cancelled:
//      print("websocket is canclled")
//    case .error(let error):
//      print("websocket is error = \(error!)")
//    }
//  }
//}
