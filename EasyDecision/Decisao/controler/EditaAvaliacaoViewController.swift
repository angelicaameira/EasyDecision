//
//  AdicionaCriterioViewController.swift
//  EasyDecision
//
//  Created by Angélica Andrade de Meira on 07/07/21.
//
import Foundation
import UIKit
import CoreData

class EditaAvaliacaoViewController: UIViewController {
    
    var avaliacaoCelula: TableViewCell?
    
    var contexto:NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    var decisao: CDDecisao?
    var avaliacao: CDAvaliacao?
    
    var alert = UIAlertController(title: "Atenção!", message: "Ocorreu um erro ao obter as opções", preferredStyle: .alert)
    
    @IBOutlet weak var pesoTextField: UITextField!
    
    @IBAction func stepper(_ sender: UIStepper) {
        self.pesoTextField.text = "\(sender.value)"
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pesoTextField?.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    @IBAction func clicaBotaoDoneTeclado(_ sender: Any) {
        salvaAvaliacao(sender)
    }
    
    @IBAction func salvaAvaliacao(_ sender: Any) {
        guard let descricaoAvaliacao = pesoTextField?.text else {
            return
        }
        if avaliacao == nil {
            self.avaliacao = CDAvaliacao(context: contexto)
        }
        
        self.avaliacao?.criterio?.peso = (pesoTextField.text! as NSString).doubleValue
        self.avaliacao?.decisao = self.decisao
        
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
        guard let avaliacaoSendoEditada = self.avaliacao else {
            return
        }
        self.pesoTextField?.text = "\(avaliacaoSendoEditada.nota)"
    }
}
