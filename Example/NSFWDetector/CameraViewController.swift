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
import Vision
import AVKit

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    private var subsequentPositiveDetections = 0

    @IBOutlet weak var visualEffectsView: UIVisualEffectView!
    @IBOutlet weak var nsfwLabel: UILabel!

    @IBOutlet weak var alarmView: UIVisualEffectView!
    @IBOutlet weak var emojiView: UIView!

    private var player: AVPlayer?

    deinit {
        self.player?.pause()
        self.player = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.visualEffectsView.layer.cornerRadius = 10.0
        self.visualEffectsView.clipsToBounds = true

        self.alarmView.isHidden = true

        setupCaptureSession()
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {

        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }

        NSFWDetector.shared.check(cvPixelbuffer: pixelBuffer) { [weak self] result in

            if case let .success(nsfwConfidence: confidence) = result {

                DispatchQueue.main.async {
                    self?.didDetectNSFW(confidence: confidence)
                }
            }
        }
    }

    private func didDetectNSFW(confidence: Float) {
        if confidence > 0.8 {
            self.subsequentPositiveDetections += 1

            guard self.subsequentPositiveDetections > 3 else {
                return
            }

            self.showAlarmView()
        } else {
            self.subsequentPositiveDetections = 0

            self.hideAlarmView()
        }

        self.nsfwLabel.text = String(format: "%.1f %% porn", confidence * 100.0)
    }

    private func showAlarmView() {

        guard self.alarmView.isHidden else {
            return
        }

        self.alarmView.isHidden = false

        self.alarmView.effect = nil
        self.emojiView.alpha = 0.0

        UIView.animate(withDuration: 0.3) {
            self.alarmView.effect = UIBlurEffect(style: .light)
            self.emojiView.alpha = 1.0
        }

        guard let path = Bundle.main.path(forResource: "Wilhelm_Scream.ogg", ofType: "mp3") else {
            return
        }
        self.player = AVPlayer(url: URL(fileURLWithPath: path))
        self.player?.play()

        self.player?.actionAtItemEnd = .pause
    }

    private func hideAlarmView() {
        guard !self.alarmView.isHidden else {
            return
        }

        self.player?.pause()
        self.player = nil

        UIView.animate(withDuration: 0.3, animations: {
            self.alarmView.effect = nil
            self.emojiView.alpha = 0.0
        }) { finished in
            if finished {
                self.alarmView.isHidden = true
                self.subsequentPositiveDetections = 0
            }
        }
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
