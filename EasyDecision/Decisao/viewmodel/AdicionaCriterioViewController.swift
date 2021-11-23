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
    
    //MARK: tela
    
    private lazy var descricaoTextField: UITextField = {
        let view = UITextField(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
      }()
    
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
        let view = UIBarButtonItem(title: "feito", style: .done, target: self, action: #selector(salvaCriterio(_:)))
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
        
        if criterio == nil {
            self.title = "Adicionar critério"
        } else {
            self.title = "Editar critério"
        }
        self.navigationItem.setRightBarButton(doneButton, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        descricaoTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
        view.backgroundColor = .systemBackground
        
        descricaoTextField.backgroundColor = .systemBackground
        descricaoTextField.textColor =  .black
        descricaoTextField.placeholder = "insira a descrição do critério"
        descricaoTextField.textAlignment = .left
        descricaoTextField.autocapitalizationType = .none
        descricaoTextField.borderStyle = .roundedRect
        
        pesoTextField.backgroundColor = .systemBackground
        pesoTextField.textColor =  .black
        pesoTextField.placeholder = "insira o peso do critério"
        pesoTextField.textAlignment = .left
        pesoTextField.autocapitalizationType = .none
        pesoTextField.borderStyle = .roundedRect
        
        
        stepper.backgroundColor = .systemBackground
        stepper.addTarget(self, action: #selector(getter: stepper), for: .touchDown)
        
        view.addSubview(descricaoTextField)
        view.addSubview(pesoTextField)
        view.addSubview(stepper)
        
        descricaoTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        descricaoTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        descricaoTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        
        pesoTextField.topAnchor.constraint(equalTo: self.descricaoTextField.bottomAnchor, constant: 20).isActive = true
        pesoTextField.trailingAnchor.constraint(equalTo: self.stepper.leadingAnchor, constant: -10).isActive = true
        pesoTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        
        stepper.topAnchor.constraint(equalTo: self.descricaoTextField.bottomAnchor, constant: 20).isActive = true
        stepper.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        stepper.leadingAnchor.constraint(equalTo: self.pesoTextField.trailingAnchor, constant: 10).isActive = true
        
    }
    
    @IBAction func clicaBotaoDoneTeclado(_ sender: Any) {
        salvaCriterio(sender)
    }
    
    @IBAction func salvaCriterio(_ sender: Any) {
        guard let descricaoCriterio = descricaoTextField.text,
              let peso = pesoTextField.text,
              let decisao = decisao else {
            return
        }
        let pesoCriterio = (peso as NSString).integerValue
        let alertError = UIAlertController(title: "Atenção", message: "Ocorreu um erro ao obter as opções", preferredStyle: .alert)
        let alert = UIAlertController(title: "Atenção", message: "Insira a descrição do critério para continuar", preferredStyle: .alert)
        
        if descricaoCriterio == "" {
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "tente novamente"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
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
            alertError.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "tente novamente"), style: .default, handler: nil))
            self.present(alertError, animated: true, completion: nil)
            print(error.localizedDescription)
        }
    }
    
    func setupView() {
        guard let criterioSendoEditado = self.criterio else {
            self.pesoTextField.text = "\(1)"
            return
        }
        self.descricaoTextField.text = criterioSendoEditado.descricao
        self.pesoTextField.text = "\(criterioSendoEditado.peso)"
        stepper.value = Double(criterioSendoEditado.peso)
        
    }
}
