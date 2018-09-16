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

    public required init() {
        guard let model = try? VNCoreMLModel(for: NSFW().model) else {
            fatalError("NSFW should always be a valid model")
        }
        self.model = model
    }

    /// The Result of an NSFW Detection
    ///
    /// - error: Detection was not successful
    /// - success: Detection was successful. `nsfwConfidence`: 0.0 for safe content - 1.0 for hardcore porn ;)
    public enum DetectionResult {
        case error(Error)
        case success(nsfwConfidence: Float)
    }

    public func check(image: UIImage, completion: @escaping (_ result: DetectionResult) -> Void) {

        // Create a requestHandler for the image
        let requestHandler: VNImageRequestHandler?
        if let cgImage = image.cgImage {
            requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        } else if let ciImage = image.ciImage {
            requestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        } else {
            requestHandler = nil
        }

        self.check(requestHandler, completion: completion)
    }

    public func check(cvPixelbuffer: CVPixelBuffer, completion: @escaping (_ result: DetectionResult) -> Void) {

        let requestHandler = VNImageRequestHandler(cvPixelBuffer: cvPixelbuffer, options: [:])

        self.check(requestHandler, completion: completion)
    }
}

@available(iOS 12.0, *)
private extension NSFWDetector {

    func check(_ requestHandler: VNImageRequestHandler?, completion: @escaping (_ result: DetectionResult) -> Void) {

        guard let requestHandler = requestHandler else {
            completion(.error(NSError(domain: "either cgImage nor ciImage must be set inside of UIImage", code: 0, userInfo: nil)))
            return
        }

        /// The request that handles the detection completion
        let request = VNCoreMLRequest(model: self.model, completionHandler: { (request, error) in
            guard let observations = request.results as? [VNClassificationObservation], let observation = observations.first(where: { $0.identifier == "NSFW" }) else {
                completion(.error(NSError(domain: "Detection failed: No NSFW Observation found", code: 0, userInfo: nil)))

                return
            }

            completion(.success(nsfwConfidence: observation.confidence))
        })
        
        /// Start the actual detection
        do {
            try requestHandler.perform([request])
        } catch {
            completion(.error(NSError(domain: "Detection failed: No NSFW Observation found", code: 0, userInfo: nil)))
        }
    }
}
