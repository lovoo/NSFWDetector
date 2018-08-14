//
//  ViewController.swift
//  NSFWDetector
//
//  Created by absoluteheike on 08/12/2018.
//  Copyright (c) 2018 absoluteheike. All rights reserved.
//

import UIKit
import NSFWDetector

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 12.0, *) {

            let image = UIImage()


            guard #available(iOS 12.0, *), let detector = NSFWDetector.shared else {
                return
            }
            detector.check(image: image, completion: { result in

                switch result {
                case let .success(nsfwConfidence: confidence):
                    if confidence > 0.9 {
                        // 😱🙈😏
                    } else {
                        // ¯\_(ツ)_/¯
                    }
                default:
                    break
                }
            })
        }
    }
}

