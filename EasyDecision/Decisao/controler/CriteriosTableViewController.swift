//
//  CriteriosTableViewController.swift
//  EasyDecision
//
//  Created by Angélica Andrade de Meira on 04/07/21.
//

import Foundation
import UIKit
import SQLite

class CriteriosTableViewController: UITableViewController {
    
    var criterioSendoEditado: Criterio?
    var decisao: Decisao?
    var listaCriterios: [Criterio]?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recuperaCriterio()
        tableView.reloadData()
    }
    
    // MARK: metodos que não são da table view
    
    func recuperaCriterio() {
        do {
            self.listaCriterios = try Criterio.listaDoBanco(decisao: decisao!)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: metodos table view
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let contadorListaDeCriterios = listaCriterios?.count else { return 0 }
        return contadorListaDeCriterios
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula-criterio") as! TableViewCell
        
        guard let criterio = listaCriterios?[indexPath.row]
        else {
            return celula
        }
        
        celula.title?.text = criterio.descricao
        celula.peso?.text = "\(criterio.peso)"
        return celula
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? AdicionaCriterioViewController {
            if segue.identifier == "editarCriterio" {
                destinationViewController.criterio = self.criterioSendoEditado
                destinationViewController.decisao = self.decisao
            }
            if segue.identifier == "adicionarCriterio" {
                destinationViewController.decisao = self.decisao
            }
        }
        if let destinationViewController = segue.destination as? AvaliacaoTableViewController {
            if segue.identifier == "mostraAvaliacao" {
                destinationViewController.decisao = self.decisao
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let acoes = [
            UIContextualAction(style: .destructive, title: "Delete", handler: { [self] (contextualAction, view, _) in
                guard let criterio = self.listaCriterios?[indexPath.row] else { return }
                do {
                    try criterio.apagaNoBanco()
                    self.recuperaCriterio()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                } catch {
                    print(error.localizedDescription)
                }
            }),
            UIContextualAction(style: .normal, title: "Edit", handler: { (contextualAction, view, _) in
                self.criterioSendoEditado = self.listaCriterios?[indexPath.row]
                self.performSegue(withIdentifier: "editarCriterio", sender: contextualAction)
            })]
       
        return UISwipeActionsConfiguration(actions: acoes)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let criterioSendoEditado = listaCriterios?[indexPath.row] else { return }

        self.criterioSendoEditado = criterioSendoEditado
        self.performSegue(withIdentifier: "editarCriterio", sender: self)
    }
    
    // MARK: - fetchedResultControllerDelegate
    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        guard let indexPath = indexPath else { return }
//        switch type {
//        case .delete:
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//        default:
//            tableView.reloadData()
//        }
//    }
}
