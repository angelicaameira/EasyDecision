//
//  OpcoesTableViewControler.swift
//  EasyDecision
//
//  Created by Angélica Andrade de Meira on 24/06/21.
//
import Foundation
import UIKit
import SQLite

class OpcoesTableViewController: UITableViewController, OpcaoTableViewControllerDelegate {
    
    var alert = UIAlertController(title: "Atenção!", message: "Ocorreu um erro ao obter as opções", preferredStyle: .alert)
    var opcaoSendoEditada: Opcao?
    var decisao: Decisao?
    var listaOpcoes: [Opcao]?
    
    //MARK: tela
    
    private lazy var addButton: UIBarButtonItem = {
        let view = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(goToAdicionarOpcao(sender:)))
        return view
    }()
    
    private lazy var continuarButton: UIBarButtonItem = {
        let view = UIBarButtonItem(title: "continuar", style: .done, target: self, action: #selector(goToMostrarCriterios(sender:)))
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
        
        self.title = "Opções"
        self.navigationItem.setRightBarButtonItems([continuarButton, addButton], animated: true)
    }
    
    @objc func goToAdicionarOpcao(sender: UIBarButtonItem){
        let telaAdicionaOpcao = AdicionaOpcaoViewController()
        telaAdicionaOpcao.decisao = self.decisao
        telaAdicionaOpcao.delegate = self
        self.present(UINavigationController(rootViewController: telaAdicionaOpcao), animated: true)
    }
    
    func goToEditarOpcao(sender: Any){
        let destinationController = AdicionaOpcaoViewController()
        destinationController.opcao = self.opcaoSendoEditada
        destinationController.decisao = self.decisao
        destinationController.delegate = self
        self.present(UINavigationController(rootViewController: destinationController), animated: true)
       
    }
    
    @objc func goToMostrarCriterios(sender: Any) {
        let destinationController = CriteriosTableViewController()
        destinationController.decisao = self.decisao
        self.navigationController?.pushViewController(destinationController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recuperaOpcao()
        self.tableView.reloadData()
    }
    
    // MARK: metodos que não são da table view
    
    func recuperaOpcao() {
        do {
            guard let decisao = decisao
            else { return }
            
            self.listaOpcoes = try Opcao.listaDoBanco(decisao: decisao)
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
        return listaOpcoes?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = UITableViewCell(style: .default, reuseIdentifier: "celula-opcao")
        guard let opcao = self.listaOpcoes?[indexPath.row]
        else { return celula }
        
        celula.textLabel?.text = opcao.descricao
        return celula
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let acoes = [
            UIContextualAction(style: .destructive, title: "Delete", handler: { [self] (contextualAction, view, _) in
                guard let opcao = self.listaOpcoes?[indexPath.row]
                else { return }
                
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
            UIContextualAction(style: .normal, title: "Edit", handler: { [weak self] (contextualAction, view, _) in
                guard let self = self
                else { return }
                
                self.opcaoSendoEditada = self.listaOpcoes?[indexPath.row]
                self.goToEditarOpcao(sender: contextualAction)
            })]
        return UISwipeActionsConfiguration(actions: acoes)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let opcaoSendoEditada = self.listaOpcoes?[indexPath.row]
        else { return }
        self.opcaoSendoEditada = opcaoSendoEditada
        self.goToEditarOpcao(sender: self)
    }
}

protocol OpcaoTableViewControllerDelegate: AnyObject {
    func recuperaOpcao()
}
