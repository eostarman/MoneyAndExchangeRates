//
//  File.swift
//
//
//  Created by Michael Rutherford on 7/10/20.
//
// wikipedia: https://en.wikipedia.org/wiki/Currency_symbol
// currency encyclopedia: https://www.xe.com/currency/
//
// https://en.wikipedia.org/w/index.php?title=ISO_4217&action=edit&section=7
// https://pkgstore.datahub.io/JohnSnowLabs/iso-4217-currency-codes/iso-4217-currency-codes-csv_csv/data/6480fc9d61dddc34064ba5002e856798/iso-4217-currency-codes-csv_csv.csv

import Foundation

public enum Currency: Int16, CaseIterable, Codable {
    case AFN = 971 // Afghani (minor=2)
    case DZD = 012 // Algerian Dinar (minor=2)
    case ARS = 032 // Argentine Peso (minor=2)
    case AMD = 051 // Armenian Dram (minor=2)
    case AWG = 533 // Aruban Florin (minor=2)
    case AUD = 036 // Australian Dollar (minor=2)
    case AZN = 944 // Azerbaijan Manat (minor=2)
    case BSD = 044 // Bahamian Dollar (minor=2)
    case BHD = 048 // Bahraini Dinar (minor=3)
    case THB = 764 // Baht (minor=2)
    case PAB = 590 // Balboa (minor=2)
    case BBD = 052 // Barbados Dollar (minor=2)
    case BYN = 933 // Belarusian Ruble (minor=2)
    case BZD = 084 // Belize Dollar (minor=2)
    case BMD = 060 // Bermudian Dollar (minor=2)
    case VEF = 937 // BolÃ­var (minor=2)
    case BOB = 068 // Boliviano (minor=2)
    case BRL = 986 // Brazilian Real (minor=2)
    case BND = 096 // Brunei Dollar (minor=2)
    case BGN = 975 // Bulgarian Lev (minor=2)
    case BIF = 108 // Burundi Franc (minor=0)
    case CVE = 132 // Cabo Verde Escudo (minor=2)
    case CAD = 124 // Canadian Dollar (minor=2)
    case KYD = 136 // Cayman Islands Dollar (minor=2)
    case XOF = 952 // CFA Franc BCEAO (minor=0)
    case XAF = 950 // CFA Franc BEAC (minor=0)
    case XPF = 953 // CFP Franc (minor=0)
    case CLP = 152 // Chilean Peso (minor=0)
    case COP = 170 // Colombian Peso (minor=2)
    case KMF = 174 // Comorian Franc (minor=0)
    case CDF = 976 // Congolese Franc (minor=2)
    case BAM = 977 // Convertible Mark (minor=2)
    case NIO = 558 // Cordoba Oro (minor=2)
    case CRC = 188 // Costa Rican Colon (minor=2)
    case CUP = 192 // Cuban Peso (minor=2)
    case CZK = 203 // Czech Koruna (minor=2)
    case GMD = 270 // Dalasi (minor=2)
    case DKK = 208 // Danish Krone (minor=2)
    case MKD = 807 // Denar (minor=2)
    case DJF = 262 // Djibouti Franc (minor=0)
    case STD = 678 // Dobra (minor=2)
    case DOP = 214 // Dominican Peso (minor=2)
    case VND = 704 // Dong (minor=0)
    case XCD = 951 // East Caribbean Dollar (minor=2)
    case EGP = 818 // Egyptian Pound (minor=2)
    case SVC = 222 // El Salvador Colon (minor=2)
    case ETB = 230 // Ethiopian Birr (minor=2)
    case EUR = 978 // Euro (minor=2)
    case FKP = 238 // Falkland Islands Pound (minor=2)
    case FJD = 242 // Fiji Dollar (minor=2)
    case HUF = 348 // Forint (minor=2)
    case GHS = 936 // Ghana Cedi (minor=2)
    case GIP = 292 // Gibraltar Pound (minor=2)
    case HTG = 332 // Gourde (minor=2)
    case PYG = 600 // Guarani (minor=0)
    case GNF = 324 // Guinean Franc (minor=0)
    case GYD = 328 // Guyana Dollar (minor=2)
    case HKD = 344 // Hong Kong Dollar (minor=2)
    case UAH = 980 // Hryvnia (minor=2)
    case ISK = 352 // Iceland Krona (minor=0)
    case INR = 356 // Indian Rupee (minor=2)
    case IRR = 364 // Iranian Rial (minor=2)
    case IQD = 368 // Iraqi Dinar (minor=3)
    case JMD = 388 // Jamaican Dollar (minor=2)
    case JOD = 400 // Jordanian Dinar (minor=3)
    case KES = 404 // Kenyan Shilling (minor=2)
    case PGK = 598 // Kina (minor=2)
    case HRK = 191 // Kuna (minor=2)
    case KWD = 414 // Kuwaiti Dinar (minor=3)
    case AOA = 973 // Kwanza (minor=2)
    case MMK = 104 // Kyat (minor=2)
    case LAK = 418 // Lao Kip (minor=2)
    case GEL = 981 // Lari (minor=2)
    case LBP = 422 // Lebanese Pound (minor=2)
    case ALL = 008 // Lek (minor=2)
    case HNL = 340 // Lempira (minor=2)
    case SLL = 694 // Leone (minor=2)
    case LRD = 430 // Liberian Dollar (minor=2)
    case LYD = 434 // Libyan Dinar (minor=3)
    case SZL = 748 // Lilangeni (minor=2)
    case LSL = 426 // Loti (minor=2)
    case MGA = 969 // Malagasy Ariary (minor=2)
    case MWK = 454 // Malawi Kwacha (minor=2)
    case MYR = 458 // Malaysian Ringgit (minor=2)
    case MUR = 480 // Mauritius Rupee (minor=2)
    case MXN = 484 // Mexican Peso (minor=2)
    case MXV = 979 // Mexican Unidad de Inversion (UDI) (minor=2)
    case MDL = 498 // Moldovan Leu (minor=2)
    case MAD = 504 // Moroccan Dirham (minor=2)
    case MZN = 943 // Mozambique Metical (minor=2)
    case BOV = 984 // Mvdol (minor=2)
    case NGN = 566 // Naira (minor=2)
    case ERN = 232 // Nakfa (minor=2)
    case NAD = 516 // Namibia Dollar (minor=2)
    case NPR = 524 // Nepalese Rupee (minor=2)
    case ANG = 532 // Netherlands Antillean Guilder (minor=2)
    case ILS = 376 // New Israeli Sheqel (minor=2)
    case TWD = 901 // New Taiwan Dollar (minor=2)
    case NZD = 554 // New Zealand Dollar (minor=2)
    case BTN = 064 // Ngultrum (minor=2)
    case KPW = 408 // North Korean Won (minor=2)
    case NOK = 578 // Norwegian Krone (minor=2)
    case MRO = 478 // Ouguiya (minor=2)
    case TOP = 776 // Paâ€™anga (minor=2)
    case PKR = 586 // Pakistan Rupee (minor=2)
    case MOP = 446 // Pataca (minor=2)
    case CUC = 931 // Peso Convertible (minor=2)
    case UYU = 858 // Peso Uruguayo (minor=2)
    case PHP = 608 // Philippine Piso (minor=2)
    case GBP = 826 // Pound Sterling (minor=2)
    case BWP = 072 // Pula (minor=2)
    case QAR = 634 // Qatari Rial (minor=2)
    case GTQ = 320 // Quetzal (minor=2)
    case ZAR = 710 // Rand (minor=2)
    case OMR = 512 // Rial Omani (minor=3)
    case KHR = 116 // Riel (minor=2)
    case RON = 946 // Romanian Leu (minor=2)
    case MVR = 462 // Rufiyaa (minor=2)
    case IDR = 360 // Rupiah (minor=2)
    case RUB = 643 // Russian Ruble (minor=2)
    case RWF = 646 // Rwanda Franc (minor=0)
    case SHP = 654 // Saint Helena Pound (minor=2)
    case SAR = 682 // Saudi Riyal (minor=2)
    case RSD = 941 // Serbian Dinar (minor=2)
    case SCR = 690 // Seychelles Rupee (minor=2)
    case SGD = 702 // Singapore Dollar (minor=2)
    case PEN = 604 // Sol (minor=2)
    case SBD = 090 // Solomon Islands Dollar (minor=2)
    case KGS = 417 // Som (minor=2)
    case SOS = 706 // Somali Shilling (minor=2)
    case TJS = 972 // Somoni (minor=2)
    case SSP = 728 // South Sudanese Pound (minor=2)
    case LKR = 144 // Sri Lanka Rupee (minor=2)
    case SDG = 938 // Sudanese Pound (minor=2)
    case SRD = 968 // Surinam Dollar (minor=2)
    case SEK = 752 // Swedish Krona (minor=2)
    case CHF = 756 // Swiss Franc (minor=2)
    case SYP = 760 // Syrian Pound (minor=2)
    case BDT = 050 // Taka (minor=2)
    case WST = 882 // Tala (minor=2)
    case TZS = 834 // Tanzanian Shilling (minor=2)
    case KZT = 398 // Tenge (minor=2)
    case TTD = 780 // Trinidad and Tobago Dollar (minor=2)
    case MNT = 496 // Tugrik (minor=2)
    case TND = 788 // Tunisian Dinar (minor=3)
    case TRY = 949 // Turkish Lira (minor=2)
    case TMT = 934 // Turkmenistan New Manat (minor=2)
    case AED = 784 // UAE Dirham (minor=2)
    case UGX = 800 // Uganda Shilling (minor=0)
    case CLF = 990 // Unidad de Fomento (minor=4)
    case COU = 970 // Unidad de Valor Real (minor=2)
    case UYI = 940 // Uruguay Peso en Unidades Indexadas (URUIURUI) (minor=0)
    case USN = 997 // US Dollar (Next day) (minor=2)
    case USD = 840 // US Dollar (minor=2)
    case UZS = 860 // Uzbekistan Sum (minor=2)
    case VUV = 548 // Vatu (minor=0)
    case CHE = 947 // WIR Euro (minor=2)
    case CHW = 948 // WIR Franc (minor=2)
    case KRW = 410 // Won (minor=0)
    case YER = 886 // Yemeni Rial (minor=2)
    case JPY = 392 // Yen (minor=0)
    case CNY = 156 // Yuan Renminbi (minor=2)
    case ZMW = 967 // Zambian Kwacha (minor=2)
    case ZWL = 932 // Zimbabwe Dollar (minor=2)
    case PLN = 985 // Zloty (minor=2)

