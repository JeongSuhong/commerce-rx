

import Foundation
import UIKit
import AVFoundation
import NukeExtensions
import SnapKit

extension UIImageView {
  func loadImage(_ url: String, fitHeight: Bool = false) {
    NukeExtensions.loadImage(with: URL(string: url), into: self) { result in
      
      if let imageSize = try? result.get().image.size {
        if fitHeight {
          let ratio = imageSize.height / imageSize.width
          self.snp.remakeConstraints { $0.height.equalTo(self.frame.width * ratio) }
        }
      }
    }
  }
}
