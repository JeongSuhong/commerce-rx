

import Foundation
import RealmSwift

enum ProductType: String, Codable, PersistableEnum {
  case todayDelivery
}

class ProductModel: Object {
  @Persisted(primaryKey: true) var id: String
  @Persisted var type: ProductType?
  @Persisted var name: String
  @Persisted var price: Int
  @Persisted var originPrice: Int
  @Persisted var createdAt: Date?
  @Persisted var brandName: String
  @Persisted var brandId: String
  @Persisted var brandImage: String?
  @Persisted var mainImage: String
  @Persisted var benefit: ProductBenefitModel?
  @Persisted var category = List<ProductCategoryModel>()
  @Persisted var isLike: Bool
  
  convenience init(_ res: ProductListRes.productRes) {
    self.init()
    self.id = res.id
    self.type = res.type
    self.name = res.name
    self.price = res.price
    self.originPrice = res.originPrice
    self.createdAt = res.createdAt.asDate()
    self.brandName = res.brandName
    self.brandId = res.brandId
    self.mainImage = res.representativeImage

    if let originBenefit = res.benefit {
      self.benefit = .init(originBenefit)
    }
    
    self.category.append(objectsIn: res.category.map { ProductCategoryModel($0) })
    
    self.isLike = res.isLike
  }
  
  convenience init(_ res: ProductDetailRes) {
    self.init()
    self.id = res.id
    self.type = res.type
    self.name = res.name
    self.price = res.price
    self.originPrice = res.originPrice
    self.createdAt = res.createdAt.asDate()
    self.brandName = res.brandName
    self.brandId = res.brandId
    self.brandImage = res.brandImage
    self.mainImage = res.representativeImage

    if let originBenefit = res.benefit {
      self.benefit = .init(originBenefit)
    }
    
    self.category.append(objectsIn: res.category.map { ProductCategoryModel($0) })
    
    self.isLike = res.isLike
  }
}

enum ProductBenefitType: String, Codable, PersistableEnum {
  case coupon, creditcard
}

class ProductBenefitModel: EmbeddedObject {
  @Persisted var type: ProductBenefitType
  @Persisted var amount: Int
  
  convenience init(_ info: productBenefitRes) {
    self.init()
    self.type = info.type
    self.amount = info.amount
  }
  
  func getTitle() -> String {
    switch type {
    case .coupon: return "최대 \(amount)% 쿠폰"
    case .creditcard: return "최대 \(amount.formatted())원 결제할인"
    }
  }
}

class ProductCategoryModel: EmbeddedObject {
  @Persisted var id: Int
  @Persisted var name: String
  
  convenience init(_ info: productCategoryRes) {
    self.init()
    self.id = info.id
    self.name = info.name
  }
}
