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
    var gerenciadorDeResultados: NSFetchedResultsController<Opcao>?
    var contexto: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    var alert = UIAlertController(title: "Atenção!", message: "Ocorreu um erro ao obter as opções", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        recuperaOpcao()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(#function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(#function)
        gerenciadorDeResultados = nil
    }
    
    // MARK: metodos que não são da table view
    
    func recuperaOpcao() {
        let pesquisaOpcao: NSFetchRequest<Opcao> = Opcao.fetchRequest()
        let ordenacao = NSSortDescriptor(key: "descricao", ascending: true)
        pesquisaOpcao.sortDescriptors = [ordenacao]
        guard let decision = self.decisao else { return }
        pesquisaOpcao.predicate = NSPredicate(format: "decisao = %@", decision)
        gerenciadorDeResultados = NSFetchedResultsController(fetchRequest: pesquisaOpcao, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
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
        print(#function)
        guard let contadorlistaDeOpcoes = gerenciadorDeResultados?.fetchedObjects?.count else { return 0 }
        return contadorlistaDeOpcoes
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(#function)
        
        let celula = UITableViewCell(style: .default, reuseIdentifier: "celula-opcao")
        
        guard let opcao = gerenciadorDeResultados?.fetchedObjects?[indexPath.row] else {
            return celula
        }
        
        celula.textLabel?.text = opcao.descricao
        return celula
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(#function)
        if let destinationViewController = segue.destination as? AdicionaOpcaoViewController {
            if segue.identifier == "editarOpcao" {
                destinationViewController.opcao = self.opcaoSendoEditada
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
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "tente novamente"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print(error.localizedDescription)
        }
        return UISwipeActionsConfiguration(actions: acoes)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        guard let opcaoSendoEditada = gerenciadorDeResultados?.fetchedObjects?[indexPath.row] else { return }
        
//        self.opcaoSendoEditada = opcaoSendoEditada
//        self.performSegue(withIdentifier: "mostraCriterios", sender: self)
    }
    
    // MARK: - fetchedResultControllerDelegate
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        print(#function)
        guard let indexPath = indexPath else { return }
        switch type {
        case .delete:
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            tableView.reloadData()
        }
    }
}
