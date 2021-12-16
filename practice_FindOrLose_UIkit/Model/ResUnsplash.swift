//
//  ResUnsplash.swift
//  practice_FindOrLose_UIkit
//
//  Created by minii on 2021/12/16.
//

import Foundation

struct ResUnsplash: Decodable {
  let urls: ImageURLs
}

struct ImageURLs: Decodable, Hashable {
  let regular: String
}
