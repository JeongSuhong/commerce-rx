

import Foundation
import UIKit

extension UICollectionViewLayout {
  static func compositional(count: Int, height: NSCollectionLayoutDimension, itemSpacing: CGFloat = 0, lineSpacing: CGFloat = 0, inset: NSDirectionalEdgeInsets = .zero, headerHeight: CGFloat? = nil, footerHeight: CGFloat? = nil) -> UICollectionViewCompositionalLayout {
    let configuration = UICollectionViewCompositionalLayoutConfiguration()
    configuration.scrollDirection = .vertical
    
    var supplementItems: [NSCollectionLayoutBoundarySupplementaryItem] = []
    if let headerHeight {
      let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(headerHeight))
      let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                               elementKind: UICollectionView.elementKindSectionHeader,
                                                               alignment: .top)
      
      supplementItems += [header]
    }
    
    if let footerHeight {
      let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(footerHeight))
      let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize,
                                                               elementKind: UICollectionView.elementKindSectionFooter,
                                                               alignment: .bottom)
      supplementItems += [footer]
    }
    
    configuration.boundarySupplementaryItems = supplementItems
    
    let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                            heightDimension: height)
    let item = NSCollectionLayoutItem(layoutSize: layoutSize)
    
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize,
                                                   subitem: item,
                                                   count: count)
    group.interItemSpacing = .fixed(itemSpacing)
    
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = lineSpacing
    section.contentInsets = inset
    
    return UICollectionViewCompositionalLayout(section: section, configuration: configuration)
  }
}

