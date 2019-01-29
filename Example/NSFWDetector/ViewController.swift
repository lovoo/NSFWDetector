//
//  ViewController.swift
//  NSFWDetector
//
//  Created by Michael Berg on 08/12/2018.
//  Copyright (c) 2018 LOVOO. All rights reserved.
//

import UIKit
import NSFWDetector

class ViewController: UIViewController {

    @IBOutlet weak var photosButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!

    private var selectedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.photosButton.layer.cornerRadius = 12.0
        self.cameraButton.layer.cornerRadius = self.photosButton.layer.cornerRadius
    }

    @IBAction func showImagePicker(_ sender: Any) {
        let picker = UIImagePickerController()

        picker.delegate = self
        picker.sourceType = .photoLibrary

        self.present(picker, animated: true, completion: nil)
    }

    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) { }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage ?? info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }

        self.selectedImage = image
        picker.dismiss(animated: true) {
            self.performSegue(withIdentifier: "ImageViewer", sender: self)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ImageViewer", let imageViewController = segue.destination.children.first as? ImageViewController else {
            return
        }

        imageViewController.image = self.selectedImage
        self.selectedImage = nil
    }
}
