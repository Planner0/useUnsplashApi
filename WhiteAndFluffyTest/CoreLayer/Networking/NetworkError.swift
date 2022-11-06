//
//  Error.swift
//  WhiteAndFluffyTest
//
//  Created by ALEKSANDR POZDNIKIN on 18.10.2022.
//

import Foundation
enum NetworkError: Error {
    case `default`
    case serverError
    case parseError(reason: String)
    case unknownError
}
