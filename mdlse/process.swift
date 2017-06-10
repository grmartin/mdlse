//
//  process.swift
//  mdlse
//
//  Created by Glenn Martin on 6/5/17.
//  Copyright © 2017 Glenn R. Martin. All rights reserved.
//

import Foundation
import CoreServices


let defaultEncoding = String.Encoding.utf8



func convertForJson(_ inObj: Any, _ dateFormat: DateFormat, _ dataFormat: DataFormat) -> Any {
    let recurse = { x in return convertForJson(x, dateFormat, dataFormat) }
    let convertData = dataFormat.converter();
    let convertDate = dateFormat.converter();


    if inObj is [Any] {
        var newArry : [Any] = [];

        for item in inObj as! [Any] {
            newArry.append(recurse(item))
        }

        return newArry;
    }
    
    if inObj is [String:Any] {

        var newDict : [String:Any] = [:];

        for item in inObj as! [String:Any] {
            newDict.updateValue(recurse(item.value), forKey: item.key)
        }

        return newDict;
    }

    if (inObj is Data) {
        return convertData(inObj as? Data) as Any
    }

    if (inObj is Date) {
        return convertDate(inObj as? Date) as Any
    }
    
    return inObj
}

func process(file: String?, outputFormat: OutputFormat, dateFormat: DateFormat, dataFormat: DataFormat, outFile: String?, stdOut: Bool, agnostic: Bool) -> Int32 {
    if let goodFile = file as String!, !goodFile.isEmpty {
        let item: MDItem = MDItemCreate(nil, goodFile as CFString!)
        let dict = MDItemCopyAttributes(item, MDItemCopyAttributeNames(item)) as Dictionary

        var outData: String!

        switch outputFormat {
            case .PLIST:
                let data = try! PropertyListSerialization.data(fromPropertyList: dict, format: .xml, options: 0) as Data

                outData = String(data: data, encoding: defaultEncoding)

            case .JSON:
                outData = try! String(data: JSONSerialization.data(withJSONObject: convertForJson(dict, dateFormat, dataFormat)), encoding: defaultEncoding)
        }

        if (stdOut) {
            print(outData)
        }

        if (!outputFile.isNullOrEmpty()) {
            try! outData.data(using: defaultEncoding)?
                    .write(to: URL.init(fileURLWithPath: outputFile!),
                           options: .atomicWrite);
        }

        return 0;
    } else {
        println("A file (option: 'f') is required was not provided or is null.")

        help()

        return 1
    }

    return 2

}
