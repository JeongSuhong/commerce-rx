

import UIKit
import Foundation
import ReactorKit
import Reusable
import FSPagerView

class StickyPagerStackView: UIView, NibOwnerLoadable {
  
  @IBOutlet weak var mainView: UIStackView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var controlView: FSPageControl!
  
  var disposeBag = DisposeBag()
  var scrollOffsetAction = PublishSubject<CGPoint>()
  
  private let followSpped: CGFloat = 0.5
  private var images: [String] = []
  private var viewIndex = 0
  
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.loadNibContent()
    
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    controlView.contentHorizontalAlignment = .center
    controlView.hidesForSinglePage = true
    controlView.setFillColor(.init(resource: .coE6E6E7), for: .normal)
    controlView.setFillColor(.white, for: .selected)
    controlView.itemSpacing = 4
    controlView.interitemSpacing = 2
  }
  
  
  func bind(_ images: [String]) {
    disposeBag = DisposeBag()
    
    let width = UIScreen.main.bounds.width
    self.images = images
    self.mainView.reusableViews(count: images.count, targetView: StickyPagerImageView.self)
      .enumerated().forEach { index, view in
        view.mainView.frame = .init(origin: .zero, size: .init(width: width, height: width))
        view.mainView.loadImage(images[index])
      }
    
    scrollOffsetAction
      .distinctUntilChanged()
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { v, offset in
        let targetView = v.mainView.arrangedSubviews[v.viewIndex] as? StickyPagerImageView
        
        if offset.y > 0 {
          let newY: CGFloat = offset.y * v.followSpped
          targetView?.mainView.frame = .init(x: 0, y: newY, width:width, height: width)
        } else if offset.y < 0 {
          targetView?.mainView.frame = .init(x: offset.y / 2, y: offset.y, width: width - offset.y, height: width - offset.y)
        } else {
          targetView?.mainView.frame = .init(origin: .zero, size: .init(width: width, height: width))
        }
      }.disposed(by: disposeBag)
    
    scrollView.rx.contentOffset
      .map { $0.x / UIScreen.main.bounds.width }
      .skip { $0.isNaN }
      .distinctUntilChanged()
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { v, index in
        v.mainView.arrangedSubviews[v.viewIndex].clipsToBounds = true
        v.viewIndex = Int(index)
        v.mainView.arrangedSubviews[Int(index)].clipsToBounds = false
      }.disposed(by: disposeBag)
  }
}
