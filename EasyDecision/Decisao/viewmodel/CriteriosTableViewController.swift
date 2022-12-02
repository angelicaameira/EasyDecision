//
//  CriteriosTableViewController.swift
//  EasyDecision
//
//  Created by Angélica Andrade de Meira on 04/07/21.
//

import Foundation
import UIKit
import SQLite

class CriteriosTableViewController: UITableViewController, CriterioTableViewControllerDelegate {
    var alert = UIAlertController(title: "Atenção!", message: "Ocorreu um erro ao obter os critérios", preferredStyle: .alert)
    var criterioSendoEditado: Criterio?
    var decisao: Decisao?
    var listaCriterios: [Criterio]?
    
    //MARK: tela
    
    private lazy var addButton: UIBarButtonItem = {
        let view = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(goToAdicionarCriterio(sender:)))
        return view
    }()
    
    private lazy var continuarButton: UIBarButtonItem = {
        let view = UIBarButtonItem(title: "continuar", style: .done, target: self, action: #selector(goToMostrarAvaliacao(sender:)))
        return view
    }()
    
    override func loadView() {
        self.view = {
            let tableView = UITableView()
            tableView.backgroundColor = .systemBackground
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(RatingTVCell.self, forCellReuseIdentifier: "celula-criterio")
            return tableView
        }()
        
        self.title = "Critérios"
        self.navigationItem.setRightBarButtonItems([continuarButton, addButton], animated: true)
    }
    
    @objc func goToAdicionarCriterio(sender: UIBarButtonItem){
        let telaAdicionaCriterio = AdicionaCriterioViewController()
        telaAdicionaCriterio.decisao = self.decisao
        telaAdicionaCriterio.delegate = self
        self.present(UINavigationController(rootViewController: telaAdicionaCriterio), animated: true)
    }
    
    func goToEditarCriterio(sender: Any){
        let destinationController = AdicionaCriterioViewController()
        destinationController.criterio = self.criterioSendoEditado
        destinationController.decisao = self.decisao
        destinationController.delegate = self
        self.present(UINavigationController(rootViewController: destinationController), animated: true)
    }
    
    @objc func goToMostrarAvaliacao(sender: Any) {
        let destinationController = AvaliacaoTableViewController()
        destinationController.decisao = self.decisao
        self.navigationController?.pushViewController(destinationController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recuperaCriterio()
    }
    
    // MARK: metodos que não são da table view
    
    func recuperaCriterio() {
        guard let decisao = decisao
        else { return }
        
        do {
            self.listaCriterios = try Criterio.listaDoBanco(decisao: decisao).sorted { criterioAnterior, criterioPosterior in
                return criterioAnterior.descricao.lowercased() < criterioPosterior.descricao.lowercased()
            }
            
            tableView.reloadData()
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
        guard let contadorListaDeCriterios = listaCriterios?.count
        else { return 0 }
        return contadorListaDeCriterios
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let celula = tableView.dequeueReusableCell(withIdentifier: "celula-criterio") as? RatingTVCell,
            let criterio = listaCriterios?[indexPath.row]
        else { return UITableViewCell() }
        
        celula.title.text = criterio.descricao
        celula.peso.text = "\(criterio.peso)"
        celula.accessoryType = .disclosureIndicator
        
        return celula
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let acoes = [
            UIContextualAction(style: .destructive, title: "Delete", handler: { [weak self] (contextualAction, view, _) in
                guard
                    let self = self,
                    let criterio = self.listaCriterios?[indexPath.row]
                else { return }
                
                do {
                    try criterio.apagaNoBanco()
                    self.recuperaCriterio()
                } catch {
                    self.alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "tente novamente"), style: .default, handler: nil))
                    self.present(self.alert, animated: true, completion: nil)
                    print(error.localizedDescription)
                }
            }),
            UIContextualAction(style: .normal, title: "Edit", handler: { [weak self] (contextualAction, view, _) in
                guard let self = self
                else { return }
                
                self.criterioSendoEditado = self.listaCriterios?[indexPath.row]
                self.goToEditarCriterio(sender: contextualAction)
            })]
        
        return UISwipeActionsConfiguration(actions: acoes)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let criterioSendoEditado = listaCriterios?[indexPath.row]
        else { return }
        
        self.criterioSendoEditado = criterioSendoEditado
        self.goToEditarCriterio(sender: self)
    }
}

protocol CriterioTableViewControllerDelegate: AnyObject {
    func recuperaCriterio()
}
