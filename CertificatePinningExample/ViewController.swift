import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://www.apple.com")!
        Alamofire.request(url).responseData { result in
            if let data = result.data, let requestURL = result.request?.url {
                self.webView.load(data,
                                  mimeType: result.response?.mimeType ?? "",
                                  textEncodingName: result.response?.textEncodingName ?? "",
                                  baseURL: requestURL)
            }
        }
    }
}
