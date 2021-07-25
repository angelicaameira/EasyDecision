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
    
    var contexto: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    var decisao: CDDecisao?
    var opcao: CDOpcao?
    var alert = UIAlertController(title: "Atenção!", message: "Ocorreu um erro ao obter as opções", preferredStyle: .alert)
    
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
        guard let descricaoOpcao = descricaoTextField?.text else {
            return
        }
        if opcao == nil {
            self.opcao = CDOpcao(context: contexto)
        }
        
        self.opcao?.descricao = descricaoTextField?.text
        self.opcao?.decisao = self.decisao
        
        do {
            try contexto.save()
            navigationController?.popViewController(animated: true)
        } catch {
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "tente novamente"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print(error.localizedDescription)
        }
    }
    
    func setupView() {
        guard let opcaoSendoEditada = self.opcao else {
            return
        }
        self.descricaoTextField?.text = opcaoSendoEditada.descricao
    }
}

