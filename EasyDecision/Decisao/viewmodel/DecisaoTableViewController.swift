//
//  DecisaoAPI.swift
//  EasyDecision
//
//  Created by Angélica Andrade de Meira on 29/05/21.
//
import UIKit
import Foundation
import SQLite

class DecisaoTableViewController: UITableViewController, DecisaoTableViewControllerDelegate {
    
    var alert = UIAlertController(title: "Atenção!", message: "Ocorreu um erro ao obter as opções", preferredStyle: .alert)
    var decisaoSelecionada: Decisao?
    var listaDecisoes: [Decisao]?
    
    // MARK: tela
    
    private lazy var addButton: UIBarButtonItem = {
        let view = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(goToAdicionarDecisao(sender:)))
        return view
    }()
    
    override func loadView() {
        self.view = {
            let tableView = UITableView()
            tableView.backgroundColor = .systemBackground
            tableView.dataSource = self
            tableView.delegate = self
            return tableView
        }()
        
        self.title = "Decisões"
        self.navigationItem.setRightBarButton(addButton, animated: true)
    }
    
    @objc func goToAdicionarDecisao(sender: UIBarButtonItem) {
        let destinationController = AdicionaDecisaoViewController()
        destinationController.delegate = self
        self.present(UINavigationController(rootViewController: destinationController), animated: true)
    }
    
    func goToEditarDecisao(sender: Any) {
        let destinationController = AdicionaDecisaoViewController()
        destinationController.decisao = self.decisaoSelecionada
        destinationController.delegate = self
        self.present(UINavigationController(rootViewController: destinationController), animated: true)
    }
    
    func goToMostrarOpcoes(sender: Any) {
        let destinationController = OpcoesTableViewController()
        destinationController.decisao = self.decisaoSelecionada
        self.navigationController?.pushViewController(destinationController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recuperaDecisao()
        self.tableView.reloadData()
    }
    
    //MARK: metodos
    
    func recuperaDecisao() {
        do {
            self.listaDecisoes = try Decisao.listaDoBanco()
            tableView.reloadData()
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
        guard let decisao = self.listaDecisoes?[indexPath.row]
        else { return celula }
        
        celula.textLabel?.text = decisao.descricao
        return celula
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let acoes = [
            UIContextualAction(style: .destructive, title: "Delete", handler: { [weak self] (contextualAction, view, _) in
                guard
                    let self = self,
                    let decisao = self.listaDecisoes?[indexPath.row]
                else { return }
                
                do {
                    try decisao.apagaNoBanco()
                    self.recuperaDecisao()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                } catch {
                    self.alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "tente novamente"), style: .default, handler: nil))
                    self.present(self.alert, animated: true, completion: nil)
                    print(error.localizedDescription)
                }
            }),
            UIContextualAction(style: .normal, title: "Edit", handler: { [weak self] (contextualAction, view, _) in
                guard let self = self
                else { return }
                
                self.decisaoSelecionada = self.listaDecisoes?[indexPath.row]
                self.goToEditarDecisao(sender: contextualAction)
            })]
        return UISwipeActionsConfiguration(actions: acoes)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let decisaoSelecionada = self.listaDecisoes?[indexPath.row]
        else { return }
        
        self.decisaoSelecionada = decisaoSelecionada
        self.goToMostrarOpcoes(sender: tableView)
    }
}

protocol DecisaoTableViewControllerDelegate: AnyObject {
    func recuperaDecisao()
}
