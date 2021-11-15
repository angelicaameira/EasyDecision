//
//  OpcoesTableViewControler.swift
//  EasyDecision
//
//  Created by Angélica Andrade de Meira on 24/06/21.
//
import Foundation
import UIKit
import SQLite

class OpcoesTableViewController: UITableViewController {
    
    var alert = UIAlertController(title: "Atenção!", message: "Ocorreu um erro ao obter as opções", preferredStyle: .alert)
    var opcaoSendoEditada: Opcao?
    var decisao: Decisao?
    var listaOpcoes: [Opcao]?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recuperaOpcao()
        tableView.reloadData()
    }
    
    // MARK: metodos que não são da table view
    
    func recuperaOpcao() {
        do {
            guard let decisao = decisao else {
                return
            }
            self.listaOpcoes = try Opcao.listaDoBanco(decisao: decisao)
        } catch {
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "tente novamente"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print(error.localizedDescription)
        }
    }
    
    // MARK: metodos table view
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaOpcoes?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = UITableViewCell(style: .default, reuseIdentifier: "celula-opcao")
        guard let opcao = self.listaOpcoes?[indexPath.row] else {
            return celula
        }
        
        celula.textLabel?.text = opcao.descricao
        return celula
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? AdicionaOpcaoViewController {
            if segue.identifier == "editarOpcao" {
                destinationViewController.opcao = self.opcaoSendoEditada
                destinationViewController.decisao = self.decisao
            }
            if segue.identifier == "adicionarOpcao" {
                destinationViewController.decisao = self.decisao
            }
        }
        if let destinationViewController = segue.destination as? CriteriosTableViewController {
            if segue.identifier == "mostraCriterios" {
                destinationViewController.decisao = self.decisao
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let acoes = [
            UIContextualAction(style: .destructive, title: "Delete", handler: { [self] (contextualAction, view, _) in
                guard let opcao = self.listaOpcoes?[indexPath.row] else { return }
                do {
                    try opcao.apagaNoBanco()
                    self.recuperaOpcao()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                } catch {
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "tente novamente"), style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    print(error.localizedDescription)
                }
            }),
            UIContextualAction(style: .normal, title: "Edit", handler: { (contextualAction, view, _) in
                self.opcaoSendoEditada = self.listaOpcoes?[indexPath.row]
                self.performSegue(withIdentifier: "editarOpcao", sender: contextualAction)
            })]
        return UISwipeActionsConfiguration(actions: acoes)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let opcaoSendoEditada = self.listaOpcoes?[indexPath.row] else { return }
        self.opcaoSendoEditada = opcaoSendoEditada
        self.performSegue(withIdentifier: "editarOpcao", sender: self)
    }
}
