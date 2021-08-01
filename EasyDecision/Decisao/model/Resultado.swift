//
//  Resultado.swift
//  EasyDecision
//
//  Created by Angélica Andrade de Meira on 01/08/21.
//

import Foundation
import SQLite


class Resultado: NSObject, Salvavel {
    
    // MARK: propriedades do objeto
    var id: Int64
    var porcentagem: Double
    var decisao: Decisao
    var opcao: Opcao
    var criterio: Criterio
    var avalicao: Avaliacao

    // MARK: propriedades do banco
    private static let tabela = Table("Resultado")
    private static let idExpression = Expression<Int64>("id")
    private static let porcentagemExpression = Expression<Double>("porcentagem")
    private static let idDecisaoExpression = Expression<Int64>("idDecisao")
    private static let idOpcaoExpression = Expression<Int64>("idOpcao")
    private static let idCriterioExpression = Expression<Int64>("idCriterio")
    private static let idAvaliacaoExpression = Expression<Int64>("idAvaliacao")
    
    init(porcentagem: Double, decisao: Decisao, opcao: Opcao, criterio: Criterio, avaliacao: Avaliacao) {
        self.id = -1
        self.porcentagem = porcentagem
        self.decisao = decisao
        self.opcao = opcao
        self.criterio = criterio
        self.avalicao = avaliacao
        
    }
    
    private init(id: Int64, porcentagem: Double, decisao: Decisao, opcao: Opcao, criterio: Criterio, avaliacao: Avaliacao) {
        self.id = id
        self.porcentagem = porcentagem
        self.decisao = decisao
        self.opcao = opcao
        self.criterio = criterio
        self.avalicao = avaliacao
    }
    
    // MARK: Salvavel e funções no banco
    static func comId(_ id: Int64) throws -> Resultado {
        let filtrosResultado = Resultado.tabela.filter(rowid == id)
        if let resultadoDoBanco = try DatabaseManager.db.pluck(filtrosResultado) {
            return Resultado(id: resultadoDoBanco[Resultado.idExpression],
                             porcentagem: resultadoDoBanco[Resultado.porcentagemExpression],
                             decisao: try Decisao.comId(resultadoDoBanco[idDecisaoExpression]),
                             opcao: try Opcao.comId(resultadoDoBanco[idOpcaoExpression]),
                             criterio: try Criterio.comId(resultadoDoBanco[idCriterioExpression]),
                             avaliacao: try
                                Avaliacao.comId(resultadoDoBanco[idAvaliacaoExpression]))
        }
        throw NSError(domain: "Não encontrou os resultados", code: 404, userInfo: nil)
    }
    
    static func listaDoBanco(decisao: Decisao) throws -> [Resultado] {
        var lista = [Resultado]()
        let filtro = Resultado.tabela.filter(Resultado.idDecisaoExpression == decisao.id)
        for resultadoDoBanco in try DatabaseManager.db.prepare(filtro) {
            print("id: \(resultadoDoBanco[idExpression]), porcentagem: \(resultadoDoBanco[porcentagemExpression])")
            lista.append(
                Resultado(id: resultadoDoBanco[Resultado.idExpression],
                         porcentagem: resultadoDoBanco[Resultado.porcentagemExpression],
                         decisao: try Decisao.comId(resultadoDoBanco[idDecisaoExpression]),
                         opcao: try Opcao.comId(resultadoDoBanco[idOpcaoExpression]),
                         criterio: try Criterio.comId(resultadoDoBanco[idCriterioExpression]),
                         avaliacao: try
                            Avaliacao.comId(resultadoDoBanco[idAvaliacaoExpression])))
        }
        return lista
    }
    
    static func countNoBanco() throws -> Int {
        return try DatabaseManager.db.scalar(tabela.count)
    }
    
    func insereNoBanco() throws {
        let insert = Resultado.tabela.insert(Resultado.porcentagemExpression <- self.porcentagem,
                                             Resultado.idDecisaoExpression <- self.decisao.id,
                                             Resultado.idOpcaoExpression <- self.decisao.id,
                                             Resultado.idCriterioExpression <- self.decisao.id,
                                             Resultado
                                              .idAvaliacaoExpression
                                              <- self.avalicao.id)
        self.id = try DatabaseManager.db.run(insert)
    }
    
    func atualizaNoBanco() throws {
        let resultado = Resultado.tabela.filter(rowid == self.id)
        try DatabaseManager.db.run(resultado.update(
                                    Resultado.porcentagemExpression <- self.porcentagem,
                                    Resultado.idDecisaoExpression <- self.decisao.id,
                                    Resultado.idOpcaoExpression <- self.opcao.id,
                                    Resultado.idCriterioExpression <- self.criterio.id,
                                    Resultado.idAvaliacaoExpression <- self.avalicao.id))
    }
    
    func apagaNoBanco() throws {
        let resultado = Resultado.tabela.filter(rowid == self.id)
        try DatabaseManager.db.run(resultado.delete())
    }
    
    static func criaTabela() {
        do {
            try DatabaseManager.db.run(tabela.create(ifNotExists: true) { t in
                t.column(idExpression, primaryKey: .autoincrement)
                t.column(porcentagemExpression)
                t.column(idDecisaoExpression)
                t.column(idOpcaoExpression)
                t.column(idCriterioExpression)
                t.column(idAvaliacaoExpression)
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
