//
//  WebViewController.swift
//  BetterReads
//
//  Created by Jorge Alvarez on 5/27/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView = {
        let tempWebView = WKWebView()
        return tempWebView
    }()

    /// Passed in from BookDetailViewController, holds book's web reader link
    var link: URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        view = webView
        webView.navigationDelegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(goBack))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(reloadWebView))
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: "arrow.clockwise")
        navigationItem.rightBarButtonItem?.tintColor = .trinidadOrange
        navigationItem.leftBarButtonItem?.tintColor = .trinidadOrange

        navigationController?.navigationBar.backgroundColor = .white
        webView.allowsBackForwardNavigationGestures = true
        if let url = link {
            print("linkString = \(link)")
            print("url = \(url)")
            webView.load(URLRequest(url: url))
        } else {
            print("no url in webVC")
        }
    }

    @objc func reloadWebView() {
        webView.reload()
    }

    @objc func goBack() {
        dismiss(animated: true, completion: nil)
        //webView.removeFromSuperview() ?
    }
    //finished loading its page
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("viewDidDisappear")
        webView.stopLoading()
    }
}
