
import Foundation
import UIKit
import RxSwift
import XLPagerTabStrip
import ReusableKit
import Reusable
import ReactorKit

class MainStyleViewController: UIViewController, StoryboardBased, StoryboardView, IndicatorInfoProvider {
  
    enum Reusable {
      static let cell = ReusableCell<BaseTableCell<CommonProductView>>()
    }
  
  typealias Reactor = MainStyleReactor
  
  @IBOutlet weak var mainView: BaseTableView!
  
  var disposeBag = DisposeBag()
  private let itemInfo = IndicatorInfo(title: "스타일")
  
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return itemInfo
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mainView.register(Reusable.cell)
    mainView.delegate = self
    mainView.dataSource = self
  }
  
  
  func bind(reactor: Reactor) {
    
  }

//  override func numberOfSections(in tableView: UITableView) -> Int {
//    return 1
//  }
//
//  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return 50
//  }
//
//  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let cell = tableView.dequeue(Reusable.cell, for: indexPath)
//    cell.cellView.backgroundColor = .gray
//    return cell
//  }
}


