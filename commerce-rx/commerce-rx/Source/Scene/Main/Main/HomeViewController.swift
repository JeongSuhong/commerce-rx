
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
  private var fullNavHeight: CGFloat = 0
  
  override func viewDidLoad() {
setupPagerBar()
    searchView.reactor = HomeSearchViewReactor()
    
    super.viewDidLoad()
    
    navView.layoutIfNeeded()
    fullNavHeight = navView.frame.height
    containerTopConst.constant = fullNavHeight
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

    changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
        guard changeCurrentIndex == true else { return }
      oldCell?.label.bonMotStyleName = "nanum_10"
      oldCell?.label.textColor = .textDisable
      newCell?.label.bonMotStyleName = "nanumB_10"
      newCell?.label.textColor = .black
    }


  }
  
  override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
    let styleVC = MainStyleViewController.instantiate()
    let styleReactor = MainStyleReactor()
    styleVC.reactor = styleReactor

//    styleVC.rx.isDownScroll
//      .distinctUntilChanged()
//      .debounce(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
//      .observe(on: MainScheduler.asyncInstance)
//      .bind(with: self) { vc, isDown in
//
//        UIView.animate(withDuration: 0.5, animations: {
//          vc.searchView.isHidden = !isDown
//          vc.containerTopConst.constant = isDown ? vc.fullNavHeight : vc.buttonBarView.frame.height
//        })
//      }.disposed(by: disposeBag)
    
    let newVC = MainNewViewController.instantiate()
    
    return [styleVC, newVC]
  }
}
