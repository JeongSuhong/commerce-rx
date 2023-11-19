

import Foundation
import UIKit
import FSPagerView
import Reusable
import RxSwift
import RxCocoa

extension Reactive where Base: ParallaxPagerView {
  var didSelected: ControlEvent<Int> {
    return ControlEvent(events: base.selectedAction)
  }
}

class ParallaxPagerView: UIView, NibOwnerLoadable {
  
  @IBOutlet weak var mainView: FSPagerView!
  @IBOutlet weak var countLabel: UILabel!
  @IBOutlet weak var moveListLabel: UILabel!
  
  var selectedAction = PublishSubject<Int>()
  
  private var disposeBag = DisposeBag()
  private var infos: [ParallaxView.Model] = []
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.loadNibContent()
    
    // FSPagerView 가 ReusableKit을 지원하지 않는다.
    mainView.register(ParallaxView.self, forCellWithReuseIdentifier: "cell")
    mainView.dataSource = self
    mainView.delegate = self
    mainView.automaticSlidingInterval = 5
    mainView.isInfinite = true
  }
  
  func bind(_ infos: [ParallaxView.Model]) {
    self.infos = infos
    mainView.reloadData()
  }
}

extension ParallaxPagerView: FSPagerViewDelegate , FSPagerViewDataSource {
  func numberOfItems(in pagerView: FSPagerView) -> Int {
    return infos.count
  }
  
  func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
    let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index) as! ParallaxView
    cell.bind(infos[index])
    return cell
  }
  
  func pagerViewDidScroll(_ pagerView: FSPagerView) {
    let offset = pagerView.scrollOffset * pagerView.bounds.width
    
    for i in 0 ..< infos.count {
      var newX: CGFloat = offset - CGFloat(i) * mainView.bounds.width
      
      if i == 0, pagerView.scrollOffset > CGFloat(infos.count - 1) {
        // isInfinity 일 경우 last -> 0 으로 넘어갈때 0번째 이미지 보이지 않는 이슈 해결
        // 이미지가 3장이면 마지막은 scrollOffset이 2.xxx 으로 온다 (마지막에 0번 이미지가 위치해야함!)
        newX = offset - CGFloat(infos.count) * mainView.bounds.width
      }
      
      let cell = pagerView.cellForItem(at: i) as? ParallaxView
      cell?.mainView.frame = CGRect(x: newX, y: 0,
                                   width: mainView.bounds.width, height: mainView.bounds.height)
    }
  }
  
  func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
    self.selectedAction.onNext(index)
  }

  func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
    countLabel.text = "\(index + 1) | \(infos.count)"
  }
}
