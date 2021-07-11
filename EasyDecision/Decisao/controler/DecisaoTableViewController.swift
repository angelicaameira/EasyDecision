//
//  DecisaoAPI.swift
//  EasyDecision
//
//  Created by Angélica Andrade de Meira on 29/05/21.
//
import UIKit
import Foundation
import CoreData

class DecisaoTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var decisaoSelecionada: Decisao?
    var gerenciadorDeResultados: NSFetchedResultsController<Decisao>?
    var contexto: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recuperaDecisao()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        gerenciadorDeResultados?.delegate = nil
    }
    
    //MARK: metodos
    
    func recuperaDecisao() {
        let pesquisaDecisao: NSFetchRequest<Decisao> = Decisao.fetchRequest()
        let ordenacao = NSSortDescriptor(key: "descricao", ascending: true)
        pesquisaDecisao.sortDescriptors = [ordenacao]
        gerenciadorDeResultados = NSFetchedResultsController(fetchRequest: pesquisaDecisao, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
        gerenciadorDeResultados?.delegate = self
        
        do {
            try gerenciadorDeResultados?.performFetch()
            tableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: metodos table view
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let contadorListaDeDecisoes = gerenciadorDeResultados?.fetchedObjects?.count else { return 0 }
        return contadorListaDeDecisoes
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = UITableViewCell(style: .default, reuseIdentifier: "celula-decisao")
        guard let decisao = gerenciadorDeResultados?.fetchedObjects?[indexPath.row] else {
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
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let acoes = [
            UIContextualAction(style: .destructive, title: "Delete", handler: { [self] (contextualAction, view, _) in 
                guard let decisao = self.gerenciadorDeResultados?.fetchedObjects?[indexPath.row] else { return }
                contexto.delete(decisao)
            }),
            UIContextualAction(style: .normal, title: "Edit", handler: { (contextualAction, view, _) in
                self.decisaoSelecionada = self.gerenciadorDeResultados?.fetchedObjects?[indexPath.row]
                self.performSegue(withIdentifier: "editarDecisao", sender: contextualAction)
            })]
        
        do {
            try contexto.save()
        } catch {
            print(error.localizedDescription)
        }
        return UISwipeActionsConfiguration(actions: acoes)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let decisaoSelecionada = gerenciadorDeResultados?.fetchedObjects?[indexPath.row] else { return }
        
        self.decisaoSelecionada = decisaoSelecionada
        self.performSegue(withIdentifier: "mostraOpcoes", sender: self)
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
