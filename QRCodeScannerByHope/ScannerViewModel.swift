//
//  ScannerViewModel.swift
//  QRCodeScannerByHope
//
//  Created by Ahmet Berkay Ayhan on 7.05.2024.
//

/*
import Foundation
import SwiftUI

class ScannerViewModel: ObservableObject {
    @Published var scannedCode: String? {
        didSet {
            processScannedCode()
        }
    }
    @Published var isShowingScannedCode = false
    @Published var showAlertForHttp = false
    @Published var isAlertPresented = false
    var scannedURL: URL?

    private func processScannedCode() {
        guard let code = scannedCode, let url = URL(string: code) else {
            return
        }

        if UIApplication.shared.canOpenURL(url) {
            self.scannedURL = url
            // URL'in protokolünü kontrol et
            if url.scheme == "https" {
                // Güvenli bağlantı, tarayıcıda aç
                isShowingScannedCode = true
            } else if url.scheme == "http" {
                // Güvensiz bağlantı, uyarı göster
                showAlertForHttp = true
            }
        }
    }
}
*/

import Foundation
import SwiftUI
import UIKit // UIApplication için gereklidir.

class ScannerViewModel: ObservableObject {
    @Published var scannedCode: String? {
        didSet {
            processScannedCode()
        }
    }
    @Published var isAlertPresented = false
    @Published var showAlertForHttp = false
    var scannedURL: URL?

    private func processScannedCode() {
        guard let code = scannedCode else { return }
        
        if let url = URL(string: code), UIApplication.shared.canOpenURL(url) {
            self.scannedURL = url
            if url.scheme == "https" {
                // Güvenli bağlantı, tarayıcıda aç veya başka bir işlem yap
                isAlertPresented = true
                showAlertForHttp = false
            } else if url.scheme == "http" {
                // Güvensiz bağlantı, uyarı göster
                showAlertForHttp = true
                isAlertPresented = true
            }
        } else {
            // Düz metin durumu, Google'da ara veya başka bir işlem yap
            let query = code.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
            let googleSearchURL = "https://www.google.com/search?q=\(query)"
            self.scannedURL = URL(string: googleSearchURL)
            isAlertPresented = true
            showAlertForHttp = false
        }
    }
}



