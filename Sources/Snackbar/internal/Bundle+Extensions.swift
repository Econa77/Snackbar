//
//  File.swift
//  
//
//  Created by Shunsuke Furubayashi on 2023/10/16.
//

import Foundation

extension Bundle {
    static var current: Bundle {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        return Bundle(for: Snackbar.self)
        #endif
    }
}
