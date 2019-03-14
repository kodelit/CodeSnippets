# ClassBody: WebViewController
- **shortcut**: `classBody_WebViewController`
- **language**: Swift
- **platform**: 

## Summary
Basic implementation of WebViewController body

## Code:
```swift
    @IBOutlet weak var webView:WKWebView!
    var urlToLoad:URL? = nil

    override func loadView() {
        super.loadView()
        let config = WKWebViewConfiguration()
        if #available(iOS 10.0, *) {
            config.dataDetectorTypes = WKDataDetectorTypes.all
        }

        let webView = WKWebView(frame: self.view.bounds, configuration: config)
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(webView)
        self.webView = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.reload()
    }

    func reload() {
        if let url = self.urlToLoad {
            let request = URLRequest(url: url)
            self.webView.load(request)
        }
    }
```