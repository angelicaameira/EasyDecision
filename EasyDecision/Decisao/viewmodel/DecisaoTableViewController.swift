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
    var alert = UIAlertController(title: "Atenção!", message: "Ocorreu um erro ao obter as decisões", preferredStyle: .alert)
    var decisaoSelecionada: Decisao?
    var listaDecisoes: [Decisao]?
  
    // MARK: tela
    private lazy var addButton: UIBarButtonItem = {
        let view = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(goToAdicionarDecisao(sender:)))
        return view
    }()
    
    override func loadView() {
        super.loadView()
        self.view = {
            let tableView = UITableView()
            tableView.dataSource = self
            tableView.delegate = self
            return tableView
        }()
        
        self.title = "Decisões"
        self.navigationItem.setRightBarButton(addButton, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      if true { //!UserDefaults.standard.bool(forKey: "didShowOnboarding") {
            self.present(OnboardingViewController(), animated: true)
        }
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
    }
    
    //MARK: metodos
    
    func recuperaDecisao() {
        do {
            self.listaDecisoes = try Decisao.listaDoBanco().sorted { decisaoAnterior, decisaoPosterior in
                return decisaoAnterior.descricao.lowercased() < decisaoPosterior.descricao.lowercased()
            }
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
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
        return listaDecisoes?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = UITableViewCell(style: .default, reuseIdentifier: "celula-decisao")
        guard let decisao = self.listaDecisoes?[indexPath.row]
        else { return celula }
        
        celula.textLabel?.text = decisao.descricao
        celula.textLabel?.numberOfLines = 0
        celula.accessoryType = .disclosureIndicator
        
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
                    
                } catch {
                    self.alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "tente novamente"), style: .default, handler: nil))
                    self.present(self.alert, animated: true, completion: nil)
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
        tableView.deselectRow(at: indexPath, animated: true)
        guard let decisaoSelecionada = self.listaDecisoes?[indexPath.row]
        else { return }
        
        self.decisaoSelecionada = decisaoSelecionada
        self.goToMostrarOpcoes(sender: tableView)
    }
}

protocol DecisaoTableViewControllerDelegate: AnyObject {
    func recuperaDecisao()
}
