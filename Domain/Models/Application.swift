
import Foundation

public struct Application: Codable, Equatable {
    public let name: String
    public let imageURL: String
    public let description: String
    public let priceType: PriceType
    public let price: String?
    public let inAppPurchases: Bool
    
    public init(
        name: String,
        imageURL: String,
        description: String,
        priceType: PriceType,
        price: String?,
        inAppPurchases: Bool
    ) {
        self.name = name
        self.imageURL = imageURL
        self.description = description
        self.priceType = priceType
        self.price = price
        self.inAppPurchases = inAppPurchases
    }
}
