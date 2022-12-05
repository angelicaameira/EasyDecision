//
//  Avaliacao.swift
//  EasyDecision
//
//  Created by Angélica Andrade de Meira on 26/07/21.
//

import Foundation
import SQLite

class Avaliacao: NSObject, Salvavel {
    
    // MARK: propriedades do objeto
    
    var id: Int64
    var nota: Int
    var decisao: Decisao
    var opcao: Opcao
    var criterio: Criterio
    
    // MARK: propriedades do banco
    
    static let tabela = Table("Avaliacao")
    static let idExpression = Expression<Int64>("id")
    static let notaExpression = Expression<Int>("nota")
    static let idDecisaoExpression = Expression<Int64>("idDecisao")
    static let idOpcaoExpression = Expression<Int64>("idOpcao")
    static let idCriterioExpression = Expression<Int64>("idCriterio")
    
    init(nota: Int, decisao: Decisao, opcao: Opcao, criterio: Criterio) {
        self.id = -1
        self.nota = nota
        self.decisao = decisao
        self.opcao = opcao
        self.criterio = criterio
    }
    
    private init(id: Int64, nota: Int, decisao: Decisao, opcao: Opcao, criterio: Criterio) {
        self.id = id
        self.nota = nota
        self.decisao = decisao
        self.opcao = opcao
        self.criterio = criterio
    }
    
    // MARK: NSObject
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? Avaliacao
        else { return false }
        
        return self.opcao.id == object.opcao.id
        && self.decisao.id == object.decisao.id
        && self.criterio.id == object.criterio.id;
    }
    
    // MARK: Salvável e funções no banco
    
    static func comId(_ id: Int64) throws -> Avaliacao {
        let filtrosAvaliacao = Avaliacao.tabela.filter(rowid == id)
        if let avaliacaoDoBanco = try DatabaseManager.db.pluck(filtrosAvaliacao) {
            return Avaliacao(id: avaliacaoDoBanco[Avaliacao.idExpression],
                             nota: avaliacaoDoBanco[Avaliacao.notaExpression],
                             decisao: try Decisao.comId(avaliacaoDoBanco[Avaliacao.idDecisaoExpression]),
                             opcao: try Opcao.comId(avaliacaoDoBanco[Avaliacao.idOpcaoExpression]),
                             criterio: try Criterio.comId(avaliacaoDoBanco[Avaliacao.idCriterioExpression]))
        }
        throw NSError(domain: "Não encontrou as avaliações", code: 404, userInfo: nil)
    }
    
    static func listaDoBanco(decisao: Decisao) throws -> [Avaliacao] {
        var lista = [Avaliacao]()
        let filtro = Avaliacao.tabela.filter(Avaliacao.idDecisaoExpression == decisao.id)
        for avaliacaoDoBanco in try DatabaseManager.db.prepare(filtro) {
#if DEBUG
            print("id: \(avaliacaoDoBanco[Avaliacao.idExpression]), nota: \(avaliacaoDoBanco[Avaliacao.notaExpression])")
#endif
            lista.append(
                Avaliacao(id: avaliacaoDoBanco[Avaliacao.idExpression],
                          nota: avaliacaoDoBanco[Avaliacao.notaExpression],
                          decisao: try Decisao.comId(avaliacaoDoBanco[Avaliacao.idDecisaoExpression]),
                          opcao: try Opcao.comId(avaliacaoDoBanco[Avaliacao.idOpcaoExpression]),
                          criterio: try Criterio.comId(avaliacaoDoBanco[Avaliacao.idCriterioExpression])
                         ))
        }
        return lista
    }
    
    static func countNoBanco() throws -> Int {
        return try DatabaseManager.db.scalar(Avaliacao.tabela.count)
    }
    
    func insereNoBanco() throws {
        let insert = Avaliacao.tabela.insert(Avaliacao.notaExpression <- self.nota,
                                            Avaliacao.idDecisaoExpression <- self.decisao.id,
                                            Avaliacao.idOpcaoExpression <- self.opcao.id,
                                            Avaliacao.idCriterioExpression <- self.criterio.id)
        self.id = try DatabaseManager.db.run(insert)
    }
    
    func atualizaNoBanco() throws {
        let avaliacao = Avaliacao.tabela.filter(rowid == self.id)
        try DatabaseManager.db.run(avaliacao.update(
            Avaliacao.notaExpression <- self.nota,
            Avaliacao.idDecisaoExpression <- self.decisao.id,
            Avaliacao.idOpcaoExpression <- self.opcao.id,
            Avaliacao.idCriterioExpression <- self.criterio.id))
    }
    
    func apagaNoBanco() throws {
        let avaliacao = Avaliacao.tabela.filter(rowid == self.id)
        try DatabaseManager.db.run(avaliacao.delete())
    }
    
    static func criaTabela() {
        do {
            try DatabaseManager.db.run(Avaliacao.tabela.create(ifNotExists: true) { t in
                t.column(Avaliacao.idExpression, primaryKey: .autoincrement)
                t.column(Avaliacao.notaExpression)
                t.column(Avaliacao.idDecisaoExpression)
                t.column(Avaliacao.idOpcaoExpression)
                t.column(Avaliacao.idCriterioExpression)
            })
        } catch {
            print(error.localizedDescription)
        }
    }
}
