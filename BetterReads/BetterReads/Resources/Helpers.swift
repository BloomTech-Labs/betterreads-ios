//
//  Helpers.swift
//  BetterReads
//
//  Created by Ciara Beitel on 4/22/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit

// URL
extension URL {
    /// Returns a URL? that uses https instead of http
    var usingHTTPS: URL? {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else { return nil }
        components.scheme = "https"
        return components.url
    }
}

// Animation
extension UIView {
    func performFlare() {
        func flare() { transform = CGAffineTransform( scaleX: 1.03, y: 1.04) }
        func unflare() { transform = .identity }
        UIView.animate(withDuration: 0.15,
                       animations: { flare() },
                       completion: { _ in UIView.animate(withDuration: 0.7) { unflare() }})
    }
    func buttonTap() {
        func flare() { transform = CGAffineTransform( scaleX: 1.1, y: 1.3) }
        func unflare() { transform = .identity }
        UIView.animate(withDuration: 0.07,
                       animations: { flare() },
                       completion: { _ in UIView.animate(withDuration: 0.3) { unflare() }})
    }
}
// Color Palette
extension UIColor {
    /// Trinidad Orange #D44808
    static let trinidadOrange = UIColor(red: 212.0/255.0, green: 72.0/255.0, blue: 8.0/255.0, alpha: 1.0)
    /// Tundra #404040 - dark gray
    static let tundra = UIColor(red: 64.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1.0)
    /// Dove Gray #737373 - light gray
    static let doveGray = UIColor(red: 115.0/255.0, green: 115.0/255.0, blue: 115.0/255.0, alpha: 1.0)
    /// Alto Gray #D9D9D9 - lighter gray
    static let altoGray = UIColor(red: 217.0/255.0, green: 217.0/255.0, blue: 217.0/255.0, alpha: 1.0)
    /// Cinnabar Red #E33434
    static let cinnabarRed = UIColor(red: 208.0/255.0, green: 68.0/255.0, blue: 61.0/255.0, alpha: 1.0)
}

// Fonts
extension UIFont {
    static let sourceSansProRegular16 = UIFont(name: "SourceSansPro-Regular", size: 16)
    static let sourceSansProSemibold20 = UIFont(name: "SourceSansPro-SemiBold", size: 20)
}

// Alerts
extension UIViewController {
    func showBasicAlert(alertText: String, alertMessage: String, actionTitle: String) {
        let alert = UIAlertController(title: alertText,
                                      message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// Segmented Control Background & Divider Image on Sign Up/Sign In Screen
extension UIImage {
    static let segControlBackgroundImage = UIImage(color: .clear, size: CGSize(width: 1, height: 32))
    static let segControlDividerImage = UIImage(color: .clear, size: CGSize(width: 1, height: 32))
    convenience init(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        color.set()
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.fill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.init(data: image.pngData()!)!
    }
}

// Default Book Images
extension UIImage {
    func chooseDefaultBookImage() -> UIImage {
        guard let orangeBookImage = UIImage(named: "BetterReads-DefaultBookImage_Orange"),
            let greenBookImage = UIImage(named: "BetterReads-DefaultBookImage_Green"),
            let blueBookImage = UIImage(named: "BetterReads-DefaultBookImage_Blue") else {
                return UIImage()
        }
        let defaultBookImages = [orangeBookImage, greenBookImage, blueBookImage]
        guard let randomBookImage = defaultBookImages.randomElement() else { return orangeBookImage }
        return randomBookImage
    }
}

// Break down User's full name into first and last
extension Name: CustomStringConvertible {
    var description: String { return "\(first) \(last)" }
    init(fullName: String) {
        var names = fullName.components(separatedBy: " ")
        let first = names.removeFirst()
        let last = names.joined(separator: " ")
        self.init(first: first, last: last)
    }
}

// Notifications
extension NSNotification.Name {
    static let refreshMyLibrary = NSNotification.Name("refreshMyLibrary")
}

// String
extension String {

    /// Removes all random HTML tags that string could contain and returns a clean one
    func removeTags(_ string: String) -> String {
        var cleanString = string
        let tags = ["<br>", "<b>", "</b>", "{\"", "\"}", "<i>", "</i>", "<p>", "</p>"]
        for tag in tags {
            if tag == "<br>" {
                // tag was a break, add a new line
                cleanString = cleanString.replacingOccurrences(of: tag, with: "\n")
            } else {
                // any other case, replace tag with "remove" tag
                cleanString = cleanString.replacingOccurrences(of: tag, with: "")
            }
        }
        return cleanString
    }
}
