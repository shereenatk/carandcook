//
//  FeedbackModel.swift
//  Cart & Cook
//
//  Created by Development  on 14/06/2021.
//

import Foundation

// MARK: - ArticleModel
struct FeedbackModel: Codable {
    let feedbackID: Int?

    enum CodingKeys: String, CodingKey {
        case feedbackID = "FeedbackId"
    }
}
