//
//  AdicionaDecisaoViewController.swift
//  EasyDecision
//
//  Created by Angélica Andrade de Meira on 31/05/21.
//

import Foundation
import UIKit
import CoreData

class AdicionaDecisaoViewController: UIViewController {
    
    var decisao: Decisao?
    
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
        salvaDecisao(sender)
    }
    
    @IBAction func salvaDecisao(_ sender: Any) {
        guard let descricaoDecisao = descricaoTextField?.text else {
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
            navigationController?.popViewController(animated: true)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func setupView() {
        guard let decisaoSelecionada = decisao else {
            return
        }
        descricaoTextField?.text = decisaoSelecionada.descricao
    }
}
