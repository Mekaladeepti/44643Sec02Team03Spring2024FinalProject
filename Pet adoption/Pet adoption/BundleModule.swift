//
//  BundleModule.swift
//  Pet adoption
//
//  Created by Durga Sambhavi Mamillapalli on 4/12/24.
//


import Foundation

#if !SWIFT_PACKAGE
extension Bundle {
    static var module: Bundle = {
        return Bundle(for: ImageSlideshow.self)
    }()
}
#endif
