//
//  ContentView.swift
//  QRCodeScannerByHope
//
//  Created by Ahmet Berkay Ayhan on 7.05.2024.
//

/*(((import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var scannedCode: String?
    @State private var isShowingScannedCode = false // Alert gösterimi için yeni bir state
    
    var body: some View {
        QRCodeScannerView(scannedCode: $scannedCode)
            .onAppear() {
                // Kamera kullanım izni isteği ve diğer başlangıç işlemleri
            }
            .onChange(of: scannedCode) { newValue in
                // scannedCode değiştiğinde ve nil değilse alert gösterimi tetiklenir
                if newValue != nil {
                    isShowingScannedCode = true
                }
            }
            .alert("Scanned QR Code", isPresented: $isShowingScannedCode) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(scannedCode ?? "Unknown")
            }
    }
}

import SwiftUI
import AVFoundation

// ViewModel sınıfını daha basit bir hale getiriyorum
class ScannerViewModel: ObservableObject {
    @Published var scannedCode: String? {
        didSet {
            if scannedCode != nil {
                isShowingScannedCode = true
            }
        }
    }
    @Published var isShowingScannedCode = false
}

struct ContentView: View {
    @StateObject private var viewModel = ScannerViewModel()
    
    var body: some View {
        QRCodeScannerView(scannedCode: $viewModel.scannedCode)
            .onAppear() {
                // Kamera kullanım izni isteği ve diğer başlangıç işlemleri
            }
            .alert("Scanned QR Code", isPresented: $viewModel.isShowingScannedCode) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.scannedCode ?? "Unknown")
            }
    }
}

 

import SwiftUI

// ViewModel sınıfınızı güncelleyin
class ScannerViewModel: ObservableObject {
    @Published var scannedCode: String? {
        didSet {
            if let code = scannedCode, let url = URL(string: code), UIApplication.shared.canOpenURL(url) {
                self.scannedURL = url
                isShowingScannedCode = true
            }
        }
    }
    @Published var isShowingScannedCode = false
    var scannedURL: URL?
}

struct ContentView: View {
    @StateObject private var viewModel = ScannerViewModel()
    
    var body: some View {
        QRCodeScannerView(scannedCode: $viewModel.scannedCode)
            .alert("Scanned QR Code", isPresented: $viewModel.isShowingScannedCode) {
                Button("Open in Browser", action: {
                    // Kullanıcının tarayıcıda açma isteğini işle
                    if let url = viewModel.scannedURL {
                        UIApplication.shared.open(url)
                    }
                })
                Button("Cancel", role: .cancel) { }
            } message: {
                Text(viewModel.scannedCode ?? "Unknown")
            }
    }
}
 


import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ScannerViewModel()
    
    var body: some View {
        QRCodeScannerView(scannedCode: $viewModel.scannedCode)
            .alert("Scanned QR Code", isPresented: $viewModel.isShowingScannedCode) {
                Button("Open in Browser", action: {
                    // Kullanıcının tarayıcıda açma isteğini işle
                    if let url = viewModel.scannedURL {
                        UIApplication.shared.open(url)
                    }
                })
                Button("Cancel", role: .cancel) { }
            } message: {
                Text(viewModel.scannedCode ?? "Unknown")
            }
            .alert("Warning", isPresented: $viewModel.showAlertForHttp) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("The link is not secure (http). Opening this link may pose a security risk. Are you sure you want to proceed?")
            }
    }
}



import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ScannerViewModel()
    
    var body: some View {
        QRCodeScannerView(scannedCode: $viewModel.scannedCode)
            .alert("Scanned QR Code", isPresented: $viewModel.isShowingScannedCode) {
                Button("Open in Browser", action: {
                    // Kullanıcının tarayıcıda açma isteğini işle
                    if let url = viewModel.scannedURL {
                        UIApplication.shared.open(url)
                    }
                })
                Button("Cancel", role: .cancel) { }
            } message: {
                Text(viewModel.scannedCode ?? "Unknown")
            }
            .alert("Warning", isPresented: $viewModel.showAlertForHttp) {
                Button("Proceed", action: {
                    // Kullanıcının güvensiz bağlantıyı tarayıcıda açma isteğini işle
                    if let url = viewModel.scannedURL, url.scheme == "http" {
                        UIApplication.shared.open(url)
                    }
                })
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("The link is not secure (http). Opening this link may pose a security risk. Are you sure you want to proceed?")
            }
    }
}
 
 */

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ScannerViewModel()
    
    var body: some View {
        VStack {
            QRCodeScannerView(scannedCode: $viewModel.scannedCode)
            // Diğer UI elemanları buraya eklenebilir.
        }
        .alert(isPresented: $viewModel.isAlertPresented) {
            if viewModel.showAlertForHttp {
                return Alert(
                    title: Text("Warning"),
                    message: Text("The link is not secure (http). Opening this link may pose a security risk. Are you sure you want to proceed?"),
                    primaryButton: .default(Text("Proceed"), action: {
                        if let url = viewModel.scannedURL, url.scheme == "http" {
                            UIApplication.shared.open(url)
                        }
                    }),
                    secondaryButton: .cancel()
                )
            } else {
                return Alert(
                    title: Text("Scanned QR Code"),
                    message: Text(viewModel.scannedCode ?? "Unknown"),
                    primaryButton: .default(Text("Open in Browser"), action: {
                        if let url = viewModel.scannedURL {
                            UIApplication.shared.open(url)
                        }
                    }),
                    secondaryButton: .cancel()
                )
            }
        }
    }
}
