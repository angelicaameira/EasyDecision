//
//  Decisao.swift
//  EasyDecision
//
//  Created by Angélica Andrade de Meira on 25/07/21.
//

import Foundation
import SQLite

class Decisao: NSObject, Salvavel {
    
    // MARK: propriedades do objeto
    var id: Int64
    var descricao: String
    //    let idsCriterios: [String]?
    //    let idsAvaliacoes: [String]?
    //    let idsOpcoes: [String]?

    // MARK: propriedades do banco
    private static let tabela = Table("decisao")
    private static let idExpression = Expression<Int64>("id")
    private static let descricaoExpression = Expression<String>("descricao")
    
    init(descricao: String) {
        self.id = -1
        self.descricao = descricao
    }
    
    private init(id: Int64, descricao: String) {
        self.id = id
        self.descricao = descricao
    }
    
    // MARK: Salvavel e funções no banco
    static func comId(_ id: Int64) throws -> Decisao {
        let filtrosDecisao = Decisao.tabela.filter(rowid == id)
        if let decisaoDoBanco = try DatabaseManager.db.pluck(filtrosDecisao) {
            return Decisao(id: decisaoDoBanco[Decisao.idExpression], descricao: decisaoDoBanco[Decisao.descricaoExpression])
        }
        throw NSError(domain: "Não encontrou a decisão", code: 404, userInfo: nil)
    }
    
    static func listaDoBanco() throws -> [Decisao] {
        var lista = [Decisao]()
        for decisaoDoBanco in try DatabaseManager.db.prepare(tabela) {
            print("id: \(decisaoDoBanco[idExpression]), name: \(decisaoDoBanco[descricaoExpression])")
            lista.append(Decisao(id: decisaoDoBanco[idExpression], descricao: decisaoDoBanco[descricaoExpression]))
        }
        return lista
    }
    
    static func countNoBanco() throws -> Int {
        return try DatabaseManager.db.scalar(tabela.count)
    }
    
    func insereNoBanco() throws {
        let insert = Decisao.tabela.insert(Decisao.descricaoExpression <- self.descricao)
        self.id = try DatabaseManager.db.run(insert)
    }
    
    func atualizaNoBanco() throws {
        let decisao = Decisao.tabela.filter(rowid == self.id)
        try DatabaseManager.db.run(decisao.update(Decisao.descricaoExpression <- self.descricao))
    }
    
    func apagaNoBanco() throws {
        let decisao = Decisao.tabela.filter(rowid == self.id)
        try DatabaseManager.db.run(decisao.delete())
    }
    
    static func criaTabela() {
        do {
            try DatabaseManager.db.run(tabela.create(ifNotExists: true) { t in
                t.column(idExpression, primaryKey: .autoincrement)
                t.column(descricaoExpression)
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
