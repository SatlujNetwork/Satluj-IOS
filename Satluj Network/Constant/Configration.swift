//
//  Configration.swift
//  Satluj Network
//
//  Created by Brahma Naidu on 03/04/22.
//

import Foundation
enum MyConfig {
    case DEVELOPMENT
    case STAGING
    case PRODUCTION
}
struct CONFIG {
    // Chnage this as per the app state
    static let SELECTED: MyConfig = .PRODUCTION
    //get the selected server
    static func serverConfig(config: MyConfig = SELECTED) -> String {
        switch config {
        case .DEVELOPMENT:
            return API.Server.developmentURL
        case .STAGING:
            return API.Server.stagingURL
        case .PRODUCTION:
            return API.Server.productionURL
        }
    }
}
