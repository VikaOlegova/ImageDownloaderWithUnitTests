//
//  URLProvider.swift
//  ImageDownloader
//
//  Created by Вика on 30/10/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import Foundation

protocol URLProviderProtocol {
    var imageURL: URL? { get }
}

class URLProvider: URLProviderProtocol {
    
    var imageURL: URL? {
        return URL(string: "http://icons.iconarchive.com/icons/dtafalonso/ios8/512/Calendar-icon.png")
    }
}
