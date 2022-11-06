//
//  Setupable.swift
//  WhiteAndFluffyTest
//
//  Created by ALEKSANDR POZDNIKIN on 31.10.2022.
//

import Foundation

protocol ViewModelProtocol {}

protocol Setupable {
    func setup(with viewModel: ViewModelProtocol)
}
