//
//  CriteriosTableViewController.swift
//  EasyDecision
//
//  Created by Angélica Andrade de Meira on 04/07/21.
//

import Foundation
import UIKit
import CoreData

class CriteriosTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var alert = UIAlertController(title: "Atenção!", message: "Ocorreu um erro ao obter as opções", preferredStyle: .alert)
    var criterioSendoEditado: Criterio?
    var decisao: Decisao?
    var gerenciadorDeResultados:NSFetchedResultsController<Criterio>?
    var contexto:NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recuperaCriterio()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        gerenciadorDeResultados?.delegate = nil
    }
    
    // MARK: metodos
    
    func recuperaCriterio() {
        guard let decision = self.decisao else { return }
        let pesquisaCriterio: NSFetchRequest<Criterio> = Criterio.fetchRequest()
        let ordenacao = NSSortDescriptor(key: "descricao", ascending: true)
        pesquisaCriterio.sortDescriptors = [ordenacao]
        pesquisaCriterio.predicate = NSPredicate(format: "decisao = %@", decision)
        gerenciadorDeResultados = NSFetchedResultsController(fetchRequest: pesquisaCriterio, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
        gerenciadorDeResultados?.delegate = self
        
        do {
            try gerenciadorDeResultados?.performFetch()
            tableView.reloadData()
        } catch {
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "tente novamente"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print(error.localizedDescription)
        }
    }
    
    // MARK: metodos table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let contadorListaDeCriterios = gerenciadorDeResultados?.fetchedObjects?.count else { return 0 }
        return contadorListaDeCriterios
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let celula = tableView.dequeueReusableCell(withIdentifier: "celula-criterio") as? CriterioTableViewCell else {
            return UITableViewCell()
        }
        
        guard let criterio = gerenciadorDeResultados?.fetchedObjects?[indexPath.row]
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
            }
            if segue.identifier == "adicionarCriterio" {
                destinationViewController.decisao = self.decisao
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let acoes = [
            UIContextualAction(style: .destructive, title: "Delete", handler: { [self] (contextualAction, view, _) in
                guard let criterio = self.gerenciadorDeResultados?.fetchedObjects?[indexPath.row] else { return }
                contexto.delete(criterio)
            }),
            UIContextualAction(style: .normal, title: "Edit", handler: { (contextualAction, view, _) in
                self.criterioSendoEditado = self.gerenciadorDeResultados?.fetchedObjects?[indexPath.row]
                self.performSegue(withIdentifier: "editarCriterio", sender: contextualAction)
            })]
        do {
            try contexto.save()
        } catch {
            print(error.localizedDescription)
        }
        return UISwipeActionsConfiguration(actions: acoes)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let criterioSendoEditado = gerenciadorDeResultados?.fetchedObjects?[indexPath.row] else { return }

        self.criterioSendoEditado = criterioSendoEditado
        self.performSegue(withIdentifier: "editarCriterio", sender: self)
    }
    
    // MARK: - fetchedResultControllerDelegate
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        switch type {
        case .delete:
            tableView.deleteRows(at: [indexPath], with: .fade)
        default:
            tableView.reloadData()
        }
    }
}
