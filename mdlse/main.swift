//
//  main.swift
//  mdlse
//
//  Created by Glenn Martin on 6/5/17.
//  Copyright © 2017 Glenn R. Martin. All rights reserved.
//

import Foundation

func help() {
    println("mdlse - The Spotlight Metadata Extraction utility.")
    println("")
    println("Options:")
    println("  i <file>  Input File.")
    println("  f <fmt>   Output format. (p:plist (xml), j:json)")
    println("  b         Write to both the output file and to the console.")
    println("  o <file>  Output File.")
    println("  a         (RESERVED/NYI) Agnostic key names.")
    println("  j <csv>   JSON Conversion Specifiers in a CSV String.")
    println("")
    println("JSON Conversions:")
    println("  Dates:")
    println("    epoch   Use Unix style epoch dates. (LT)")
    println("    iso     Use ISO8601 Combined dates. (LT)")
    println("    epochz  Use Unix style epoch dates. (Zulu/UTC; DEFAULT)")
    println("    isoz    Use ISO8601 Combined dates. (Zulu/UTC)")
    println("  Data:")
    println("    b64     Base64 Encoded (DEFAULT)")
    println("    hex     Hexadecimal Encoded")
    println("")
    println("")

    exit(1)
}

if (CommandLine.argc < 1) {
    help()
}

while case let option = getopt(CommandLine.argc, CommandLine.unsafeArgv, "i:f:bo:aj:"), option != -1 {
    switch UnicodeScalar(CUnsignedChar(option)) {
    case "i":
        file = String(cString: optarg)
    case "f":
        format = OutputFormat.parse(String(cString: optarg))
    case "b":
        stdOut = true
    case "o":
        outputFile = String(cString: optarg)
    case "a":
        agnosticFlag = true
    case "j":
        let opt = String(cString: optarg);
        if (!opt.isNullOrEmpty()) {
            for conv in opt.components(separatedBy: ",") {
                if (DataFormat.isValidValue(conv)) {
                    dataFmt = DataFormat.parse(conv)
                } else if (DateFormat.isValidValue(conv)) {
                    dateFmt = DateFormat.parse(conv)
                }
            }
        }

    default:
        help()
    }
}

if file.isNullOrEmpty() {
    help()
}

if outputFile.isNullOrEmpty() {
    stdOut = true
}

exit(process(file: file, outputFormat: format, dateFormat: dateFmt, dataFormat: dataFmt, outFile: outputFile, stdOut: stdOut, agnostic: agnosticFlag))
