//
//  ImageDownloader.swift
//  practice_FindOrLose_UIkit
//
//  Created by minii on 2021/12/16.
//

import Foundation
import UIKit

enum ImageDownloader {
  static func download(url: String, completion: @escaping (UIImage?) -> Void) {
    
    let url = URL(string: url)!
    
    URLSession.shared.dataTask(with: url) { data, response, error in
      guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200,
            error == nil,
            let data = data,
            let img = UIImage(data: data)
      else {
        completion(nil)
        return
      }
      
      completion(img)
    }.resume()
  }
}
