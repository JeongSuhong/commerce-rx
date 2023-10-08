
import Foundation
import UIKit
import RxSwift
import XLPagerTabStrip
import ReusableKit
import Reusable
import ReactorKit

class HomeStyleViewController: BaseViewController, StoryboardBased, StoryboardView, IndicatorInfoProvider {
  
  enum Reusable {
    static let cell = ReusableCell<BaseTableCell<CommonProductView>>()
  }
  
  typealias Reactor = HomeStyleReactor
  
  @IBOutlet weak var headerView: HomeStyleHeaderView!
  
  private let itemInfo = IndicatorInfo(title: "스타일")
  
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return itemInfo
  }
  
  
  override func viewDidLoad() {
    
    
    super.viewDidLoad()
    
    //    mainView.register(Reusable.cell)
  }
  
  func bind(reactor: Reactor) {
    
    headerView.bannerView.rx.didSelected
      .distinctUntilChanged()
      .map { Reactor.Action.selectBanner($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    
    reactor.state.map { $0.status }
      .distinctUntilChanged()
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { vc, status in
        vc.loadingView.isHidden = status != .loading
        vc.errorView.isHidden = status != .error
      }.disposed(by: disposeBag)
    
    Observable.combineLatest(reactor.pulse(\.$banners).compactMap{ $0 },
                             self.rx.viewWillLayoutSubviews.take(1))
    .map { $0.0 }
    .observe(on: MainScheduler.asyncInstance)
    .bind(with: self) { vc, banners in
      vc.headerView.bannerView.bind(banners.data.map { ParallaxView.Model(imageUrl: $0.titleImage, title: $0.name) })
    }.disposed(by: disposeBag)
    
    reactor.pulse(\.$categorys)
      .compactMap { $0?.data }
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { vc, info in
        vc.headerView.bind(categorys: info)
      }.disposed(by: disposeBag)
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