    public var symbol: String { Self.getSymbolForCurrencyCode(currencyCode: name) }

    public var currencyNid: Int { Int(rawValue) }

    public var numberOfDecimals: Int {
        switch self {
        case .BIF, .CLP, .DJF, .GNF, .ISK, .JPY, .KMF, .KRW, .PYG, .RWF, .UGX, .UYI, .VND, .VUV, .XAF, .XOF, .XPF:
            return 0

            //            case .AED, .AFN, .ALL, .AMD, .ANG, .AOA, .ARS, .AUD, .AWG, .AZN, .BAM, .BBD, .BDT, .BGN, .BMD, .BND, .BOB,
            //                 .BOV, .BRL, .BSD, .BTN, .BWP, .BYN, .BZD, .CAD, .CDF, .CHE, .CHF, .CHW, .CNY, .COP, .COU, .CRC, .CUC,
            //                 .CUP, .CVE, .CZK, .DKK, .DOP, .DZD, .EGP, .ERN, .ETB, .EUR, .FJD, .FKP, .GBP, .GEL, .GHS, .GIP, .GMD,
            //                 .GTQ, .GYD, .HKD, .HNL, .HRK, .HTG, .HUF, .IDR, .ILS, .INR, .IRR, .JMD, .KES, .KGS, .KHR, .KPW, .KYD,
            //                 .KZT, .LAK, .LBP, .LKR, .LRD, .LSL, .MAD, .MDL, .MGA, .MKD, .MMK, .MNT, .MOP, .MRO, .MUR, .MVR, .MWK,
            //                 .MXN, .MXV, .MYR, .MZN, .NAD, .NGN, .NIO, .NOK, .NPR, .NZD, .PAB, .PEN, .PGK, .PHP, .PKR, .PLN, .QAR,
            //                 .RON, .RSD, .RUB, .SAR, .SBD, .SCR, .SDG, .SEK, .SGD, .SHP, .SLL, .SOS, .SRD, .SSP, .STD, .SVC, .SYP,
            //                 .SZL, .THB, .TJS, .TMT, .TOP, .TRY, .TTD, .TWD, .TZS, .UAH, .USD, .USN, .UYU, .UZS, .VEF, .WST, .XCD,
            //                 .YER, .ZAR, .ZMW, .ZWL:
            //                return 2

        case .BHD, .IQD, .JOD, .KWD, .LYD, .OMR, .TND:
            return 3

        case .CLF:
            return 4

        default:
            return 2
        }
    }
}

