//
//  AvaliacaoTableViewController.swift
//  EasyDecision
//
//  Created by Angélica Andrade de Meira on 14/07/21.
//

import UIKit
import Foundation
import SQLite

class AvaliacaoTableViewController: UITableViewController {
    
    var decisao: Decisao?
    var avaliacaoSendoEditada: Avaliacao?
    var criterio: Criterio?
    var listaCriterios: [Criterio]?
    var listaOpcoes: [Opcao]?
    var listaAvaliacoes: [Avaliacao] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recuperaOpcoes()
        recuperaCriterios()
        criaAvaliacoes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func instancias() {
        var avaliacao1 = Avaliacao(nota: 0, decisao: self.decisao!, opcao: Opcao, criterio: Criterio)
        var avaliacao2 = Avaliacao(nota: 0, decisao: self.decisao!, opcao: Opcao, criterio: Criterio)
        
        
    }
    
    func criaAvaliacoes() {
        guard let listaOpcoes = listaOpcoes,
              let listaCriterios = listaCriterios,
              let decisao = decisao
        else { return }
        
        var listaAvaliacoesQueJaExistem: [Avaliacao]?
        do {
            listaAvaliacoesQueJaExistem = try Avaliacao.listaDoBanco(decisao: decisao)
        } catch {
            print(error.localizedDescription)
        }
        
        for opcao in listaOpcoes {
            for criterio in listaCriterios {
                let avaliacao = Avaliacao(nota: 1, decisao: decisao, opcao: opcao, criterio: criterio)
                guard let listaAvaliacoesQueJaExistem = listaAvaliacoesQueJaExistem else { continue }
                do {
                    if !listaAvaliacoesQueJaExistem.contains(avaliacao) {
                        try avaliacao.insereNoBanco()
                        self.listaAvaliacoes.append(avaliacao)
                    } else {
                        guard let indiceDaAvaliacaoExistente = listaAvaliacoesQueJaExistem.index(of: avaliacao) else { continue }
                        self.listaAvaliacoes.append(listaAvaliacoesQueJaExistem[indiceDaAvaliacaoExistente])
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func recuperaOpcoes() {
        guard let decisao = decisao else {
            return
        }
        
        do {
            self.listaOpcoes = try Opcao.listaDoBanco(decisao: decisao)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func recuperaCriterios() {
        guard let decisao = decisao else {
            return
        }
        
        do {
            self.listaCriterios = try Criterio.listaDoBanco(decisao: decisao)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: metodos table view
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return listaOpcoes?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return listaOpcoes?[section].descricao
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaCriterios?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let celula = tableView.dequeueReusableCell(withIdentifier: "celula-avaliacao") as? TableViewCell else {
            return UITableViewCell()
        }
        
        let opcao = listaOpcoes?[indexPath.section]
        let criterio = listaCriterios?[indexPath.row]
        
        guard let avaliacao = listaAvaliacoes.first(where: { avaliacao in
            return (opcao?.id == avaliacao.opcao.id &&
                    criterio?.id == avaliacao.criterio.id)
        }) else {
            return celula
        }
        
        celula.title?.text = avaliacao.criterio.descricao
        celula.peso?.text = "\(avaliacao.nota)"
        return celula
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? EditaAvaliacaoViewController {
            if segue.identifier == "editarAvaliacao" {
                // passar a avaliaçao selecionada para a outra tela
                destinationViewController.avaliacao = self.avaliacaoSendoEditada
            }
        }
        if let destinationViewController = segue.destination as? ResultadoTableViewController {
            if segue.identifier == "mostraResultado" {
                destinationViewController.decisao = self.decisao
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let posicaoDaOpcaoNaTableView = indexPath.section
        let posicaoDaCriterioNaTableView = indexPath.row
        let opcao = listaOpcoes?[posicaoDaOpcaoNaTableView]
        let criterio = listaCriterios?[posicaoDaCriterioNaTableView]
        let avaliacao = listaAvaliacoes.first(where: { avaliacao in
            return (opcao?.id == avaliacao.opcao.id &&
                    criterio?.id == avaliacao.criterio.id)
        })
        // define qual é a avaliação selecionada (que será passada depois)
        self.avaliacaoSendoEditada = avaliacao
        // quero a Avaliacao selecionada. As Avaliacoes estao na listaAvaliacoes
        
        // chamar a outra tela
        self.performSegue(withIdentifier: "editarAvaliacao", sender: self)
    }
}
