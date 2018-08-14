//
//  NSFWDetector.swift
//  NSFWDetector
//
//  Created by Michael Berg on 13.08.18.
//

import Foundation
import CoreML
import Vision

@available(iOS 12.0, *)
public class NSFWDetector {

    public static let shared = NSFWDetector()

    private let model: VNCoreMLModel

    public required init?() {
        guard let model = try? VNCoreMLModel(for: NSFW().model) else {
            return nil
        }
        self.model = model
    }

    /// The Result of an NSFW Detection
    ///
    /// - error: Detection was not successful
    /// - success: Detection was successful. `nsfwConfidence`: 0.0 for safe content - 1.0 for hardcore porn ;)
    public enum DetectionResult {
        case error(Error)
        case success(nsfwConfidence: VNConfidence)
    }

    public func check(image: UIImage, qos: DispatchQoS.QoSClass = .default, completion: @escaping (_ result: DetectionResult) -> Void) {

        // Create a requestHandler for the image
        let _requestHandler: VNImageRequestHandler?
        if let cgImage = image.cgImage {
            _requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        } else if let ciImage = image.ciImage {
            _requestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        } else {
            _requestHandler = nil
        }

        guard let requestHandler = _requestHandler else {
            completion(.error(NSError(domain: "either cgImage nor ciImage must be set inside of UIImage", code: 0, userInfo: nil)))

            return
        }

        /// The request that handles the detection completion
        let request = VNCoreMLRequest(model: self.model, completionHandler: { (request, error) in
            guard let observations = request.results as? [VNClassificationObservation], let observation = observations.first(where: { $0.identifier == "NSFW" }) else {
                DispatchQueue.main.async {
                    completion(.error(NSError(domain: "Detection failed: No NSFW Observation found", code: 0, userInfo: nil)))
                }

                return
            }

            DispatchQueue.main.async {
                completion(.success(nsfwConfidence: observation.confidence))
            }
        })

        /// Start the actual detection
        DispatchQueue.global(qos: qos).async {

            do {
                try requestHandler.perform([request])
            } catch {
                DispatchQueue.main.async {
                    completion(.error(NSError(domain: "Detection failed: No NSFW Observation found", code: 0, userInfo: nil)))
                }
            }
        }
    }
}
