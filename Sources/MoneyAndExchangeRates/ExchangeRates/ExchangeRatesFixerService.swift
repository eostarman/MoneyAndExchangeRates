
import Foundation
import Combine

public final class ExchangeRatesFixerService {
    public static var shared = ExchangeRatesFixerService()

    public static var accessKeyForFixerWebAPI: String? = "b8a607ac5119917e1a4d96f9d37b777d"

    private var cancellable: AnyCancellable?

    enum TestFailureCondition: Error {
        case invalidServerResponse
    }

    var task: URLSessionDataTask?
    private var currencySession = URLSession(configuration: .default)

    init() {
        // this is only used for testing
    }

    init(currencySession: URLSession) {
        self.currencySession = currencySession
    }
    
    public static var cachedExchangeRatesFromFixer: ExchangeRatesFromFixer {
        parseJSON(cachedJSONData)
    }

    private static func getURLRequestToGetLatestExchangeRates() throws -> URLRequest {
        var components = URLComponents(string: "https://data.fixer.io/api/latest")!
        components.queryItems = [
            URLQueryItem(name: "access_key", value: ExchangeRatesFixerService.accessKeyForFixerWebAPI),
        ]

        let url = components.url!

        return URLRequest(url: url)
    }

    private static func getDecoder() -> JSONDecoder {
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

    public func getDataFromServer(_ closure: @escaping (ExchangeRatesFromFixer?) -> Void) {
        let decoder = ExchangeRatesFixerService.getDecoder()

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
            .decode(type: ExchangeRatesFromFixer.self, decoder: decoder)
            .replaceError(with: ExchangeRatesFromFixer(success: false))
            .sink(receiveValue: { closure($0) })
    }

    private static var cachedJSONData: String =
        """
        {"success":true,"timestamp":1610221866,"base":"USD","date":"2021-01-09","rates":{"AED":3.673204,"AFN":77.243354,"ALL":101.235174,"AMD":522.790403,"ANG":1.798773,"AOA":653.750403,"ARS":85.108875,"AUD":1.28866,"AWG":1.8,"AZN":1.70397,"BAM":1.599861,"BBD":2.023313,"BDT":84.933497,"BGN":1.598942,"BHD":0.377832,"BIF":1944.899796,"BMD":1,"BND":1.327117,"BOB":6.899468,"BRL":5.41546,"BSD":1.002127,"BTC":2.4550153e-5,"BTN":73.417342,"BWP":11.018241,"BYN":2.569898,"BYR":19600,"BZD":2.019959,"CAD":1.269865,"CDF":1970.000362,"CHF":0.885555,"CLF":0.025904,"CLP":714.782413,"CNY":6.475404,"COP":3497.341513,"CRC":615.190184,"CUC":1,"CUP":26.5,"CVE":90.196319,"CZK":21.41015,"DJF":178.396728,"DKK":6.08563,"DOP":58.352556,"DZD":132.184867,"EGP":15.733088,"ERN":15.000358,"ETB":39.489162,"EUR":0.817996,"FJD":2.01415,"FKP":0.737085,"GBP":0.737164,"GEL":3.310391,"GGP":0.737085,"GHS":5.872311,"GIP":0.737085,"GMD":51.703853,"GNF":10286.625767,"GTQ":7.808916,"GYD":209.775051,"HKD":7.76191,"HNL":24.148875,"HRK":6.195904,"HTG":73.26544,"HUF":294.160388,"IDR":14135.35,"ILS":3.18293,"IMP":0.737085,"INR":73.378404,"IQD":1463.075665,"IRR":42105.000352,"ISK":128.220386,"JEP":0.737085,"JMD":143.060941,"JOD":0.708704,"JPY":103.94804,"KES":109.780777,"KGS":83.077304,"KHR":4072.556237,"KMF":402.403796,"KPW":900.00001,"KRW":1093.010384,"KWD":0.30358,"KYD":0.835092,"KZT":420.269939,"LAK":9315.582822,"LBP":1515.173824,"LKR":188.395992,"LRD":167.050382,"LSL":15.310382,"LTL":2.95274,"LVL":0.60489,"LYD":4.441227,"MAD":8.839755,"MDL":17.151575,"MGA":3822.03681,"MKD":50.400818,"MMK":1330.296196,"MNT":2855.277471,"MOP":8.003354,"MRO":356.999828,"MUR":39.483027,"MVR":15.420378,"MWK":772.829448,"MXN":20.00935,"MYR":4.032504,"MZN":74.925039,"NAD":15.310377,"NGN":396.335378,"NIO":34.923517,"NOK":8.40676,"NPR":117.467485,"NZD":1.380358,"OMR":0.38497,"PAB":1.002127,"PEN":3.629611,"PGK":3.526217,"PHP":48.056442,"PKR":160.587566,"PLN":3.69175,"PYG":6872.474438,"QAR":3.641038,"RON":3.985604,"RSD":96.235038,"RUB":74.083604,"RWF":993.316973,"SAR":3.75177,"SBD":8.040664,"SCR":21.697342,"SDG":55.250372,"SEK":8.24409,"SGD":1.32592,"SHP":0.737085,"SLL":10205.000339,"SOS":583.000338,"SRD":14.154038,"STD":20834.863349,"SVC":8.768916,"SYP":512.822021,"SZL":15.257587,"THB":30.13037,"TJS":11.351329,"TMT":3.5,"TND":2.692504,"TOP":2.26425,"TRY":7.376204,"TTD":6.810634,"TWD":28.018038,"TZS":2323.885481,"UAH":28.331616,"UGX":3708.793456,"USD":1,"UYU":42.373824,"UZS":10482.03681,"VEF":9.987504,"VND":23115.746421,"VUV":107.502093,"WST":2.53162,"XAF":536.570143,"XAG":0.039319,"XAU":0.000541,"XCD":2.70255,"XDR":0.693333,"XOF":536.570143,"XPF":98.050364,"YER":250.403597,"ZAR":15.303445,"ZMK":9001.203593,"ZMW":21.267239,"ZWL":322.000186}}
        """

    private static func parseJSON(_ jsonText: String) -> ExchangeRatesFromFixer {
        let decoder = getDecoder()

        let myCurrency: ExchangeRatesFromFixer = try! decoder.decode(ExchangeRatesFromFixer.self, from: Data(jsonText.utf8))

        return myCurrency
    }
}