public extension Currency {
    init?(currencyNid: Int?) {
        self.init(rawValue: Int16(currencyNid ?? 0)) // 0 isn't a valid currency code, so this'll return nil
    }

    func amount(_ amount: Double) -> Money {
        Money(amount, self)
    }

    func amount(_ amount: Double, numberOfDecimals: Int) -> Money {
        Money(amount, self, numberOfDecimals: numberOfDecimals)
    }

    func amount(_ amount: Decimal) -> Money {
        Money(amount, self)
    }

    func amount(_ amount: Decimal, numberOfDecimals: Int) -> Money {
        Money(amount, self, numberOfDecimals: numberOfDecimals)
    }

    var zero: Money {
        Money(currency: self)
    }
}

extension Currency {
    public var name: String {
        "\(self)" // "USD", "EUR" ...
    }

    public var description: String {
        switch self {
        case .AFN: return "Afghani"
        case .DZD: return "Algerian Dinar"
        case .ARS: return "Argentine Peso"
        case .AMD: return "Armenian Dram"
        case .AWG: return "Aruban Florin"
        case .AUD: return "Australian Dollar"
        case .AZN: return "Azerbaijan Manat"
        case .BSD: return "Bahamian Dollar"
        case .BHD: return "Bahraini Dinar"
        case .THB: return "Baht"
        case .PAB: return "Balboa"
        case .BBD: return "Barbados Dollar"
        case .BYN: return "Belarusian Ruble"
        case .BZD: return "Belize Dollar"
        case .BMD: return "Bermudian Dollar"
        case .VEF: return "BolÃ­var"
        case .BOB: return "Boliviano"
        case .BRL: return "Brazilian Real"
        case .BND: return "Brunei Dollar"
        case .BGN: return "Bulgarian Lev"
        case .BIF: return "Burundi Franc"
        case .CVE: return "Cabo Verde Escudo"
        case .CAD: return "Canadian Dollar"
        case .KYD: return "Cayman Islands Dollar"
        case .XOF: return "CFA Franc BCEAO"
        case .XAF: return "CFA Franc BEAC"
        case .XPF: return "CFP Franc"
        case .CLP: return "Chilean Peso"
        case .COP: return "Colombian Peso"
        case .KMF: return "Comorian Franc"
        case .CDF: return "Congolese Franc"
        case .BAM: return "Convertible Mark"
        case .NIO: return "Cordoba Oro"
        case .CRC: return "Costa Rican Colon"
        case .CUP: return "Cuban Peso"
        case .CZK: return "Czech Koruna"
        case .GMD: return "Dalasi"
        case .DKK: return "Danish Krone"
        case .MKD: return "Denar"
        case .DJF: return "Djibouti Franc"
        case .STD: return "Dobra"
        case .DOP: return "Dominican Peso"
        case .VND: return "Dong"
        case .XCD: return "East Caribbean Dollar"
        case .EGP: return "Egyptian Pound"
        case .SVC: return "El Salvador Colon"
        case .ETB: return "Ethiopian Birr"
        case .EUR: return "Euro"
        case .FKP: return "Falkland Islands Pound"
        case .FJD: return "Fiji Dollar"
        case .HUF: return "Forint"
        case .GHS: return "Ghana Cedi"
        case .GIP: return "Gibraltar Pound"
        case .HTG: return "Gourde"
        case .PYG: return "Guarani"
        case .GNF: return "Guinean Franc"
        case .GYD: return "Guyana Dollar"
        case .HKD: return "Hong Kong Dollar"
        case .UAH: return "Hryvnia"
        case .ISK: return "Iceland Krona"
        case .INR: return "Indian Rupee"
        case .IRR: return "Iranian Rial"
        case .IQD: return "Iraqi Dinar"
        case .JMD: return "Jamaican Dollar"
        case .JOD: return "Jordanian Dinar"
        case .KES: return "Kenyan Shilling"
        case .PGK: return "Kina"
        case .HRK: return "Kuna"
        case .KWD: return "Kuwaiti Dinar"
        case .AOA: return "Kwanza"
        case .MMK: return "Kyat"
        case .LAK: return "Lao Kip"
        case .GEL: return "Lari"
        case .LBP: return "Lebanese Pound"
        case .ALL: return "Lek"
        case .HNL: return "Lempira"
        case .SLL: return "Leone"
        case .LRD: return "Liberian Dollar"
        case .LYD: return "Libyan Dinar"
        case .SZL: return "Lilangeni"
        case .LSL: return "Loti"
        case .MGA: return "Malagasy Ariary"
        case .MWK: return "Malawi Kwacha"
        case .MYR: return "Malaysian Ringgit"
        case .MUR: return "Mauritius Rupee"
        case .MXN: return "Mexican Peso"
        case .MXV: return "Mexican Unidad de Inversion (UDI)"
        case .MDL: return "Moldovan Leu"
        case .MAD: return "Moroccan Dirham"
        case .MZN: return "Mozambique Metical"
        case .BOV: return "Mvdol"
        case .NGN: return "Naira"
        case .ERN: return "Nakfa"
        case .NAD: return "Namibia Dollar"
        case .NPR: return "Nepalese Rupee"
        case .ANG: return "Netherlands Antillean Guilder"
        case .ILS: return "New Israeli Sheqel"
        case .TWD: return "New Taiwan Dollar"
        case .NZD: return "New Zealand Dollar"
        case .BTN: return "Ngultrum"
        case .KPW: return "North Korean Won"
        case .NOK: return "Norwegian Krone"
        case .MRO: return "Ouguiya"
        case .TOP: return "Paâ€™anga"
        case .PKR: return "Pakistan Rupee"
        case .MOP: return "Pataca"
        case .CUC: return "Peso Convertible"
        case .UYU: return "Peso Uruguayo"
        case .PHP: return "Philippine Piso"
        case .GBP: return "Pound Sterling"
        case .BWP: return "Pula"
        case .QAR: return "Qatari Rial"
        case .GTQ: return "Quetzal"
        case .ZAR: return "Rand"
        case .OMR: return "Rial Omani"
        case .KHR: return "Riel"
        case .RON: return "Romanian Leu"
        case .MVR: return "Rufiyaa"
        case .IDR: return "Rupiah"
        case .RUB: return "Russian Ruble"
        case .RWF: return "Rwanda Franc"
        case .SHP: return "Saint Helena Pound"
        case .SAR: return "Saudi Riyal"
        case .RSD: return "Serbian Dinar"
        case .SCR: return "Seychelles Rupee"
        case .SGD: return "Singapore Dollar"
        case .PEN: return "Sol"
        case .SBD: return "Solomon Islands Dollar"
        case .KGS: return "Som"
        case .SOS: return "Somali Shilling"
        case .TJS: return "Somoni"
        case .SSP: return "South Sudanese Pound"
        case .LKR: return "Sri Lanka Rupee"
        case .SDG: return "Sudanese Pound"
        case .SRD: return "Surinam Dollar"
        case .SEK: return "Swedish Krona"
        case .CHF: return "Swiss Franc"
        case .SYP: return "Syrian Pound"
        case .BDT: return "Taka"
        case .WST: return "Tala"
        case .TZS: return "Tanzanian Shilling"
        case .KZT: return "Tenge"
        case .TTD: return "Trinidad and Tobago Dollar"
        case .MNT: return "Tugrik"
        case .TND: return "Tunisian Dinar"
        case .TRY: return "Turkish Lira"
        case .TMT: return "Turkmenistan New Manat"
        case .AED: return "UAE Dirham"
        case .UGX: return "Uganda Shilling"
        case .CLF: return "Unidad de Fomento"
        case .COU: return "Unidad de Valor Real"
        case .UYI: return "Uruguay Peso en Unidades Indexadas (URUIURUI)"
        case .USN: return "US Dollar (Next day)"
        case .USD: return "US Dollar"
        case .UZS: return "Uzbekistan Sum"
        case .VUV: return "Vatu"
        case .CHE: return "WIR Euro"
        case .CHW: return "WIR Franc"
        case .KRW: return "Won"
        case .YER: return "Yemeni Rial"
        case .JPY: return "Yen"
        case .CNY: return "Yuan Renminbi"
        case .ZMW: return "Zambian Kwacha"
        case .ZWL: return "Zimbabwe Dollar"
        case .PLN: return "Zloty"
        }
    }
}

