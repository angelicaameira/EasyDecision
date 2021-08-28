//
//  DatabaseManager.swift
//  EasyDecision
//
//  Created by Angélica Andrade de Meira on 25/07/21.
//

import Foundation
import SQLite

protocol Salvavel {
    static func criaTabela()
    static func countNoBanco() throws -> Int
    func insereNoBanco() throws
    func atualizaNoBanco() throws
    func apagaNoBanco() throws
    
}

class DatabaseManager: NSObject {
    
    static let databasePath = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("db.sqlite3").absoluteString;
    }()
    
    static let db: Connection = {
        let connection = try! Connection(databasePath)
        print("Arquivo do banco de dados:")
        print(databasePath)
        return connection
    }()
}
