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

    // MARK: - Properties

    /// Web view that displays the contents of a book's web reader link
    var webView: WKWebView = {
        let tempWebView = WKWebView()
        return tempWebView
    }()

    /// Passed in from BookDetailViewController, holds book's web reader link
    var link: URL?

    // MARK: - View Life Cylce

    override func viewDidLoad() {
        super.viewDidLoad()
        view = webView
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        navigationController?.navigationBar.backgroundColor = .white

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(goBack))
        navigationItem.leftBarButtonItem?.tintColor = .trinidadOrange

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(reloadWebView))
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: "arrow.clockwise")
        navigationItem.rightBarButtonItem?.tintColor = .trinidadOrange

        if let url = link {
            webView.load(URLRequest(url: url))
        } else {
            print("no url in webVC")
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("viewDidDisappear")
        webView.stopLoading()
    }

    // MARK: - Methods

    /// Reloads the content of the web view
    @objc func reloadWebView() {
        webView.reload()
    }

    /// Goes back to BookDetailViewController by pressing the "Done" button
    @objc func goBack() {
        dismiss(animated: true, completion: nil)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }

    // Maybe add an activity indicator view later so user know web view is loading
    // instead of staring at white screen for a couple of seconds before it loads?
}
