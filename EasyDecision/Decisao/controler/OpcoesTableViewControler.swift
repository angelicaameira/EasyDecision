//
//  OpcoesTableViewControler.swift
//  EasyDecision
//
//  Created by Angélica Andrade de Meira on 24/06/21.
//
import Foundation
import UIKit
import CoreData

class OpcoesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var opcaoSendoEditada: Opcao?
    var decisao: Decisao?
    var gerenciadorDeResultados:NSFetchedResultsController<Opcao>?
    var contexto:NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        recuperaOpcao()
    }
    
    // MARK: metodos
    
    func recuperaOpcao() {
        let pesquisaOpcao: NSFetchRequest<Opcao> = Opcao.fetchRequest()
        let ordenacao = NSSortDescriptor(key: "descricao", ascending: true)
        pesquisaOpcao.sortDescriptors = [ordenacao]
        pesquisaOpcao.predicate = NSPredicate(format: "decisao = %@", self.decisao!)
        gerenciadorDeResultados = NSFetchedResultsController(fetchRequest: pesquisaOpcao, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
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
        guard let contadorlistaDeOpcoes = gerenciadorDeResultados?.fetchedObjects?.count else { return 0 }
        return contadorlistaDeOpcoes
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = UITableViewCell(style: .default, reuseIdentifier: "celula-opcao")
        guard let opcao = gerenciadorDeResultados?.fetchedObjects?[indexPath.row] else {
            return celula
        }
        
        celula.textLabel?.text = opcao.descricao
        return celula
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? AdicionaOpcaoViewController {
            if segue.identifier == "editarOpcao" {
                destinationViewController.opcao = self.opcaoSendoEditada
            }
        }
        if let destinationViewController = segue.destination as? AdicionaOpcaoViewController {
            if segue.identifier == "adicionarOpcao" {
                destinationViewController.decisao = self.decisao
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let acoes = [
            UIContextualAction(style: .destructive, title: "Delete", handler: { [self] (contextualAction, view, _) in
                guard let opcao = self.gerenciadorDeResultados?.fetchedObjects?[indexPath.row] else { return }
                contexto.delete(opcao)
            }),
            UIContextualAction(style: .normal, title: "Edit", handler: { (contextualAction, view, _) in
                self.opcaoSendoEditada = self.gerenciadorDeResultados?.fetchedObjects?[indexPath.row]
                self.performSegue(withIdentifier: "editarOpcao", sender: contextualAction)
            })]
        do {
            try contexto.save()
        } catch {
            print(error.localizedDescription)
            
        }
        return UISwipeActionsConfiguration(actions: acoes)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let opcaoSendoEditada = gerenciadorDeResultados?.fetchedObjects?[indexPath.row] else { return }
        //MARK: TO DO:
        //      self.opcaoSendoEditada = opcaoSendoEditada
        //      self.performSegue(withIdentifier: "proximoItem", sender: self)
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