extension Currency {
    // https://stackoverflow.com/questions/31999748/get-currency-symbols-from-currency-code-with-swift

    private static var cachedSymbolsByName: [String: String] = [:]

    static let genericCurrencySymbol: String = "¤" // generic currency sign from https://en.wikipedia.org/wiki/Currency_symbol

    private static func getSymbolForCurrencyCode(currencyCode: String) -> String {
        if let cachedSymbol = cachedSymbolsByName[currencyCode] {
            return cachedSymbol
        }

        var candidates: [String] = []
        let locales: [String] = NSLocale.availableLocaleIdentifiers
        for localeID in locales {
            guard let symbol = findMatchingSymbol(localeID: localeID, currencyCode: currencyCode) else {
                continue
            }
            if symbol.count == 1 {
                cachedSymbolsByName[currencyCode] = symbol
                return symbol
            }
            candidates.append(symbol)
        }

        let sorted = sortAscByLength(list: candidates)
        if let symbol = sorted.first {
            cachedSymbolsByName[currencyCode] = symbol
            return symbol
        }
        cachedSymbolsByName[currencyCode] = genericCurrencySymbol
        return genericCurrencySymbol
    }

    private static func findMatchingSymbol(localeID: String, currencyCode: String) -> String? {
        let locale = Locale(identifier: localeID as String)
        guard let code = locale.currencyCode else {
            return nil
        }
        if code != currencyCode {
            return nil
        }
        return locale.currencySymbol
    }

    private static func sortAscByLength(list: [String]) -> [String] {
        return list.sorted(by: { $0.count < $1.count })
    }
}
