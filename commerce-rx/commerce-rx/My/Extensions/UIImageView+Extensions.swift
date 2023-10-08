

import Foundation
import UIKit
import AVFoundation
import NukeExtensions

extension UIImageView {
  func loadImage(_ url: String) {
    NukeExtensions.loadImage(with: URL(string: url), into: self)
  }
}
