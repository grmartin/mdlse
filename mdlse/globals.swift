//
// Created by Glenn Martin on 6/9/17.
// Copyright (c) 2017 Glenn R. Martin. All rights reserved.
//

import Foundation

let defaultEncoding = String.Encoding.utf8

var format: OutputFormat = .DEFAULT
var dataFmt: DataFormat = .DEFAULT
var dateFmt: DateFormat = .DEFAULT
var agnosticFlag: Bool = false
var file: String? = nil
var stdOut: Bool = false
var outputFile: String? = nil

func println(_ line: Any) {
    print(line, terminator: "\n")
}
