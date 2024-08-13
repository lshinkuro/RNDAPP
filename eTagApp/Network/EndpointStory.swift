//
//  EndpointStory.swift
//  eTagApp
//
//  Created by Macbook on 04/06/24.
//

import Foundation
import UIKit

struct StoryParam {
    var page, size, location: Int

    init(page: Int = 0, size: Int = 5, location: Int = 0) {
        self.page = page
        self.size = size
        self.location = location
    }
}

struct AddStoryParam {
    let description: String
    let photo: UIImage
    let lat, lon: Float?
}



// MARK: - WelcomeElement
struct PlaceHolderElement: Codable {
    let userID, id: Int
    let title, body: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}

typealias PlaceHolder = [PlaceHolderElement]

enum EndpointStory {
    case fetchStory(param: StoryParam)
    case getDetailStory(String)
    case addNewStory(param: AddStoryParam)
    case news

    var path: String {
        switch self {
        case .fetchStory: return "/stories"
        case .getDetailStory(let id): return "/stories/\(id)"
        case .addNewStory: return "/stories"
        case .news: return "/posts"
        }
    }

    var method: String {
        switch self {
        case .fetchStory, .getDetailStory, .news: return "GET"
        case .addNewStory:
          return "POST"
        }
    }

    var bodyParam: [String: Any]? {
        switch self {
        case .fetchStory, .getDetailStory, .news: return nil
        case .addNewStory(let param):
            let params: [String: Any] = [
                "description": param.description,
                "photo": param.photo,
                "lat": param.lat ?? 0.0,
                "lon": param.lon ?? 0.0
            ]
            return params
        }
    }

    var queryParam: [String: Any]? {
        switch self {
        case .addNewStory, .getDetailStory, .news: return nil
        case .fetchStory(let param):
            return [
                "page": param.page,
                "size": param.size,
                "location": param.location
            ]
        }
    }

    var headers: [String: Any]? {
        switch self {
        case .addNewStory:
            return ["Content-Type": "multipart/form-data", "Authorization": "Bearer \(retrieveToken())"]
        case .fetchStory, .getDetailStory: return ["Authorization": "Bearer \(retrieveToken())"]
        case .news:
            return nil
        }
    }

    private func retrieveToken() -> String {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "AuthToken",
            kSecReturnData: kCFBooleanTrue!,
        ]

        var tokenData: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &tokenData)

        if status == errSecSuccess, let data = tokenData as? Data, let token = String(data: data, encoding: .utf8) {
            return token
        } else {
            print("Token not found in Keychain")
            return ""
        }
    }



    var urlString: String {
      switch self {
      case .news:
        return BaseConstant.urlPlaceholder + path
      default:
        return BaseConstant.urlStory + path
      }
    }
}

import Foundation

class BaseConstant {
    static let urlMockoon: String = "http://localhost:3000"
    static let urlPlaceholder: String = "https://jsonplaceholder.typicode.com"
    static let urlStory: String = "https://story-api.dicoding.dev/v1"
    static let urlProduct: String = "https://shoe121231.000webhostapp.com/api"



    static let fpcCornerRadius: CGFloat = 24.0
    static let userDef = UserDefaults.standard
    static private let userData = "userData"



    static func deleteUserFromUserDefaults() {
        userDef.removeObject(forKey: userData)
    }
}


