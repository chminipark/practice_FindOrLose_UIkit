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
  @IBOutlet var gameImageView: [UIImageView]!
  
  var gameImage: [UIImage] = []
  
  var subscriptions = Set<AnyCancellable>()
  
  // MARK: - App State
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  // MARK: - IBAction
  @IBAction func stateButtonAction(_ sender: Any) {
    
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
        self.gameImage = [first, second, second, second].shuffled()
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
    //        self.gameImage.append(contentsOf: [image, image, image, image])
    //        self.gameImage.shuffle()
    //
    //        DispatchQueue.main.async {
    //          setImage()
    //        }
    //      }
    //    }
  }
  
  @IBAction func imageButtonAction(_ sender: Any) {
    print((sender as AnyObject).tag)
  }
  
  
  // MARK: - functions
  
  func setImage() {
    if gameImage.count == 4 {
      for (idx, image) in gameImage.enumerated() {
        gameImageView[idx].image = image
        gameImageView[idx].contentMode = .scaleToFill
      }
    }
  }
  
  
  
  
  
  
}

