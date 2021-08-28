//
//  Opcao.swift
//  EasyDecision
//
//  Created by Angélica Andrade de Meira on 25/07/21.
//

import Foundation
import SQLite

class Opcao: NSObject, Salvavel {
    
    // MARK: propriedades do objeto
    var id: Int64
    var descricao: String
    var decisao: Decisao

    // MARK: propriedades do banco
    private static let tabela = Table("Opcao")
    private static let idExpression = Expression<Int64>("id")
    private static let descricaoExpression = Expression<String>("descricao")
    private static let idDecisaoExpression = Expression<Int64>("idDecisao")
    
    init(descricao: String, decisao: Decisao) {
        self.id = -1
        self.descricao = descricao
        self.decisao = decisao
    }
    
    private init(id: Int64, descricao: String, decisao: Decisao) {
        self.id = id
        self.descricao = descricao
        self.decisao = decisao
    }
    
    // MARK: Salvavel e funções no banco
    static func comId(_ id: Int64) throws -> Opcao {
        let filtrosOpcao = Opcao.tabela.filter(rowid == id)
        if let opcaoDoBanco = try DatabaseManager.db.pluck(filtrosOpcao) {
            return Opcao(id: opcaoDoBanco[Opcao.idExpression], descricao: opcaoDoBanco[Opcao.descricaoExpression], decisao: try Decisao.comId(opcaoDoBanco[idDecisaoExpression]))
        }
        throw NSError(domain: "Não encontrou a opcao", code: 404, userInfo: nil)
    }
    
    static func listaDoBanco(decisao: Decisao) throws -> [Opcao] {
        var lista = [Opcao]()
        let filtro = Opcao.tabela.filter(Opcao.idDecisaoExpression == decisao.id)
        for opcaoDoBanco in try DatabaseManager.db.prepare(filtro) {
            print("id: \(opcaoDoBanco[idExpression]), name: \(opcaoDoBanco[descricaoExpression])")
            lista.append(Opcao(id: opcaoDoBanco[Opcao.idExpression], descricao: opcaoDoBanco[Opcao.descricaoExpression], decisao: try Decisao.comId(opcaoDoBanco[idDecisaoExpression])))
        }
        return lista
    }
    
    static func countNoBanco() throws -> Int {
        return try DatabaseManager.db.scalar(tabela.count)
    }
    
    func insereNoBanco() throws {
        let insert = Opcao.tabela.insert(Opcao.descricaoExpression <- self.descricao,
                                         Opcao.idDecisaoExpression <- self.decisao.id)
        self.id = try DatabaseManager.db.run(insert)
    }
    
    func atualizaNoBanco() throws {
        let opcao = Opcao.tabela.filter(rowid == self.id)
        try DatabaseManager.db.run(opcao.update(Opcao.descricaoExpression <- self.descricao,
                                                Opcao.idDecisaoExpression <- self.decisao.id))
    }
    
    func apagaNoBanco() throws {
        let opcao = Opcao.tabela.filter(rowid == self.id)
        try DatabaseManager.db.run(opcao.delete())
    }
    
    static func criaTabela() {
        do {
            try DatabaseManager.db.run(tabela.create(ifNotExists: true) { t in
                t.column(idExpression, primaryKey: .autoincrement)
                t.column(descricaoExpression)
                t.column(idDecisaoExpression)
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
