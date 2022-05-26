//
//  Criterio.swift
//  EasyDecision
//
//  Created by Angélica Andrade de Meira on 26/07/21.
//

import Foundation
import SQLite

class Criterio: NSObject, Salvavel {
    
    // MARK: propriedades do objeto
    var id: Int64
    var descricao: String
    var peso: Int
    var decisao: Decisao
    
    // MARK: propriedades do banco
    private static let tabela = Table("Criterio")
    private static let idExpression = Expression<Int64>("id")
    private static let descricaoExpression = Expression<String>("descricao")
    private static let pesoExpression = Expression<Int>("peso")
    private static let idDecisaoExpression = Expression<Int64>("idDecisao")
    
    init(descricao: String, peso: Int, decisao: Decisao) {
        self.id = -1
        self.descricao = descricao
        self.peso = peso
        self.decisao = decisao
    }
    
    private init(id: Int64, descricao: String, peso: Int, decisao: Decisao) {
        self.id = id
        self.descricao = descricao
        self.peso = peso
        self.decisao = decisao
    }
    
    // MARK: Salvavel e funções no banco
    static func comId(_ id: Int64) throws -> Criterio {
        let filtrosCriterio = Criterio.tabela.filter(rowid == id)
        if let criterioDoBanco = try DatabaseManager.db.pluck(filtrosCriterio) {
            return Criterio(id: criterioDoBanco[Criterio.idExpression], descricao: criterioDoBanco[Criterio.descricaoExpression], peso: criterioDoBanco[Criterio.pesoExpression], decisao: try Decisao.comId(criterioDoBanco[idDecisaoExpression]))
        }
        throw NSError(domain: "Não encontrou o criterio", code: 404, userInfo: nil)
    }
    
    static func listaDoBanco(decisao: Decisao) throws -> [Criterio] {
        var lista = [Criterio]()
        let filtro = Criterio.tabela.filter(Criterio.idDecisaoExpression == decisao.id)
        for criterioDoBanco in try DatabaseManager.db.prepare(filtro) {
#if DEBUG
            print("id: \(criterioDoBanco[idExpression]), name: \(criterioDoBanco[descricaoExpression]), peso:\(criterioDoBanco[pesoExpression])")
#endif
            lista.append(Criterio(id: criterioDoBanco[Criterio.idExpression], descricao: criterioDoBanco[Criterio.descricaoExpression], peso: criterioDoBanco[Criterio.pesoExpression], decisao: try Decisao.comId(criterioDoBanco[idDecisaoExpression])))
        }
        return lista
    }
    
    static func countNoBanco() throws -> Int {
        return try DatabaseManager.db.scalar(tabela.count)
    }
    
    func insereNoBanco() throws {
        let insert = Criterio.tabela.insert(Criterio.descricaoExpression <- self.descricao,
                                            Criterio.pesoExpression <- self.peso,
                                            Criterio.idDecisaoExpression <- self.decisao.id)
        self.id = try DatabaseManager.db.run(insert)
    }
    
    func atualizaNoBanco() throws {
        let criterio = Criterio.tabela.filter(rowid == self.id)
        try DatabaseManager.db.run(criterio.update(Criterio.descricaoExpression <- self.descricao,
                                                   Criterio.pesoExpression <- self.peso,
                                                   Criterio.idDecisaoExpression <- self.decisao.id))
    }
    
    func apagaNoBanco() throws {
        let criterio = Criterio.tabela.filter(rowid == self.id)
        try DatabaseManager.db.run(criterio.delete())
    }
    
    static func criaTabela() {
        do {
            try DatabaseManager.db.run(tabela.create(ifNotExists: true) { t in
                t.column(idExpression, primaryKey: .autoincrement)
                t.column(descricaoExpression)
                t.column(pesoExpression)
                t.column(idDecisaoExpression)
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

