//
//  AdicionaCriterioViewController.swift
//  EasyDecision
//
//  Created by Angélica Andrade de Meira on 07/07/21.
//
import Foundation
import UIKit
import CoreData

class AdicionaCriterioViewController: UIViewController {
    
    var decisao: Decisao?
    var criterio: Criterio?
    @IBOutlet weak var descricaoTextField: UITextField?
    @IBOutlet weak var pesoTextField: UITextField!
    @IBOutlet weak var stepper: UIStepper!
    
    @IBAction func stepper(_ sender: UIStepper) {
        self.pesoTextField.text = "\(sender.value)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        descricaoTextField?.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    @IBAction func clicaBotaoDoneTeclado(_ sender: Any) {
        salvaCriterio(sender)
    }
    
    @IBAction func salvaCriterio(_ sender: Any) {
        guard let descricaoCriterio = descricaoTextField?.text,
              let peso = pesoTextField.text,
              let decisao = decisao else {
            return
        }
        var pesoCriterio = (peso as NSString).integerValue
        let alert = UIAlertController(title: "Atenção!", message: "Ocorreu um erro ao obter as opções", preferredStyle: .alert)
        
        var insert = false
        if criterio == nil {
            self.criterio = Criterio(descricao: descricaoCriterio, peso: pesoCriterio , decisao: decisao)
            insert = true
        }
        
        if pesoCriterio == 0 {
            pesoCriterio = 1
        }
        
        criterio?.descricao = descricaoCriterio
        criterio?.peso = pesoCriterio
        criterio?.decisao = decisao
        
        do {
            if insert {
                try criterio?.insereNoBanco()
            } else {
                try criterio?.atualizaNoBanco()
            }
            navigationController?.popViewController(animated: true)
        } catch {
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "tente novamente"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print(error.localizedDescription)
        }
    }
    
    func setupView() {
        guard let criterioSendoEditado = self.criterio else {
            return
        }
        self.descricaoTextField?.text = criterioSendoEditado.descricao
        self.pesoTextField?.text = "\(criterioSendoEditado.peso)"
        stepper.value = Double(criterioSendoEditado.peso)
        
    }
}
