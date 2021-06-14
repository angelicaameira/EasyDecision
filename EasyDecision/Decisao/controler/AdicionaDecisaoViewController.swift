//
//  AdicionaDecisaoViewController.swift
//  EasyDecision
//
//  Created by Angélica Andrade de Meira on 31/05/21.
//

import Foundation
import UIKit

class AdicionaDecisaoViewController: UIViewController {
    
    var tableViewController: DecisaoTableViewController?
    @IBOutlet weak var descricaoTextField: UITextField?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        descricaoTextField?.becomeFirstResponder()
    }
    
    @IBAction func clicaBotaoDoneTeclado(_ sender: Any) {
        adicionaDecisao(sender)
    }
    
    @IBAction func adicionaDecisao(_ sender: Any) {
        guard let descricaoDecisao = descricaoTextField?.text else {
            return
        }
        
        if descricaoDecisao != "" {
            let decisao = Decisao(descricao: descricaoDecisao)
            tableViewController?.add(decisao: decisao)
        }
        navigationController?.popViewController(animated: true)
    }
}

    

