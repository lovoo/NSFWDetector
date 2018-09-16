//
//  CameraViewController.swift
//  NSFWDetector_Example
//
//  Created by Michael Berg on 17.08.18.
//  Copyright © 2018 LOVOO. All rights reserved.
//

import UIKit
import AVKit
import NSFWDetector

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    private var subsequentPositiveDetections = 0

    @IBOutlet weak var visualEffectsView: UIVisualEffectView!
    @IBOutlet weak var nsfwLabel: UILabel!

    @IBOutlet weak var alarmView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.visualEffectsView.layer.cornerRadius = 10.0
        self.visualEffectsView.clipsToBounds = true

        setupCaptureSession()
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {

        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }

        NSFWDetector.shared.check(cvPixelbuffer: pixelBuffer, qos: .userInteractive, completion: { result in

            switch result {
            case let .success(nsfwConfidence: confidence):
                self.didDetectNSFW(confidence: confidence)
            case .error:
                break
            }
        })
    }

    private func didDetectNSFW(confidence: Float) {
        if confidence > 0.8 {
            self.subsequentPositiveDetections += 1

            guard self.subsequentPositiveDetections > 3 else {
                return
            }

            self.alarmView.isHidden = false
        } else {
            self.subsequentPositiveDetections = 0

            self.alarmView.isHidden = true
        }

        self.nsfwLabel.text = String(format: "%.1f %% porn", confidence * 100.0)
    }
}

extension CameraViewController {

    func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSession.Preset.photo

        guard
            let frontCamera = self.frontCamera,
            let input = try? AVCaptureDeviceInput(device: frontCamera)
        else { return }

        captureSession.addInput(input)

        let cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer.videoGravity = .resizeAspectFill

        self.view.layer.insertSublayer(cameraPreviewLayer, at: 0)
        cameraPreviewLayer.frame = self.view.bounds

        let videoOutput = AVCaptureVideoDataOutput()

        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer delegate"))
        videoOutput.recommendedVideoSettings(forVideoCodecType: .jpeg, assetWriterOutputFileType: .mp4)

        captureSession.addOutput(videoOutput)
        captureSession.sessionPreset = .high
        captureSession.startRunning()
    }

    private var frontCamera: AVCaptureDevice? {

        return AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInMicrophone, .builtInDualCamera, .builtInTelephotoCamera, .builtInWideAngleCamera], mediaType: .video, position: .front).devices.first
    }
}
