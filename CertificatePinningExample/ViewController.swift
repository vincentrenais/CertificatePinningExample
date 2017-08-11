import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!

    private var sessionManager: SessionManager?

    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://www.apple.com")!
        enableCertificatePinning()
        sessionManager?.request(url).responseData { result in
        if let data = result.data, let requestURL = result.request?.url {
            self.webView.load(data,
                              mimeType: result.response?.mimeType ?? "",
                              textEncodingName: result.response?.textEncodingName ?? "",
                              baseURL: requestURL)
            }
        }
    }

    private func enableCertificatePinning() {
        let certificates = getCertificates()
        let trustPolicy = ServerTrustPolicy.pinCertificates(
            certificates: certificates,
            validateCertificateChain: true,
            validateHost: true)
        let trustPolicies = [ "www.apple.com": trustPolicy ]
        let policyManager = ServerTrustPolicyManager(policies: trustPolicies)
        sessionManager = SessionManager(
            configuration: .default,
            serverTrustPolicyManager: policyManager
        )
    }

    private func getCertificates() -> [SecCertificate] {
        let url = Bundle.main.url(forResource: "appleCerts", withExtension: "cer")!
        let localCertificate = try! Data(contentsOf: url) as CFData
        guard let certificate = SecCertificateCreateWithData(nil, localCertificate)
            else { return [] }

        return [certificate]
    }
}
