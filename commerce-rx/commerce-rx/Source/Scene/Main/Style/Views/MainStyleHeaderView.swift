//
//  MainStyleHeaderView.swift
//  commerce-rx
//
//  Created by Mocca on 2023/09/20.
//

import Foundation
import UIKit
import Reusable

class MainStyleHeaderView: UIView, NibOwnerLoadable {
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.loadNibContent()
  }
  
}
