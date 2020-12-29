import Combine
import Foundation

public struct MyCurrency: Decodable {
    public var success: Bool
    var timestamp: Int64 = 0
    public var timeStampDate: Date {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return date
    }

    public var base: String = ""
    public var date = Date.distantPast
    public var rates: [String: Double] = [:]
}

@available(OSX 10.15, *)
@available(iOS 13.0, *)
public final class ExchangeRateService {
    public static var shared = ExchangeRateService()
    private init() {}

    public static var accessKeyForFixerWebAPI: String? = "b8a607ac5119917e1a4d96f9d37b777d"

    private var cancellable: AnyCancellable?

    enum TestFailureCondition: Error {
        case invalidServerResponse
    }

    var task: URLSessionDataTask?
    private var currencySession = URLSession(configuration: .default)

    init(currencySession: URLSession) {
        self.currencySession = currencySession
    }

    static func getForUnitTests() -> ExchangeRateService {
        let service = ExchangeRateService()
        return service
    }

    static var cachedRates = [Int: Double]()

    static func getExchangeRateForTesting(from fromCurrency: Currency, to toCurrency: Currency) -> Double? {
        let from = Int(fromCurrency.rawValue)
        let to = Int(toCurrency.rawValue)
        let key = from * 1000 + to

        if let rate = cachedRates[key] {
            return rate
        }

        let rate = getExchangeRateForTesting(from: fromCurrency.name, to: toCurrency.name)
        cachedRates[key] = rate
        return rate
    }

    static func getExchangeRateForTesting(from fromCurrency: String, to toCurrency: String) -> Double? {
        let jsonText = ExchangeRateService.getTestJSONData()
        let myCurrency = ExchangeRateService.parseJSON(jsonText)

        if let from = myCurrency.rates[fromCurrency], let to = myCurrency.rates[toCurrency] {
            if from > 0, to > 0 {
                // 1EUR = (x) from; and 1EUR = (y) to; so if you have (z) from, then this is (z/x)EUR; and this is (y) to
                let rate = to / from
                return rate
            }
        }

        return nil
    }

    static func getURLRequestToGetLatestExchangeRates() throws -> URLRequest {
        var components = URLComponents(string: "https://data.fixer.io/api/latest")!
        components.queryItems = [
            URLQueryItem(name: "access_key", value: ExchangeRateService.accessKeyForFixerWebAPI),
        ]

        let url = components.url!

        return URLRequest(url: url)
    }

    static func getDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()

        let dateFormatterWithTime: DateFormatter = {
            let formatter = DateFormatter()

            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

            return formatter
        }()

        let dateFormatterWithoutTime: DateFormatter = {
            let formatter = DateFormatter()

            formatter.dateFormat = "yyyy-MM-dd"

            return formatter
        }()

