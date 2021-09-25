//
//  AccountDatabaseChangeInfo.swift
//  AccountBook
//
//  Created by Kohei KONISHI on 2021/09/22.
//

import Foundation

struct AccountDatabaseChangeInfo {
    enum ChangeMode {
        case added
        case removed
        case replaced
    }
    
    let changeMode: ChangeMode
    let prevRecord: AccountRecord?
    let newRecord: AccountRecord?
}
