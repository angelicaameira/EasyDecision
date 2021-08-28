//
//  Resultado.swift
//  EasyDecision
//
//  Created by Angélica Andrade de Meira on 01/08/21.
//

import Foundation
import SQLite

class Resultado: NSObject {
    
    // MARK: propriedades do objeto
    var id: Int64
    var porcentagem: Double
    var decisao: Decisao
    var opcao: Opcao

    init(porcentagem: Double, decisao: Decisao, opcao: Opcao) {
        self.id = -1
        self.porcentagem = porcentagem
        self.decisao = decisao
        self.opcao = opcao
    }
    
    private init(id: Int64, porcentagem: Double, decisao: Decisao, opcao: Opcao) {
        self.id = id
        self.porcentagem = porcentagem
        self.decisao = decisao
        self.opcao = opcao
    }
    
}
