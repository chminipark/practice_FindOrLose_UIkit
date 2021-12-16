//
//  ViewController.swift
//  practice_FindOrLose_UIkit
//
//  Created by minii on 2021/12/16.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet var gameImageView: [UIImageView]!
  
  var gameImage: [UIImage] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  func setImage() {
    if gameImage.count == 4 {
      for (idx, image) in gameImage.enumerated() {
        gameImageView[idx].image = image
        gameImageView[idx].contentMode = .scaleToFill
      }
    }
  }
  
  @IBAction func pressStateButton(_ sender: Any) {
    UnsplashAPI.randomImage { resUnsplash in
      guard let url = resUnsplash?.urls.regular else {
        print(#fileID, "||", #function, "||", #line)
        return
      }
      ImageDownloader.download(url: url) { [unowned self] image in
        guard let image = image else {
          print(#fileID, "||", #function, "||", #line)
          return
        }
        self.gameImage.append(contentsOf: [image, image, image, image])
        self.gameImage.shuffle()
        
        DispatchQueue.main.async {
          setImage()
        }
      }
    }
  }
  
}

