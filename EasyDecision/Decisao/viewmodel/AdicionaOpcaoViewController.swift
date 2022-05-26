//
//  AdicionaOpcaoViewController.swift
//  EasyDecision
//
//  Created by Angélica Andrade de Meira on 25/06/21.
//
import Foundation
import UIKit

class AdicionaOpcaoViewController: UIViewController {
    var alertError = UIAlertController(title: "Atenção!", message: "Ocorreu um erro ao obter as opções", preferredStyle: .alert)
    var decisao: Decisao?
    var opcao: Opcao?
    
    //MARK: tela
    
    private lazy var descricaoTextField: UITextField = {
        let view = UITextField(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.returnKeyType = .done
        view.addTarget(self, action: #selector(clicaBotaoDoneTeclado(_:)), for: .editingDidEndOnExit)
        view.backgroundColor = .systemBackground
        view.textColor =  .black
        view.placeholder = "insira a descrição da opção"
        view.textAlignment = .left
        view.autocapitalizationType = .none
        view.borderStyle = .roundedRect
        return view
    }()
    
    private lazy var doneButton: UIBarButtonItem = {
        let view = UIBarButtonItem(title: "feito", style: .done, target: self, action: #selector(salvaOpcao(_:)))
        return view
    }()
    
    override func loadView() {
        self.view = {
            let view = UIView()
            view.backgroundColor = .systemBackground
            return view
        }()
        
        if opcao == nil {
            self.title = "Adicionar opção"
        } else {
            self.title = "Editar opção"
        }
        self.navigationItem.setRightBarButton(doneButton, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        descricaoTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupConstraints()
    }
    
    func setupConstraints() {
        view.addSubview(descricaoTextField)
        
        descricaoTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        descricaoTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        descricaoTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
    }
    
    @objc func salvaOpcao(_ sender: Any) {
        guard
            let descricaoOpcao = descricaoTextField.text,
            let decisao = decisao
        else { return }
        
        let alert = UIAlertController(title: "Atenção", message: "Insira a descrição da opção para continuar", preferredStyle: .alert)
        
        if descricaoOpcao == "" {
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "tente novamente"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        var insert = false
        if opcao == nil {
            self.opcao = Opcao(descricao: descricaoOpcao, decisao: decisao)
            insert = true
        }
        
        opcao?.descricao = descricaoOpcao
        opcao?.decisao = decisao
        
        do {
            if insert {
                try opcao?.insereNoBanco()
            } else {
                try opcao?.atualizaNoBanco()
            }
            navigationController?.popViewController(animated: true)
        } catch {
            alertError.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "tente novamente"), style: .default, handler: nil))
            self.present(alertError, animated: true, completion: nil)
            print(error.localizedDescription)
        }
    }
    
    func setupView() {
        guard let opcaoSendoEditada = opcao
        else { return }
        
        descricaoTextField.text = opcaoSendoEditada.descricao
    }
    @objc func clicaBotaoDoneTeclado(_ sender: Any) {
        salvaOpcao(sender)
    }
}

