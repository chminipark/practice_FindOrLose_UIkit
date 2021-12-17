//
//  ViewController.swift
//  practice_FindOrLose_UIkit
//
//  Created by minii on 2021/12/16.
//

import UIKit
import Combine

class ViewController: UIViewController {
  // MARK: - Properties
  @IBOutlet var gameImageViews: [UIImageView]!
  @IBOutlet var activityIndicators: [UIActivityIndicatorView]!
  @IBOutlet weak var stateButton: UIButton!
  
  var gameState: GameState = .stop {
    didSet {
      if gameState == .play {
        playGame()
      } else{
        stopGame()
      }
    }
  }
  
  var gameImages: [UIImage] = []
  
  var subscriptions = Set<AnyCancellable>()
  
  // MARK: - App State
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "FindORLose 👻"
    self.stateButton.setTitle("Play", for: .normal)
    self.stateButton.setTitleColor(.white, for: .normal)
    self.stateButton.tintColor = .link
  }
  
  // MARK: - IBAction
  @IBAction func stateButtonAction(_ sender: Any) {
    toggleButton()
  }
  
  @IBAction func imageButtonAction(_ sender: Any) {
    print((sender as AnyObject).tag)
  }
  
  
  // MARK: - functions
  
  func playGame() {
    
    DispatchQueue.main.async { [unowned self] in
      self.title = "FindORLose 🔥🔥🔥"
      self.stateButton.setTitle("Stop", for: .normal)
      self.stateButton.setTitleColor(.black, for: .normal)
      self.stateButton.tintColor = .yellow
    }
    
    let firstImage = UnsplashAPI.randomImage()
      .flatMap { randomImageResponse in
        ImageDownloader.download(url: randomImageResponse.urls.regular)
      }
    
    let secondImage = UnsplashAPI.randomImage()
      .flatMap { randomImageResponse in
        ImageDownloader.download(url: randomImageResponse.urls.regular)
      }
    
    firstImage.zip(secondImage)
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished: break
        case .failure(let error):
          print("Error: \(error)")
          
        }
        
      }, receiveValue: { [unowned self] first, second in
        self.gameImages = [first, second, second, second].shuffled()
        self.setImage()
      })
      .store(in: &subscriptions)
    
    //    UnsplashAPI.randomImage { resUnsplash in
    //      guard let url = resUnsplash?.urls.regular else {
    //        print(#fileID, "||", #function, "||", #line)
    //        return
    //      }
    //      ImageDownloader.download(url: url) { [unowned self] image in
    //        guard let image = image else {
    //          print(#fileID, "||", #function, "||", #line)
    //          return
    //        }
    //        self.gameImages.append(contentsOf: [image, image, image, image])
    //        self.gameImages.shuffle()
    //
    //        DispatchQueue.main.async {
    //          setImage()
    //        }
    //      }
    //    }
  }
  
  func stopGame() {
    gameImages.removeAll()
    DispatchQueue.main.async { [unowned self] in
      self.gameImageViews.forEach { $0.image = nil }
      self.stateButton.setTitle("Play", for: .normal)
      self.stateButton.setTitleColor(.white, for: .normal)
      self.stateButton.tintColor = .link
      self.title = "FindORLose 👻"
    }
    startActivityIndicator()
  }
  
  func toggleButton() {
    if gameState == .play {
      gameState = .stop
    } else {
      gameState = .play
    }
  }
  
  func setImage() {
    if gameImages.count == 4 {
      for (idx, image) in gameImages.enumerated() {
        gameImageViews[idx].image = image
        gameImageViews[idx].contentMode = .scaleToFill
      }
    }
  }
  
  func startActivityIndicator() {
    activityIndicators.forEach { $0.startAnimating() }
  }
  
  func stopActivityIndicator() {
    activityIndicators.forEach { $0.stopAnimating() }
  }
  
  
  
  
  
  
}