        decoder.dateDecodingStrategy = .custom { (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)

            let len = dateStr.count

            var dateOrNil: Date?
            if len == 10 {
                dateOrNil = dateFormatterWithoutTime.date(from: dateStr)
            } else if len == 19 {
                dateOrNil = dateFormatterWithTime.date(from: dateStr)
            }
            guard let date = dateOrNil else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateStr)")
            }
            return date
        }

        return decoder
    }

    @available(OSX 10.15, *)
    public func getDataFromServer(_ closure: @escaping (MyCurrency?) -> Void) {
        let decoder = ExchangeRateService.getDecoder()

        guard let accessKeyForFixerWebAPI = Self.accessKeyForFixerWebAPI,
              let currencyExchangeServiceUrl = URL(string: "https://data.fixer.io/api/latest?access_key=" + accessKeyForFixerWebAPI) else {
            closure(nil)
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: currencyExchangeServiceUrl)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw TestFailureCondition.invalidServerResponse
                }
                // let jsonText = String(bytes: data, encoding: .utf8)
                return data
            }
            .decode(type: MyCurrency.self, decoder: decoder)
            .replaceError(with: MyCurrency(success: false))
            .sink(receiveValue: { closure($0) })
    }

    public static func getTestJSONData() -> String {
        let jsonText = """
        {"success":true,"timestamp":1605784750,"base":"EUR","date":"2020-11-19","rates":{"AED":4.342932,"AFN":91.211771,"ALL":123.657997,"AMD":589.790623,"ANG":2.127624,"AOA":785.901058,"ARS":94.704616,"AUD":1.628849,"AWG":2.128326,"AZN":1.979686,"BAM":1.952723,"BBD":2.39326,"BDT":100.514154,"BGN":1.955465,"BHD":0.445892,"BIF":2295.938861,"BMD":1.182403,"BND":1.58973,"BOB":8.173194,"BRL":6.341583,"BSD":1.185364,"BTC":6.6698979e-5,"BTN":87.942759,"BWP":13.141233,"BYN":3.023574,"BYR":23175.108042,"BZD":2.389267,"CAD":1.551136,"CDF":2324.604722,"CHF":1.079747,"CLF":0.03258,"CLP":898.950159,"CNY":7.788256,"COP":4308.087049,"CRC":723.597958,"CUC":1.182403,"CUP":31.333692,"CVE":110.089817,"CZK":26.386044,"DJF":211.015294,"DKK":7.449945,"DOP":68.132701,"DZD":152.051202,"EGP":18.44597,"ERN":17.73588,"ETB":45.231412,"EUR":1,"FJD":2.464424,"FKP":0.893494,"GBP":0.893619,"GEL":3.893531,"GGP":0.893494,"GHS":6.913698,"GIP":0.893494,"GMD":61.188749,"GNF":11635.389688,"GTQ":9.228215,"GYD":247.55607,"HKD":9.166719,"HNL":29.103458,"HRK":7.565133,"HTG":75.802813,"HUF":361.194653,"IDR":16831.336057,"ILS":3.960638,"IMP":0.893494,"INR":87.7918,"IQD":1415.118159,"IRR":49785.09863,"ISK":161.50432,"JEP":0.893494,"JMD":173.650332,"JOD":0.838295,"JPY":123.115373,"KES":129.319888,"KGS":100.246651,"KHR":4804.192688,"KMF":490.697589,"KPW":1064.240853,"KRW":1319.964208,"KWD":0.361555,"KYD":0.987728,"KZT":507.15298,"LAK":10988.414417,"LBP":1789.411006,"LKR":218.9441,"LRD":184.54366,"LSL":18.220775,"LTL":3.491329,"LVL":0.715224,"LYD":1.609271,"MAD":10.789421,"MDL":20.32865,"MGA":4643.524518,"MKD":61.517109,"MMK":1545.668755,"MNT":3363.061279,"MOP":9.465538,"MRO":422.118648,"MUR":47.118022,"MVR":18.212302,"MWK":901.786876,"MXN":24.099391,"MYR":4.848446,"MZN":87.309045,"NAD":18.221189,"NGN":450.739503,"NIO":41.309218,"NOK":10.722934,"NPR":140.702154,"NZD":1.718139,"OMR":0.454618,"PAB":1.185314,"PEN":4.222956,"PGK":4.215285,"PHP":57.12781,"PKR":187.824747,"PLN":4.47723,"PYG":8342.372224,"QAR":4.305057,"RON":4.873751,"RSD":117.55432,"RUB":90.428679,"RWF":1171.176811,"SAR":4.434382,"SBD":9.539389,"SCR":24.552449,"SDG":65.381769,"SEK":10.223664,"SGD":1.592148,"SHP":0.893494,"SLL":11818.122447,"SOS":686.976588,"SRD":16.735696,"STD":24868.198686,"SVC":10.371496,"SYP":606.446214,"SZL":18.227424,"THB":35.966366,"TJS":13.424438,"TMT":4.138412,"TND":3.243918,"TOP":2.71421,"TRY":9.017044,"TTD":8.061572,"TWD":33.726932,"TZS":2741.99333,"UAH":33.360504,"UGX":4403.692517,"USD":1.182403,"UYU":50.811146,"UZS":12281.706434,"VEF":11.80925,"VND":27405.156462,"VUV":132.477276,"WST":3.03527,"XAF":654.887202,"XAG":0.049439,"XAU":0.000635,"XCD":3.195504,"XDR":0.831641,"XOF":654.887202,"XPF":119.30806,"YER":296.071499,"ZAR":18.37313,"ZMK":10643.044261,"ZMW":24.814549,"ZWL":380.733848}}
        """

        return jsonText
    }

    public static func parseJSON(_ jsonText: String) -> MyCurrency {
        let decoder = getDecoder()

        let myCurrency: MyCurrency = try! decoder.decode(MyCurrency.self, from: Data(jsonText.utf8))

        return myCurrency
    }
}
