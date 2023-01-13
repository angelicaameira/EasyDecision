//
//  AdicionaOpcaoViewController.swift
//  EasyDecision
//
//  Created by Angélica Andrade de Meira on 25/06/21.
//
import Foundation
import UIKit

class AdicionaOpcaoViewController: UIViewController {
    
    weak var delegate: OpcaoTableViewControllerDelegate?
    var alertError = UIAlertController(title: "Error", message: "A error occurred to receive the options", preferredStyle: .alert)
    var decisao: Decisao?
    var opcao: Opcao?
    
    //MARK: tela
    
    private lazy var descricaoTextField: UITextField = {
        let view = UITextField(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.returnKeyType = .done
        view.addTarget(self, action: #selector(clicaBotaoDoneTeclado(_:)), for: .editingDidEndOnExit)
        view.placeholder = "Insert the option description"
        view.borderStyle = .roundedRect
        return view
    }()
    
    private lazy var doneButton: UIBarButtonItem = {
        let view = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(salvaOpcao(_:)))
        return view
    }()
    
    override func loadView() {
        self.view = {
            let view = UIView()
            view.backgroundColor = .systemBackground
            return view
        }()
        
        if opcao == nil {
            self.title = "Insert option"
        } else {
            self.title = "Edit option"
        }
        self.navigationItem.setRightBarButton(doneButton, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 15.0, *) {
            self.sheetPresentationController?.detents = [.medium()]
        } else {
            // Fallback on earlier versions
        }
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
            var descricaoOpcao = descricaoTextField.text,
            let decisao = decisao
        else { return }
        
        let alert = UIAlertController(title: "Error", message: "Insert the option description to continue", preferredStyle: .alert)
        
        descricaoOpcao = descricaoOpcao.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if descricaoOpcao.isEmpty {
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Try again"), style: .default, handler: nil))
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
            navigationController?.dismiss(animated: true) { [weak self]
                in
                self?.delegate?.recuperaOpcao()
            }
        } catch {
            alertError.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Try again"), style: .default, handler: nil))
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
