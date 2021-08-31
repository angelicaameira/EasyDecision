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
    
    var decisao: Decisao?
    var listaAvaliacoes: [Avaliacao]?
    var listaResultados: [Resultado] = []
    var alert = UIAlertController(title: "Atenção!", message: "Ocorreu um erro ao obter as opções", preferredStyle: .alert)
    
    @IBAction func botaoConcluir(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preencheListaAvaliacoes()
        criaListaResultados()
        ordenaListaResultadosPorPorcentagem()
    }
    
    func ordenaListaResultadosPorPorcentagem() {
        listaResultados.sort(by: { resultadoEsquerda, resultadoDireita in
            return resultadoEsquerda.porcentagem > resultadoDireita.porcentagem
        })
    }
    
    func preencheListaAvaliacoes() {
        guard let decisao = decisao else { return }
        do {
            self.listaAvaliacoes = try Avaliacao.listaDoBanco(decisao: decisao)
        } catch {
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "tente novamente"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print(error.localizedDescription)
        }
    }
    
    /// Calcula as porcentagens dos Resultados
    ///
    /// percentualDaOpção = (avaliação1.nota * critério1.peso + avaliaçãoN.nota * critérioN.peso) / (5 * critério1.peso + 5 * critérioN.peso)
    func criaListaResultados() {
        guard let listaAvaliacoes = self.listaAvaliacoes,
              let decisao = self.decisao
        else { return }
        
        do {
            let listaOpcoes = try Opcao.listaDoBanco(decisao: decisao)
            for opcao in listaOpcoes {
                let avaliacoesDaOpcao = listaAvaliacoes.filter({ avaliacao in
                    return avaliacao.opcao.id == opcao.id
                })
                var dividendo = 0.0
                var divisor = 0.0
                for avaliacao in avaliacoesDaOpcao {
                    dividendo = dividendo + Double((avaliacao.nota * avaliacao.criterio.peso))
                    divisor = divisor + Double((5 * avaliacao.criterio.peso))
                }
                let percentualDaOpcao = dividendo/divisor
                listaResultados.append(
                    Resultado(porcentagem: percentualDaOpcao,
                              decisao: decisao,
                              opcao: opcao))
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula-resultado") as! TableViewCell
        
        let resultado = self.listaResultados[indexPath.row]
        
        celula.title?.text = resultado.opcao.descricao
        celula.peso?.text = NumberFormatter.localizedString(from: NSNumber(value: resultado.porcentagem), number: .percent)
        return celula
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaResultados.count
    }
}

