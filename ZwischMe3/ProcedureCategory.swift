//
//  ProcedureCategory.swift
//  ZwischMe3
//
//  Created by Edward Bender on 2/26/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import Foundation

class ProcedureCategory: NSObject {
    var name: String?
    var order: Int = 0
    var procedureDetails = [ProcedureDetails]()
}