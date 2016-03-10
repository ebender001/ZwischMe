//
//  ZwischStage.swift
//  ZwischMe3
//
//  Created by Edward Bender on 2/26/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import Foundation

class ZwischStage: NSObject {
    var zwischName: String?
    var zwischInformation: String?
    var order: Int = 0
}

extension ZwischStage {
    func zwischInfoArray() -> [String]? {
        if let zwischInformation = zwischInformation {
            let array = zwischInformation.componentsSeparatedByString("|")
            return array
        }
        return nil
    }
}