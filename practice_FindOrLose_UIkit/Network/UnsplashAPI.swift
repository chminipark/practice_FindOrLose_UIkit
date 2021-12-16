//
//  UnsplashAPI.swift
//  practice_FindOrLose_UIkit
//
//  Created by minii on 2021/12/16.
//

import Foundation
import Combine

enum UnsplashAPI {
  static let accessToken = "MQztSXCJdIvjq_ycJ_VrXLnF0dMx9jOjbyIbxljY1gA"
  
  static func randomImage() -> AnyPublisher<ResUnsplash, GameError> {
    let url = URL(string: "https://api.unsplash.com/photos/random/?client_id=\(accessToken)")!

    let config = URLSessionConfiguration.default
    config.requestCachePolicy = .reloadIgnoringLocalCacheData
    config.urlCache = nil
    let session = URLSession(configuration: config)

    var urlRequst = URLRequest(url: url)
    urlRequst.addValue("Accept-Version", forHTTPHeaderField: "v1")

    return session.dataTaskPublisher(for: urlRequst)
      .tryMap { response in
        guard let httpResponse = response.response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else {
          throw GameError.statusCode
        }
        return response.data
      }
      .decode(type: ResUnsplash.self, decoder: JSONDecoder())
      .mapError { GameError.map($0) }
      .eraseToAnyPublisher()
    
    
//    session.dataTask(with: urlRequst) { data, response, error in
//      guard let response = response as? HTTPURLResponse,
//            response.statusCode == 200,
//            error == nil,
//            let data = data,
//            let decodedResponse = try? JSONDecoder().decode(ResUnsplash.self, from: data)
//      else {
//
//        completion(nil)
//        return
//      }
//
//      completion(decodedResponse)
//    }.resume()
  }
}
