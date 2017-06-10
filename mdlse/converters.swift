//
// Created by Glenn Martin on 6/9/17.
// Copyright (c) 2017 Glenn R. Martin. All rights reserved.
//

import Foundation

class DataFormatting {
    class func base64(_ data: Data?) -> String? {
        return data?.base64EncodedString();
    }

    class func hex(_ data: Data?) -> String? {
        if data == nil {
            return nil;
        }

        var str = "";

        for item in data! {
            str = str.appendingFormat("%02X", item)
        }

        return str
    }
}

class IsoDates {
    static var localDtFmt: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") as Locale!
        dateFormatter.timeZone = TimeZone.current as TimeZone!
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter;
    }()

    static var zuluDtFmt: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") as Locale!
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC") as TimeZone!
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        return dateFormatter;
    }()

    class func isoDateZulu(_ date: Date?) -> String? {
        if date == nil {
            return nil;
        }

        return zuluDtFmt.string(from: date!).appending("Z")
    }

    class func isoDateLocal(_ date: Date?) -> String? {
        if date == nil {
            return nil;
        }

        return localDtFmt.string(from:date!)
    }
}

class EpochDates {
    class func epochZulu(_ date: Date?) -> String? {
        if date == nil {
            return nil;
        }

        let timeSecs = date!.timeIntervalSince1970 * 1000;

        return String(describing: Int64(timeSecs))
    }
    class func epochLocal(_ date: Date?) -> String? {
        if date == nil {
            return nil;
        }

        let timeSecs = date!.timeIntervalSince1970 * 1000;
        let gmtSecs: Double = Double((TimeZone.current as TimeZone!).secondsFromGMT());

        return String(describing: Int64(timeSecs + gmtSecs))
    }
}