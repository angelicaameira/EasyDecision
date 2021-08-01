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
    var avaliacao: Avaliacao?
    
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
        let nota = (pesoTextField.text! as NSString).integerValue
        
        avaliacao?.nota = Int(nota)

        
        do {
            try avaliacao?.atualizaNoBanco()
            navigationController?.popViewController(animated: true)
        } catch {
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
