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
   
    var alert = UIAlertController(title: "Atenção!", message: "Ocorreu um erro ao obter as opções", preferredStyle: .alert)
    var avaliacaoCelula: RatingTVCell?
    var avaliacao: Avaliacao?
    
    //MARK: tela
    
    private lazy var pesoTextField: UITextField = {
        let view = UITextField(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
      }()
    
    @objc private lazy var stepper: UIStepper = {
        let view = UIStepper(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(stepper(_:)), for: .valueChanged)
        view.minimumValue = 1
        view.maximumValue = 5
        return view
      }()
    
    private lazy var doneButton: UIBarButtonItem = {
        let view = UIBarButtonItem(title: "feito", style: .done, target: self, action: #selector(salvaAvaliacao(_:)))
        return view
    }()
    
    @objc func stepper(_ sender: UIStepper) {
        self.pesoTextField.text = NumberFormatter.localizedString(from: NSNumber(value: sender.value), number: .decimal)
    }
    
    override func loadView() {
        self.view = {
            let view = UIView()
            view.backgroundColor = .systemBackground
            return view
        }()
        
        self.title = "Editar Avaliação"
        self.navigationItem.setRightBarButton(doneButton, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pesoTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
        view.backgroundColor = .systemBackground
        
        pesoTextField.backgroundColor = .systemBackground
        pesoTextField.textColor =  .black
        pesoTextField.placeholder = "insira a nota da avaliação"
        pesoTextField.textAlignment = .left
        pesoTextField.autocapitalizationType = .none
        pesoTextField.borderStyle = .roundedRect
        
        
        stepper.backgroundColor = .systemBackground
        stepper.addTarget(self, action: #selector(getter: stepper), for: .touchDown)
        
        view.addSubview(pesoTextField)
        view.addSubview(stepper)
        
        pesoTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        pesoTextField.trailingAnchor.constraint(equalTo: self.stepper.leadingAnchor, constant: -10).isActive = true
        pesoTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        
        stepper.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        stepper.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        stepper.leadingAnchor.constraint(equalTo: self.pesoTextField.trailingAnchor, constant: 10).isActive = true
        
    }
    
    @IBAction func clicaBotaoDoneTeclado(_ sender: Any) {
        salvaAvaliacao(sender)
    }
    
    @IBAction func salvaAvaliacao(_ sender: Any) {
        guard let peso = pesoTextField.text else {
            return
        }
        let nota = (peso as NSString).integerValue
        
        avaliacao?.nota = Int(nota)

        do {
            try avaliacao?.atualizaNoBanco()
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
        self.pesoTextField.text = "\(avaliacaoSendoEditada.nota)"
    }
}
