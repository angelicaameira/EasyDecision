//
//  DecisaoAPI.swift
//  EasyDecision
//
//  Created by Angélica Andrade de Meira on 29/05/21.
//
import UIKit
import Foundation
import SQLite

class DecisaoTableViewController: UITableViewController {
    
    var alert = UIAlertController(title: "Atenção!", message: "Ocorreu um erro ao obter as opções", preferredStyle: .alert)
    var decisaoSelecionada: Decisao?
    var listaDecisoes: [Decisao]?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recuperaDecisao()
        tableView.reloadData()
    }
    
    //MARK: metodos
    
    func recuperaDecisao() {
        do {
            self.listaDecisoes = try Decisao.listaDoBanco()
        } catch {
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "tente novamente"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print(error.localizedDescription)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: metodos table view
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaDecisoes?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = UITableViewCell(style: .default, reuseIdentifier: "celula-decisao")
        guard let decisao = self.listaDecisoes?[indexPath.row] else {
            return celula
        }
        
        celula.textLabel?.text = decisao.descricao
        return celula
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? OpcoesTableViewController {
            if segue.identifier == "mostraOpcoes" {
                destinationViewController.decisao = self.decisaoSelecionada
            }
        }
        if let destinationViewController = segue.destination as? AdicionaDecisaoViewController {
            if segue.identifier == "editarDecisao" {
                destinationViewController.decisao = self.decisaoSelecionada
            }
//            if segue.identifier == "adicionarDecisao" {
//                destinationViewController.title = "Adicionar Decisão"
//            }
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let acoes = [
            UIContextualAction(style: .destructive, title: "Delete", handler: { [self] (contextualAction, view, _) in 
                guard let decisao = self.listaDecisoes?[indexPath.row] else { return }
                do {
                    try decisao.apagaNoBanco()
                    self.recuperaDecisao()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                } catch {
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "tente novamente"), style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    print(error.localizedDescription)
                }
            }),
            UIContextualAction(style: .normal, title: "Edit", handler: { (contextualAction, view, _) in
                self.decisaoSelecionada = self.listaDecisoes?[indexPath.row]
                self.performSegue(withIdentifier: "editarDecisao", sender: contextualAction)
            })]
        return UISwipeActionsConfiguration(actions: acoes)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let decisaoSelecionada = self.listaDecisoes?[indexPath.row] else { return }
        
        self.decisaoSelecionada = decisaoSelecionada
        self.performSegue(withIdentifier: "mostraOpcoes", sender: self)
    }
}
