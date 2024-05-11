//
//  APIModal.swift
//  ImageGridApp
//
//  Created by NFC User on 10/05/24.
//

import Foundation

struct APIModal: Codable {
    var thumbnail: Detail
}

struct Detail: Codable {
    var id: String
    var domain: String
    var basePath: String
    var key: String
}
