//
//  Resultado.swift
//  EasyDecision
//
//  Created by Angélica Andrade de Meira on 01/08/21.
//

import Foundation
import UIKit
import SQLite

class ResultadoTableViewController: UITableViewController {
    
    var resultadoSendoEditado: Criterio?
    var decisao: Decisao?
    var listaResultados: [Resultado]?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recuperaResultado()
        tableView.reloadData()
    }
    
    // MARK: metodos que não são da table view
    
    func recuperaResultado() {
        do {
            self.listaResultados = try Resultado.listaDoBanco(decisao: decisao!)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: metodos table view
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let contadorListaDeResultados = listaResultados?.count else { return 0 }
        return contadorListaDeResultados
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula-resultado") as! TableViewCell
        guard let resultado = listaResultados?[indexPath.row]
        else {
            return celula
        }
        
        celula.title?.text = resultado.decisao.descricao
        celula.peso?.text = "\(resultado.criterio.peso)"
        return celula
    }
}

