

import Foundation
import UIKit

extension UIViewController {
  @IBAction func dismissAction() {
    if self.navigationController != nil {
      self.navigationController?.popViewController(animated: true)
    } else {
      self.dismiss(animated: true)
    }
  }
}
