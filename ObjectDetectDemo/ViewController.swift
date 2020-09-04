//
//  ViewController.swift
//  ObjectDetectDemo
//
//  Created by Neil Marcellini on 9/2/20.
//

import UIKit
import AVKit
import Vision

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    var observation = "test" {
        didSet {
            self.obsLabel.text = String(observation)
        }
    }
    var confidence: Float = 0.0 {
        didSet {
            
            self.confidenceLabel.text = "Confidence = " + String(format: "%.0f" , confidence) + "%"
        }
    }
    var obsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var confidenceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(obsLabel)
        view.addSubview(confidenceLabel)
        setupLabels()
        
        view.backgroundColor = .blue
        
        // starting up the camera
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        guard let captureDevice =
                AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.addInput(input)
        
        captureSession.startRunning()
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = self.view.bounds
        
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
        
        

    }
    
    private func setupLabels() {
        obsLabel.textAlignment = .center
        self.obsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.obsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        self.obsLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        confidenceLabel.textAlignment = .center
        confidenceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        confidenceLabel.topAnchor.constraint(equalTo: obsLabel.bottomAnchor, constant: 20).isActive = true
        confidenceLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer =
                CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let config = MLModelConfiguration()
        config.computeUnits = .all
        guard let model = try? VNCoreMLModel(for: Resnet50(configuration: config).model) else { return}
        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
            //perhaps check the error
            guard let results = finishedReq.results as?
                    [VNClassificationObservation] else {return}
            guard let firstObservation = results.first else {return}
            DispatchQueue.main.async {
                self.observation = firstObservation.identifier
                let confidenceRaw = firstObservation.confidence
                self.confidence = confidenceRaw * 100
                print(firstObservation.identifier, firstObservation.confidence)
            }
        }
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    
    }
}

