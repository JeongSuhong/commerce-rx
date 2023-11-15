
import Foundation
import UIKit
import XLPagerTabStrip
import Reusable

class HomeNewViewController: BasePagerViewController, StoryboardBased, IndicatorInfoProvider {
  
  private let itemInfo = IndicatorInfo(title: "NEW")
  
  func indicatorInfo(for pagerTabStripController: XLPagerTabStrip.PagerTabStripViewController) -> XLPagerTabStrip.IndicatorInfo {
    return itemInfo
  }
}
