
import UIKit
import ReactorKit
import XLPagerTabStrip
import SnapKit
import Reusable

class HomeViewController: ButtonBarPagerTabStripViewController, StoryboardView, StoryboardBased {
  
  typealias Reactor = HomeReactor
  
  @IBOutlet weak var containerTopConst: NSLayoutConstraint!
  @IBOutlet weak var navView: UIStackView!
  @IBOutlet weak var searchView: HomeSearchView!
  
  var disposeBag = DisposeBag()
  private let searchViewHeight: CGFloat = 60
  
  override func viewDidLoad() {
    setupPagerBar()
    searchView.reactor = HomeSearchViewReactor()
    
    super.viewDidLoad()

    searchView.snp.makeConstraints { $0.height.equalTo(searchViewHeight) }
  }
  
  func bind(reactor: Reactor) {

  }
  
  // MARK: PagerVC
  private func setupPagerBar() {
    settings.style.buttonBarBackgroundColor = .white
    settings.style.buttonBarItemBackgroundColor = .white
    settings.style.selectedBarBackgroundColor = .black
    settings.style.selectedBarHeight = 2.0
    settings.style.buttonBarMinimumLineSpacing = 0
    settings.style.buttonBarItemTitleColor = .black
    settings.style.buttonBarItemsShouldFillAvailableWidth = false
    settings.style.buttonBarLeftContentInset = 0
    settings.style.buttonBarRightContentInset = 0
    settings.style.buttonBarHeight = 30
    
    
    let flowLayout = UICollectionViewFlowLayout()
    let buttonBarHeight = settings.style.buttonBarHeight!
    flowLayout.scrollDirection = .horizontal
    buttonBarView.backgroundColor = .orange
    buttonBarView.selectedBar.backgroundColor = .black
    buttonBarView.autoresizingMask = .flexibleWidth
    buttonBarView.snp.makeConstraints { $0.height.equalTo(buttonBarHeight) }
    var newContainerViewFrame = containerView.frame
    newContainerViewFrame.origin.y = buttonBarHeight
    newContainerViewFrame.size.height = containerView.frame.size.height - (buttonBarHeight - containerView.frame.origin.y)
    containerView.frame = newContainerViewFrame
    
    containerView.delegate = self

    changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
      oldCell?.label.bonMotStyleName = "nanum_10"
      oldCell?.label.textColor = .init(resource: .co8E8E925)
      newCell?.label.bonMotStyleName = "nanumB_10"
      newCell?.label.textColor = .black
    }


  }
  
  override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
    let styleVC = HomeStyleViewController.instantiate()
    let styleReactor = HomeStyleReactor(steps: self.reactor?.steps)
    styleVC.reactor = styleReactor

    let newVC = HomeNewViewController.instantiate()
    
    Observable.from([styleVC, newVC])
      .flatMap { $0.isDownScroll }
      .distinctUntilChanged()
      .bind(with: self) { vc, isDown in
        vc.containerTopConst.constant = isDown ? -vc.searchViewHeight : 0
        
        UIView.animate(withDuration: 0.5, animations: {
          vc.view.layoutIfNeeded()
        })
      }.disposed(by: disposeBag)
    
    return [styleVC, newVC]
  }
}
