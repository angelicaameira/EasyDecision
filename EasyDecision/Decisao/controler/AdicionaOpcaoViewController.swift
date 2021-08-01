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
    }
    
    @IBAction func clicaBotaoDoneTeclado(_ sender: Any) {
        salvaOpcao(sender)
    }
    
    @IBAction func salvaOpcao(_ sender: Any) {
        guard let descricaoOpcao = descricaoTextField?.text
        else {
            return
        }
        guard let decisao = decisao
        else { return }
        
        
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

