
import UIKit
import EFFoundation
import WebKit

public class Ezgif {
    
    public static let shared: Ezgif = Ezgif()
    
    private static var dictionary: [String: WKWebView] = [:]
    
    public init() {
        
    }
    
    private func getWebViewWith(tag: String, createIfNeeded: Bool) -> WKWebView? {
        if let webView = Ezgif.dictionary[tag] {
            return webView
        } else if createIfNeeded {
            let tempView: WKWebView = WKWebView()
            tempView.isHidden = false
            setWebViewWith(tag: tag, webView: tempView)
            return tempView
        }
        return nil
    }
    
    private func removeWebViewWith(tag: String) {
        setWebViewWith(tag: tag, webView: nil)
    }
    
    private func setWebViewWith(tag: String, webView: WKWebView?) {
        if let webView = webView {
            Ezgif.dictionary[tag] = webView
        } else {
            Ezgif.dictionary.removeValue(forKey: tag)
        }
    }
    
    /// ezgif.com/optimize.
    /// - Parameters:
    ///   - imageUrl: imageUrl.
    ///   - compressionLevel: compressionLevel for Lossy Gif, [5, 200].
    /// - Returns: the processed image url.
    public func optimize(imageUrl: String, compressionLevel: Int = 200, completion: ((String?, Error?) -> Void)?) {
        let webViewTag: String = "\(Date().timeIntervalSince1970)"
        guard let webView: WKWebView = getWebViewWith(tag: webViewTag, createIfNeeded: true) else {
            completion?(nil, nil)
            return
        }
        func customCompletion(_ urlString: String?, _ error: Error?) {
            removeWebViewWith(tag: webViewTag)
            completion?(urlString, error)
        }
        self.loadPageWithImageUrl(webView: webView, fileUrl: imageUrl)
        self.waitingOptimizeState(webView: webView) { [weak self] result, error in
            guard let self = self else { return }
            if true == result {
                self.waitingSetCompressionLevel(webView: webView, value: compressionLevel) { [weak self] result, error in
                    guard let self = self else { return }
                    if true == result {
                        self.waitingPrimaryButtonClicked(webView: webView) { [weak self] error in
                            guard let self = self else { return }
                            if let error = error {
                                printLog("waitingPrimaryButtonClicked: \(error.localizedDescription)")
                                customCompletion(nil, error)
                            } else {
                                self.waitingOutfileState(webView: webView) { [weak self] result, error in
                                    guard let self = self else { return }
                                    if true == result {
                                        self.waitingGetOutfileUrl(webView: webView) { [weak self] newFileUrl, error in
                                            guard let _ = self else { return }
                                            customCompletion(newFileUrl, error)
                                        }
                                    } else {
                                        printLog("waitingOptimizeState failed: \(error?.localizedDescription ?? "")")
                                        customCompletion(nil, error)
                                    }
                                }
                            }
                        }
                    } else {
                        printLog("waitingOptimizeState failed: \(error?.localizedDescription ?? "")")
                        customCompletion(nil, error)
                    }
                }
            } else {
                printLog("waitingOptimizeState failed: \(error?.localizedDescription ?? "")")
                customCompletion(nil, error)
            }
        }
    }
    
    private func loadPageWithImageUrl(webView: WKWebView, fileUrl: String) {
        printLog("loadPageWithImageUrl")
        let encodeImageUrl: String = fileUrl.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? fileUrl
        if let optimizeUrl = URL(string: "https://ezgif.com/optimize?url=\(encodeImageUrl)") {
            printLog("loadPageWithImageUrl: \(optimizeUrl)")
            DispatchQueue.main.async { [weak self] in
                guard let _ = self else { return }
                webView.load(URLRequest(url: optimizeUrl))
            }
        }
    }
    
    private func waitingOptimizeState(webView: WKWebView, completion: ((Bool, Error?) -> Void)?) {
        printLog("waitingOptimizeState")
        let javascript: String = "document.getElementsByName('lossy').length == 1 && document.getElementsByClassName('button primary').length == 1"
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            webView.evaluateJavaScript(javascript) { [weak self] data, error in
                guard let self = self else { return }
                if let error = error {
                    completion?(false, error)
                } else if let result = data as? Bool, result == true {
                    completion?(true, nil)
                } else {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.05) { [weak self] in
                        guard let self = self else { return }
                        self.waitingOptimizeState(webView: webView, completion: completion)
                    }
                }
            }
        }
    }
    
    private func waitingSetCompressionLevel(webView: WKWebView, value: Int = 200, completion: ((Bool, Error?) -> Void)?) {
        printLog("waitingSetCompressionLevel")
        let javascript: String = "document.getElementsByName('lossy')[0].value = \(value)"
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            webView.evaluateJavaScript(javascript) { [weak self] data, error in
                guard let _ = self else { return }
                if let error = error {
                    completion?(false, error)
                } else if let result = data as? Int, result == value {
                    completion?(true, nil)
                } else {
                    completion?(false, nil)
                }
            }
        }
    }
    
    private func waitingPrimaryButtonClicked(webView: WKWebView, completion: ((Error?) -> Void)?) {
        printLog("waitingPrimaryButtonClicked")
        let javascript: String = "document.getElementsByClassName('button primary')[0].click();"
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            webView.evaluateJavaScript(javascript) { [weak self] data, error in
                guard let _ = self else { return }
                completion?(error)
            }
        }
    }
    
    private func waitingOutfileState(webView: WKWebView, completion: ((Bool, Error?) -> Void)?) {
        printLog("waitingOutfileState")
        let javascript: String = "document.getElementsByClassName('outfile').length == 1 && document.getElementsByClassName('outfile')[0].children.length == 1"
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            webView.evaluateJavaScript(javascript) { [weak self] data, error in
                guard let self = self else { return }
                if let error = error {
                    completion?(false, error)
                } else if let result = data as? Bool, result == true {
                    completion?(true, nil)
                } else {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.05) { [weak self] in
                        guard let self = self else { return }
                        self.waitingOutfileState(webView: webView, completion: completion)
                    }
                }
            }
        }
    }
    
    private func waitingGetOutfileUrl(webView: WKWebView, completion: ((String?, Error?) -> Void)?) {
        printLog("waitingGetOutfileUrl")
        let javascript: String = "document.getElementsByClassName('outfile')[0].children[0].src"
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            webView.evaluateJavaScript(javascript) { [weak self] data, error in
                guard let _ = self else { return }
                if let error = error {
                    completion?(nil, error)
                } else if let fileUrl = data as? String, fileUrl.isEmpty == false {
                    completion?(fileUrl, nil)
                } else {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.05) { [weak self] in
                        guard let self = self else { return }
                        self.waitingGetOutfileUrl(webView: webView, completion: completion)
                    }
                }
            }
        }
    }
}
