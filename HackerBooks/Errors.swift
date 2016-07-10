//
//  Errors.swift
//  HackerBooks
//
//  Created by Alejandro on 06/07/16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

import Foundation

enum HackerBooksError: ErrorType {
    case resourcePointedByURLNotReachable
    case jsonParsingError
    case downloadError
    case loadFileError
    case wrongJSONFormat
    case invalidImage
}

extension HackerBooksError: CustomStringConvertible {
    var description: String {
        switch self {
        case .resourcePointedByURLNotReachable:
            return "The resource pointed by url is not reachable"
        case .jsonParsingError:
            return "Error while parsing JSON"
        case .downloadError:
            return "Error while downloading a file"
        case .loadFileError:
            return "Error while loading a file"
        case .wrongJSONFormat:
            return "Wrong format in JSON file"
        case .invalidImage:
            return "Invalid image"
        }
    }
}