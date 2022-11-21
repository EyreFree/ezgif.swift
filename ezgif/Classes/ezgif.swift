
import UIKit
import EFFoundation
import WebKit

public class Ezgif {
    
    public static let shared = Ezgif()
    
    private lazy var webView: WKWebView = {
        let tempView: WKWebView = WKWebView()
        return tempView
    }()
    
    /// ezgif.com/optimize.
    /// - Parameters:
    ///   - imageUrl: imageUrl.
    ///   - compressionLevel: compressionLevel for Lossy Gif, [5, 200].
    /// - Returns: the processed image url.
    public func optimize(imageUrl: String, compressionLevel: Int = 200, completion: ((String?, Error?) -> Void)?) {
        self.loadPageWithImageUrl(fileUrl: imageUrl)
        self.waitingOptimizeState { [weak self] result, error in
            guard let self = self else { return }
            if true == result {
                self.waitingSetCompressionLevel(value: compressionLevel) { [weak self] result, error in
                    guard let self = self else { return }
                    if true == result {
                        self.waitingPrimaryButtonClicked { [weak self] error in
                            guard let self = self else { return }
                            if let error = error {
                                printLog("waitingPrimaryButtonClicked: \(error.localizedDescription)")
                            } else {
                                self.waitingOutfileState { [weak self] result, error in
                                    guard let self = self else { return }
                                    if true == result {
                                        self.waitingGetOutfileUrl { [weak self] newFileUrl, error in
                                            guard let _ = self else { return }
                                            completion?(newFileUrl, error)
                                        }
                                    } else {
                                        printLog("waitingOptimizeState failed: \(error?.localizedDescription ?? "")")
                                    }
                                }
                            }
                        }
                    } else {
                        printLog("waitingOptimizeState failed: \(error?.localizedDescription ?? "")")
                    }
                }
            } else {
                printLog("waitingOptimizeState failed: \(error?.localizedDescription ?? "")")
            }
        }
    }
    
    private func loadPageWithImageUrl(fileUrl: String) {
        printLog("loadPageWithImageUrl")
        let encodeImageUrl: String = fileUrl.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? fileUrl
        if let optimizeUrl = URL(string: "https://ezgif.com/optimize?url=\(encodeImageUrl)") {
            printLog("loadPageWithImageUrl: \(optimizeUrl)")
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.webView.load(URLRequest(url: optimizeUrl))
            }
        }
    }
    
    private func waitingOptimizeState(completion: ((Bool, Error?) -> Void)?) {
        printLog("waitingOptimizeState")
        let javascript: String = "document.getElementsByName('lossy').length == 1 && document.getElementsByClassName('button primary').length == 1"
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.webView.evaluateJavaScript(javascript) { [weak self] data, error in
                guard let self = self else { return }
                if let error = error {
                    completion?(false, error)
                } else if let result = data as? Bool, result == true {
                    completion?(true, nil)
                } else {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.05) { [weak self] in
                        guard let self = self else { return }
                        self.waitingOptimizeState(completion: completion)
                    }
                }
            }
        }
    }
    
    private func waitingSetCompressionLevel(value: Int = 200, completion: ((Bool, Error?) -> Void)?) {
        printLog("waitingSetCompressionLevel")
        let javascript: String = "document.getElementsByName('lossy')[0].value = \(value)"
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.webView.evaluateJavaScript(javascript) { [weak self] data, error in
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
    
    private func waitingPrimaryButtonClicked(completion: ((Error?) -> Void)?) {
        printLog("waitingPrimaryButtonClicked")
        let javascript: String = "document.getElementsByClassName('button primary')[0].click();"
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.webView.evaluateJavaScript(javascript) { [weak self] data, error in
                guard let _ = self else { return }
                completion?(error)
            }
        }
    }
    
    private func waitingOutfileState(completion: ((Bool, Error?) -> Void)?) {
        printLog("waitingOutfileState")
        let javascript: String = "document.getElementsByClassName('outfile').length == 1 && document.getElementsByClassName('outfile')[0].children.length == 1"
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.webView.evaluateJavaScript(javascript) { [weak self] data, error in
                guard let self = self else { return }
                if let error = error {
                    completion?(false, error)
                } else if let result = data as? Bool, result == true {
                    completion?(true, nil)
                } else {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.05) { [weak self] in
                        guard let self = self else { return }
                        self.waitingOutfileState(completion: completion)
                    }
                }
            }
        }
    }
    
    private func waitingGetOutfileUrl(completion: ((String?, Error?) -> Void)?) {
        printLog("waitingGetOutfileUrl")
        let javascript: String = "document.getElementsByClassName('outfile')[0].children[0].src"
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.webView.evaluateJavaScript(javascript) { [weak self] data, error in
                guard let _ = self else { return }
                if let error = error {
                    completion?(nil, error)
                } else if let fileUrl = data as? String, fileUrl.isEmpty == false {
                    completion?(fileUrl, nil)
                } else {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.05) { [weak self] in
                        guard let self = self else { return }
                        self.waitingGetOutfileUrl(completion: completion)
                    }
                }
            }
        }
    }
}
