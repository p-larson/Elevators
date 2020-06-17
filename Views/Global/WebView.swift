//
//  WebView.swift
//  Elevators
//
//  Created by Peter Larson on 6/16/20.
//  Copyright © 2020 Peter Larson. All rights reserved.
//

import UIKit
import WebKit
import SwiftUI

struct WebView: UIViewRepresentable {
    
    let url: String
    
    func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView()
        
        if let link = URL(string: url) {
            view.load(URLRequest(url: link))
        }
        
        return view
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        return
    }
}
