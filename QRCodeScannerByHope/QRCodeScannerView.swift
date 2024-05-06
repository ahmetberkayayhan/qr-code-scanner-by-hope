//
//  QRCodeScannerView.swift
//  QRCodeScannerByHope
//
//  Created by Ahmet Berkay Ayhan on 7.05.2024.
//

import SwiftUI
import AVFoundation

struct QRCodeScannerView: UIViewRepresentable {
    @Binding var scannedCode: String?
    var supportedBarcodeTypes: [AVMetadataObject.ObjectType] = [.qr]

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: CGRect.zero)
        let captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video),
              let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
              captureSession.canAddInput(videoInput) else {
            return view
        }

        captureSession.addInput(videoInput)

        let metadataOutput = AVCaptureMetadataOutput()

        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = supportedBarcodeTypes
        } else {
            return view
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // UIView'in tüm alt katmanlarını güvenli bir şekilde al
        guard let layer = uiView.layer.sublayers?.first(where: { $0 is AVCaptureVideoPreviewLayer }) as? AVCaptureVideoPreviewLayer else {
            return
        }
        
        // AVCaptureVideoPreviewLayer'ın boyutunu UIView'in güncel boyutlarına ayarla
        layer.frame = uiView.bounds
    }

    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: QRCodeScannerView

        init(_ parent: QRCodeScannerView) {
            self.parent = parent
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject, let stringValue = metadataObject.stringValue {
                DispatchQueue.main.async {
                    self.parent.scannedCode = stringValue
                }
            }
        }
    }
}
