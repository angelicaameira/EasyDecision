//
//  AvaliacaoTableViewController.swift
//  EasyDecision
//
//  Created by Angélica Andrade de Meira on 14/07/21.
//

import UIKit
import Foundation
import CoreData

class AvaliacaoTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var alert = UIAlertController(title: "Atenção!", message: "Ocorreu um erro ao obter as avaliações", preferredStyle: .alert)
    var decisao: Decisao?
    var avaliacaoSendoEditada: Avaliacao?
    var criterio: Criterio?
    var gerenciadorDeResultadosOpcao: NSFetchedResultsController<Opcao>?
    var gerenciadorDeResultadosCriterios: NSFetchedResultsController<Criterio>?
    var listaAvaliacoes: [Avaliacao] = []
    var contexto: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recuperaOpcoes()
        recuperaCriterios()
        criaAvaliacoes()
        tableView.reloadData()
    }
    
    func criaAvaliacoes() {
        guard let listaOpcoes = gerenciadorDeResultadosOpcao?.fetchedObjects,
              let listaCriterios = gerenciadorDeResultadosCriterios?.fetchedObjects
        else { return }
        for opcao in listaOpcoes {
            for criterio in listaCriterios {
                let avaliacao = Avaliacao(context: self.contexto)
                avaliacao.opcao = opcao
                avaliacao.criterio = criterio
                avaliacao.decisao = opcao.decisao
                self.listaAvaliacoes.append(avaliacao)
            }
        }
    }
    
    func recuperaOpcoes() {
        let pesquisaOpcoes: NSFetchRequest<Opcao> = Opcao.fetchRequest()
        let ordenacao = NSSortDescriptor(key: "descricao", ascending: true)
        pesquisaOpcoes.sortDescriptors = [ordenacao]
        guard let decision = self.decisao else { return }
        pesquisaOpcoes.predicate = NSPredicate(format: "decisao = %@", decision)
        gerenciadorDeResultadosOpcao = NSFetchedResultsController(fetchRequest: pesquisaOpcoes, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
        gerenciadorDeResultadosOpcao?.delegate = self
        
        do {
            try gerenciadorDeResultadosOpcao?.performFetch()
        } catch {
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "tente novamente"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print(error.localizedDescription)
        }
    }
    
    func recuperaCriterios() {
        let pesquisaCriterios: NSFetchRequest<Criterio> = Criterio.fetchRequest()
        let ordenacao = NSSortDescriptor(key: "descricao", ascending: true)
        pesquisaCriterios.sortDescriptors = [ordenacao]
        guard let decision = self.decisao else { return }
        pesquisaCriterios.predicate = NSPredicate(format: "decisao = %@", decision)
        gerenciadorDeResultadosCriterios = NSFetchedResultsController(fetchRequest: pesquisaCriterios, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
        gerenciadorDeResultadosCriterios?.delegate = self
        
        do {
            try gerenciadorDeResultadosCriterios?.performFetch()
        } catch {
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "tente novamente"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print(error.localizedDescription)
        }
    }
    
    // MARK: metodos table view
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let contadorListaDeOpcoes = gerenciadorDeResultadosOpcao?.fetchedObjects?.count else { return 0 }
        return contadorListaDeOpcoes
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let opcao = listaAvaliacoes[0].opcao
        let descricao = opcao?.descricao
        return descricao
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let contadorListaDeCriterios = gerenciadorDeResultadosCriterios?.fetchedObjects?.count else { return 0 }
        return contadorListaDeCriterios
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula-criterio") as! TableViewCell
        
        let avaliacao = listaAvaliacoes[indexPath.row]
        
        celula.title?.text = avaliacao.criterio?.descricao
        celula.peso?.text = "\(avaliacao.criterio?.peso)"
        return celula
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? EditaAvaliacaoViewController {
            if segue.identifier == "editarAvaliacao" {
                destinationViewController.avaliacao = self.avaliacaoSendoEditada
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let avaliacaoSendoEditada = listaAvaliacoes[indexPath.row]

        self.avaliacaoSendoEditada = avaliacaoSendoEditada
        self.performSegue(withIdentifier: "editarAvaliacao", sender: self)
    }
    
    // MARK: - fetchedResultControllerDelegate
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        switch type {
        case .delete:
            tableView.deleteRows(at: [indexPath], with: .fade)
        default:
            return
//            tableView.reloadData()
        }
    }
}
