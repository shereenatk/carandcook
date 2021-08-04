import Foundation

// MARK: - OnlinePaymentModel
struct OnlinePaymentModel: Codable {
    let result: OnlinePaymentResult?
    let id: Int?
    let status: Int?
    let isCanceled, isCompleted: Bool?
    let creationOptions: Int?
    let isFaulted: Bool?

    enum CodingKeys: String, CodingKey {
        case result = "Result"
        case id = "Id"
        case status = "Status"
        case isCanceled = "IsCanceled"
        case isCompleted = "IsCompleted"
        case creationOptions = "CreationOptions"
        case isFaulted = "IsFaulted"
    }
}

// MARK: - Result
struct OnlinePaymentResult: Codable {
    let message: String
}
