import Foundation

enum WebSocketError: Error {
  case invalidURL
}

final class WebSocket: NSObject {
  static let shared = WebSocket()
  
  private override init() {}
}

extension WebSocket: URLSessionWebSocketDelegate {
    func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didOpenWithProtocol protocol: String?
      ) {
//        self.delegate?.urlSession?(
//          session,
//          webSocketTask: webSocketTask,
//          didOpenWithProtocol: `protocol`
//        )
      }
      
      func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
        reason: Data?
      ) {
//        self.delegate?.urlSession?(
//          session,
//          webSocketTask: webSocketTask,
//          didCloseWith: closeCode,
//          reason: reason
//        )
      }
}
