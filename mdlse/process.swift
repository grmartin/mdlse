//
//  process.swift
//  mdlse
//
//  Created by Glenn Martin on 6/5/17.
//  Copyright © 2017 Glenn R. Martin. All rights reserved.
//

import Foundation
import CoreServices

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
                           options: .atomicWrite)
        }

        return 0
    } else {
        println("A file (option: 'f') is required was not provided or is null.")

        help()

        return 1
    }
}
