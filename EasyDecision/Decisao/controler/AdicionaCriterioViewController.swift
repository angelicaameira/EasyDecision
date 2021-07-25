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
    
    var criterioCelula: TableViewCell?
    
    var contexto:NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    var decisao: CDDecisao?
    var criterio: CDCriterio?
    
    var alert = UIAlertController(title: "Atenção!", message: "Ocorreu um erro ao obter as opções", preferredStyle: .alert)
    
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
        if criterio == nil {
            self.criterio = CDCriterio(context: contexto)
        }
        
        self.criterio?.descricao = descricaoTextField?.text
        self.criterio?.peso = (pesoTextField.text! as NSString).doubleValue
        self.criterio?.decisao = self.decisao
        
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
        guard let criterioSendoEditado = self.criterio else {
            return
        }
        self.descricaoTextField?.text = criterioSendoEditado.descricao
        self.pesoTextField?.text = "\(criterioSendoEditado.peso)"
    }
}
