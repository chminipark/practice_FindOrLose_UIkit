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
  @IBOutlet weak var scoreLabel: UILabel!
  
  var gameState: GameState = .stop {
    didSet {
      if gameState == .play {
        playGame()
      } else{
        stopGame()
      }
    }
  }
  
  var gameTimer: AnyCancellable?
  var gameImages: [UIImage] = []
  var subscriptions = Set<AnyCancellable>()
  var score: Int = 0
  
  // MARK: - App State
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "FindORLose 👻"
    self.stateButton.setTitle("Play", for: .normal)
    self.stateButton.setTitleColor(.white, for: .normal)
    self.stateButton.tintColor = .link
    self.scoreLabel.text = "Score : \(score)"
  }
  
  // MARK: - IBAction
  @IBAction func stateButtonAction(_ sender: UIButton) {
    toggleButton()
  }
  
  @IBAction func imageButtonAction(_ sender: UIButton) {
    let selectedImage = gameImages.filter { $0 == gameImages[sender.tag] }
    
    if selectedImage.count == 1 {
      playGame()
    } else {
      stopGame()
    }
  }
  
  
  // MARK: - functions
  
  func playGame() {
    
    
    DispatchQueue.main.async { [unowned self] in
      self.title = "FindORLose 🔥🔥🔥"
      self.stateButton.setTitle("Stop", for: .normal)
      self.stateButton.setTitleColor(.black, for: .normal)
      self.stateButton.tintColor = .yellow
      score += 200
      self.scoreLabel.text = "Score : \(score)"
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
        
        self.scoreLabel.text = "Score : \(score)"
        
        self.gameTimer = Timer.publish(every: 0.1, on: RunLoop.main, in: .common)
          .autoconnect()
          .sink { [unowned self] _ in
            self.scoreLabel.text = "Score : \(score)"
            self.score -= 10
            
            if score < 0 {
              score = 0
              gameTimer?.cancel()
            }
          }
        
        stopActivityIndicator()
        setImage()
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
    // subscription, anycancellable????
    subscriptions.forEach { $0.cancel() }
    
    gameTimer?.cancel()
    
    gameImages.removeAll()
    DispatchQueue.main.async { [unowned self] in
      self.gameImageViews.forEach { $0.image = nil }
      self.stateButton.setTitle("Play", for: .normal)
      self.stateButton.setTitleColor(.white, for: .normal)
      self.stateButton.tintColor = .link
      self.title = "FindORLose 👻"
      score = 0
      self.scoreLabel.text = "Score : \(score)"
    }
    startActivityIndicator()
    resetImage()
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
  
  func resetImage() {
    subscriptions = []
    gameImages = []
    gameImageViews.forEach { $0.image = nil }
  }
  
  func startActivityIndicator() {
    activityIndicators.forEach { $0.startAnimating() }
  }
  
  func stopActivityIndicator() {
    activityIndicators.forEach { $0.stopAnimating() }
  }
  
  
  
  
  
  
}

