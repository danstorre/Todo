//
//  KeychainAccessible.swift
//  ToDo
//
//  Created by Daniel Torres on 5/29/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

protocol KeychainAccessible {
    func setPassword(password: String,
           account: String)
    func deletePasswortForAccount(account: String)
    func passwordForAccount(account: String) -> String?
}
