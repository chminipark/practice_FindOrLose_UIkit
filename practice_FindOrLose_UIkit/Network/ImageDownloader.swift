//
//  ImageDownloader.swift
//  practice_FindOrLose_UIkit
//
//  Created by minii on 2021/12/16.
//

import Foundation
import UIKit
import Combine

enum ImageDownloader {
  static func download(url: String) -> AnyPublisher<UIImage, GameError> {
    guard let url = URL(string: url) else {
      return Fail(error: GameError.invalidURL)
        .eraseToAnyPublisher()
    }
    
    return URLSession.shared.dataTaskPublisher(for: url)
      .tryMap { response -> Data in
        guard let httpResponse = response.response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else {
          throw GameError.invalidURL
        }
        return response.data
      }
      .tryMap { data in
        guard let image = UIImage(data: data) else {
          throw GameError.invalidImage
        }
        return image
      }
      .mapError { GameError.map($0) }
      .eraseToAnyPublisher()
      
    
//    URLSession.shared.dataTask(with: url) { data, response, error in
//      guard let httpResponse = response as? HTTPURLResponse,
//            httpResponse.statusCode == 200,
//            error == nil,
//            let data = data,
//            let img = UIImage(data: data)
//      else {
//        completion(nil)
//        return
//      }
//
//      completion(img)
//    }.resume()
  }
}
