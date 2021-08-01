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
        print(#function)
        super.viewDidLoad()
        recuperaOpcoes()
        recuperaCriterios()
        criaAvaliacoes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func criaAvaliacoes() {
        print(#function)
        guard let listaOpcoes = listaOpcoes,
              let listaCriterios = listaCriterios
        else { return }
        for opcao in listaOpcoes {
            for criterio in listaCriterios {
                let avaliacao = Avaliacao(nota: 1, decisao: decisao!, opcao: opcao, criterio: criterio)
                avaliacao.decisao = opcao.decisao
                avaliacao.opcao = opcao
                avaliacao.criterio = criterio
                
                do {
                    
                    self.listaAvaliacoes.append(avaliacao)
                    try avaliacao.insereNoBanco()
                    
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func recuperaOpcoes() {
        print(#function)
        do {
            self.listaOpcoes = try Opcao.listaDoBanco(decisao: decisao!)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func recuperaCriterios() {
        print(#function)
        do {
            self.listaCriterios = try Criterio.listaDoBanco(decisao: decisao!)
        } catch {
            print(error.localizedDescription)
        }
    }
    
//    func recuperaOpcoes() {
//        let pesquisaOpcoes: NSFetchRequest<CDOpcao> = CDOpcao.fetchRequest()
//        let ordenacao = NSSortDescriptor(key: "descricao", ascending: true)
//        pesquisaOpcoes.sortDescriptors = [ordenacao]
//        guard let decision = self.decisao else { return }
//        pesquisaOpcoes.predicate = NSPredicate(format: "decisao = %@", decision)
//        gerenciadorDeResultadosOpcao = NSFetchedResultsController(fetchRequest: pesquisaOpcoes, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
//        gerenciadorDeResultadosOpcao?.delegate = self
//
//        do {
//            try gerenciadorDeResultadosOpcao?.performFetch()
//        } catch {
//            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "tente novamente"), style: .default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//            print(error.localizedDescription)
//        }
//    }
    
//    func recuperaCriterios() {
//        let pesquisaCriterios: NSFetchRequest<CDCriterio> = CDCriterio.fetchRequest()
//        let ordenacao = NSSortDescriptor(key: "descricao", ascending: true)
//        pesquisaCriterios.sortDescriptors = [ordenacao]
//        guard let decision = self.decisao else { return }
//        pesquisaCriterios.predicate = NSPredicate(format: "decisao = %@", decision)
//        gerenciadorDeResultadosCriterios = NSFetchedResultsController(fetchRequest: pesquisaCriterios, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
//        gerenciadorDeResultadosCriterios?.delegate = self
//
//        do {
//            try gerenciadorDeResultadosCriterios?.performFetch()
//        } catch {
//            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "tente novamente"), style: .default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//            print(error.localizedDescription)
//        }
//    }
    
    // MARK: metodos table view
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        print(#function)
        guard let contadorListaDeOpcoes = listaOpcoes?.count else { return 0 }
        return contadorListaDeOpcoes
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        print(#function)
        return listaOpcoes?[section].descricao
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(#function)
        guard let contadorListaDeCriterios = listaCriterios?.count else { return 0 }
        return contadorListaDeCriterios
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(#function)
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula-criterio") as! TableViewCell
        
        let avaliacao = listaAvaliacoes[indexPath.row]
        
        celula.title?.text = avaliacao.criterio.descricao
        celula.peso?.text = "\(avaliacao.nota)"
        return celula
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(#function)
        if let destinationViewController = segue.destination as? EditaAvaliacaoViewController {
            if segue.identifier == "editarAvaliacao" {
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
        print(#function)
        let avaliacaoSendoEditada = listaAvaliacoes[indexPath.row]

        self.avaliacaoSendoEditada = avaliacaoSendoEditada
        self.performSegue(withIdentifier: "editarAvaliacao", sender: self)
    }
    // MARK: - fetchedResultControllerDelegate
    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        guard let indexPath = indexPath else { return }
//        switch type {
//        case .delete:
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//        default:
//            return
////            tableView.reloadData()
//        }
//    }
}
