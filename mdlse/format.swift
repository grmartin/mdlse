//
// Created by Glenn Martin on 6/9/17.
// Copyright (c) 2017 Glenn R. Martin. All rights reserved.
//

import Foundation

enum OutputFormat: Int {
    case
            PLIST = 0,
            JSON

    public static var DEFAULT: OutputFormat {
        return .PLIST
    }

    static func parse(_ val: String?) -> OutputFormat {
        let value : String! = val.toConstantComparison()

        var out : OutputFormat = .DEFAULT

        if (value.isNullOrEmpty()) { return out }

        let char : Character = value[0]

        switch char {
            case "p": out = .PLIST
            case "j": out = .JSON
            default: break
        }

        return out
    }
}

struct DateFormat : OptionSet {
    let rawValue: Int

    fileprivate static let FLAG_ISOFMT  = DateFormat(rawValue: 1 << 0)
    fileprivate static let FLAG_LOCALTZ = DateFormat(rawValue: 1 << 1)

    static let ISO8601C_LOCAL: DateFormat = [.FLAG_ISOFMT, .FLAG_LOCALTZ]
    static let ISO8601C_ZULU: DateFormat = [.FLAG_ISOFMT]
    static let EPOCH_LOCAL: DateFormat = [.FLAG_LOCALTZ]
    static let EPOCH_ZULU: DateFormat = []

    public static var DEFAULT: DateFormat {
        return .EPOCH_ZULU
    }

    fileprivate static func parseNillable(_ val: String?) -> DateFormat? {
        let value: String! = val.toConstantComparison()

        var out: DateFormat? = nil

        if (value.isNullOrEmpty()) { return out }

        switch value {
            case "epoch": out = .EPOCH_LOCAL
            case "iso": out = .ISO8601C_LOCAL
            case "epochz": out = .EPOCH_ZULU
            case "isoz": out = .ISO8601C_ZULU
            default: break
        }

        return out
    }

    static func isValidValue(_ val: String?) -> Bool {
        return parseNillable(val) != nil
    }

    static func parse(_ val: String?) -> DateFormat {
        let out: DateFormat? = parseNillable(val)

        return out != nil ? out! : .DEFAULT
    }

    public func converter() -> ((_ x: Date?) -> String?) {
        switch self {
            case DateFormat.ISO8601C_LOCAL:
                return IsoDates.isoDateLocal
            case DateFormat.ISO8601C_ZULU:
                return IsoDates.isoDateZulu
            case DateFormat.EPOCH_LOCAL:
                return EpochDates.epochLocal
            case DateFormat.EPOCH_ZULU:
                return EpochDates.epochZulu
            default:
                return DateFormat.DEFAULT.converter()
        }
    }

    public func isLocal() -> Bool {
        return self.contains(.FLAG_LOCALTZ)
    }

    public func isZulu() -> Bool {
        return !isLocal()
    }

    public func isISOCombined() -> Bool {
        return self.contains(.FLAG_ISOFMT)
    }

    public func isEpoch() -> Bool {
        return !isISOCombined()
    }
}

enum DataFormat: Int {
    case
            HEX,
            BASE64

    public static var DEFAULT: DataFormat {
        return .BASE64
    }

    fileprivate static func parseNillable(_ val: String?) -> DataFormat? {
        let value: String! = val.toConstantComparison()

        var out: DataFormat? = nil

        if (value.isNullOrEmpty()) { return out }

        switch value {
            case "hex": out = .HEX
            case "base64": fallthrough // undocumented.
            case "b64": out = .BASE64
            default: break
        }
        return out
    }

    static func isValidValue(_ val: String?) -> Bool {
        return parseNillable(val) != nil
    }

    static func parse(_ val: String?) -> DataFormat {
        let out: DataFormat? = parseNillable(val)

        return out != nil ? out! : .DEFAULT
    }
    public func converter() -> ((_ x: Data?) -> String?) {
        switch self {
            case .BASE64:
                return DataFormatting.base64
            case .HEX:
                return DataFormatting.hex
        }
    }
}
