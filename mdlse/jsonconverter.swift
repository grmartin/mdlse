//
// Created by Glenn Martin on 6/9/17.
// Copyright (c) 2017 Glenn R. Martin. All rights reserved.
//

import Foundation

func convertForJson(_ inObj: Any, _ dateFormat: DateFormat, _ dataFormat: DataFormat) -> Any {
    let recurse = { x in return convertForJson(x, dateFormat, dataFormat) }
    let convertData = dataFormat.converter()
    let convertDate = dateFormat.converter()

    if inObj is [Any] {
        var newArry: [Any] = [];

        for item in inObj as! [Any] {
            newArry.append(recurse(item))
        }

        return newArry;
    }

    if inObj is [String:Any] {
        var newDict: [String:Any] = [:]

        for item in inObj as! [String:Any] {
            newDict.updateValue(recurse(item.value), forKey: item.key)
        }

        return newDict
    }

    if (inObj is Data) {
        return convertData(inObj as? Data) as Any
    }

    if (inObj is Date) {
        return convertDate(inObj as? Date) as Any
    }

    return inObj
}