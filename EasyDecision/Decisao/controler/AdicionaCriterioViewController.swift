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
    
    var alert = UIAlertController(title: "Atenção!", message: "Ocorreu um erro ao obter as opções", preferredStyle: .alert)
    var criterioCelula: TableViewCell?
    var decisao: Decisao?
    var criterio: Criterio?
    
    @IBOutlet weak var descricaoTextField: UITextField?
    
    @IBOutlet weak var pesoTextField: UITextField!
    
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
        guard let descricaoCriterio = descricaoTextField?.text else {
            return
        }
        guard let peso = pesoTextField.text else {
            return
        }
        let pesoCriterio = (peso as NSString).integerValue
        
        guard let decisao = decisao
        else { return }
        
        var insert = false
        if criterio == nil {
            self.criterio = Criterio(descricao: descricaoCriterio, peso: pesoCriterio , decisao: decisao)
            insert = true
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
            print(error.localizedDescription)
        }
    }
    
    func setupView() {
        guard let criterioSendoEditado = self.criterio else {
            return
        }
        self.descricaoTextField?.text = criterioSendoEditado.descricao
        self.pesoTextField?.text = "\(criterioSendoEditado.peso)"
    }
}
