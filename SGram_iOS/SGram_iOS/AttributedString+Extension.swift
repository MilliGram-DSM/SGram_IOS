import Foundation
import UIKit

extension NSMutableAttributedString {
  func resize(string: String, fontSize: CGFloat) -> NSMutableAttributedString {
    let font = UIFont.systemFont(ofSize: fontSize)
    let attributes = [NSAttributedString.Key.font: font]
    self.append(NSAttributedString(string: string, attributes: attributes))
    return self
  }
}
