//
//  GameError.swift
//  practice_FindOrLose_UIkit
//
//  Created by minii on 2021/12/16.
//

import Foundation

enum GameError: Error {
  case statusCode
  case decoding
  case invalidImage
  case invalidURL
  case other(Error)
  
  static func map(_ error: Error) -> GameError {
    return (error as? GameError) ?? .other(error)
  }
}
