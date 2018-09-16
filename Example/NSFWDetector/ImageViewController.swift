//
//  ImageViewController.swift
//  NSFWDetector_Example
//
//  Created by Michael Berg on 21.08.18.
//  Copyright © 2018 LOVOO. All rights reserved.
//

import UIKit
import NSFWDetector
import QuartzCore

class ImageViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var blurView: UIVisualEffectView!
    @IBOutlet private weak var nsfwLabel: UILabel!

    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.blurView.layer.cornerRadius = 10.0
        self.blurView.clipsToBounds = true

        guard let image = self.image else {
            self.nsfwLabel.text = "No Image selected."
            return
        }

        self.imageView.image = image

        NSFWDetector.shared.check(image: image) { result in
            switch result {
            case .error:
                self.nsfwLabel.text = "Detection failed"
            case let .success(nsfwConfidence: confidence):
                self.nsfwLabel.text = String(format: "%.1f %% porn", confidence * 100.0)
            }
        }
    }
}
