//
//  AdicionaOpcaoViewController.swift
//  EasyDecision
//
//  Created by Angélica Andrade de Meira on 25/06/21.
//
import Foundation
import UIKit
import CoreData

class AdicionaOpcaoViewController: UIViewController {
    var alertError = UIAlertController(title: "Atenção!", message: "Ocorreu um erro ao obter as opções", preferredStyle: .alert)
    var decisao: Decisao?
    var opcao: Opcao?
    
    @IBOutlet weak var descricaoTextField: UITextField?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        descricaoTextField?.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        if opcao == nil {
            self.title = "Adicionar opção"
        } else {
            self.title = "Editar opção"
        }
    }
    
    @IBAction func clicaBotaoDoneTeclado(_ sender: Any) {
        salvaOpcao(sender)
    }
    
    @IBAction func salvaOpcao(_ sender: Any) {
        guard let descricaoOpcao = descricaoTextField?.text,
              let decisao = decisao
        else {
            return
        }
        
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
        guard let opcaoSendoEditada = opcao else {
            return
        }
        descricaoTextField?.text = opcaoSendoEditada.descricao
    }
}

