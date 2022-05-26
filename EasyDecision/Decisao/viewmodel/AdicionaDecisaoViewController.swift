//
//  AdicionaDecisaoViewController.swift
//  EasyDecision
//
//  Created by Angélica Andrade de Meira on 31/05/21.
//

import Foundation
import UIKit

class AdicionaDecisaoViewController: UIViewController {
    
    weak var delegate: DecisaoTableViewControllerDelegate?
    var decisao: Decisao?
    var alertError = UIAlertController(title: "Atenção!", message: "Ocorreu um erro ao obter as opções", preferredStyle: .alert)
    
    //MARK: tela
    
    private lazy var descricaoTextField: UITextField = {
        let view = UITextField(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.returnKeyType = .done
        view.addTarget(self, action: #selector(clicaBotaoDoneTeclado(_:)), for: .editingDidEndOnExit)
        view.backgroundColor = .systemBackground
        view.textColor =  .black
        view.placeholder = "insira a descrição da decisão"
        view.textAlignment = .left
        view.autocapitalizationType = .none
        view.borderStyle = .roundedRect
        return view
    }()
    
    private lazy var doneButton: UIBarButtonItem = {
        let view = UIBarButtonItem(title: "feito", style: .done, target: self, action: #selector(salvaDecisao(_:)))
        return view
    }()
    
    override func loadView() {
        self.view = {
            let view = UIView()
            view.backgroundColor = .systemBackground
            return view
        }()
        
        if decisao == nil {
            self.title = "Adicionar decisão"
        } else {
            self.title = "Editar decisão"
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.sheetPresentationController?.detents = [.medium()]
    }
    
    func setupConstraints(){
        view.addSubview(descricaoTextField)
        
        descricaoTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        descricaoTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        descricaoTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
    }
    
    @objc func salvaDecisao(_ sender: Any) {
        guard let descricaoDecisao = descricaoTextField.text
        else { return }
        
        let alert = UIAlertController(title: "Atenção", message: "Insira a descrição da decissão para continuar", preferredStyle: .alert)
        
        if descricaoDecisao == "" {
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "tente novamente"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        var insert = false
        if decisao == nil {
            decisao = Decisao(descricao: descricaoDecisao)
            insert = true
        }
        decisao?.descricao = descricaoDecisao
        
        do {
            if insert {
                try decisao?.insereNoBanco()
            } else {
                try decisao?.atualizaNoBanco()
            }
            navigationController?.dismiss(animated: true) { [weak self]
                in
                self?.delegate?.recuperaDecisao()
            }
        } catch {
            alertError.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "tente novamente"), style: .default, handler: nil))
            self.present(alertError, animated: true, completion: nil)
            print(error.localizedDescription)
        }
    }
    
    func setupView() {
        guard let decisaoSelecionada = decisao
        else { return }
        descricaoTextField.text = decisaoSelecionada.descricao
    }
    
    @objc func clicaBotaoDoneTeclado(_ sender: Any) {
        salvaDecisao(sender)
    }
    
}
