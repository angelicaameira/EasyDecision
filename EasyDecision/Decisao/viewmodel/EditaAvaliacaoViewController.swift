//
//  AdicionaCriterioViewController.swift
//  EasyDecision
//
//  Created by Angélica Andrade de Meira on 07/07/21.
//
import Foundation
import UIKit

class EditaAvaliacaoViewController: UIViewController {
    
    weak var delegate: AvaliacaoTableViewControllerDelegate?
    var alert = UIAlertController(title: "Error", message: "A error occurred to receive the options", preferredStyle: .alert)
    var avaliacaoCelula: RatingTVCell?
    var avaliacao: Avaliacao?
    
    //MARK: tela
    
    private lazy var pesoTextField: UITextField = {
        let view = UITextField(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.returnKeyType = .done
        view.addTarget(self, action: #selector(clicaBotaoDoneTeclado(_:)), for: .editingDidEndOnExit)
        view.placeholder = "Insert the Evaluate grade"
        view.borderStyle = .roundedRect
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
        let view = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(salvaAvaliacao(_:)))
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
        
        self.title = "Edit evaluate"
        self.navigationItem.setRightBarButton(doneButton, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 15.0, *) {
            self.sheetPresentationController?.detents = [.medium()]
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pesoTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupConstraints()
    }
    
    func setupConstraints(){
        view.addSubview(pesoTextField)
        view.addSubview(stepper)
        
        pesoTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        pesoTextField.trailingAnchor.constraint(equalTo: self.stepper.leadingAnchor, constant: -10).isActive = true
        pesoTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        stepper.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        stepper.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        stepper.leadingAnchor.constraint(equalTo: self.pesoTextField.trailingAnchor, constant: 10).isActive = true
    }
    
    @objc func clicaBotaoDoneTeclado(_ sender: Any) {
        salvaAvaliacao(sender)
    }
    
    @objc func salvaAvaliacao(_ sender: Any) {
        guard let peso = pesoTextField.text
        else { return }
        
        let nota = (peso as NSString).integerValue
        avaliacao?.nota = Int(nota)
        
        do {
            try avaliacao?.atualizaNoBanco()
            navigationController?.dismiss(animated: true) { [weak self]
                in
                self?.delegate?.criaAvaliacoes()
            }
        } catch {
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Try again"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print(error.localizedDescription)
        }
    }
    
    func setupView() {
        guard let avaliacaoSendoEditada = self.avaliacao
        else { return }
        
        self.pesoTextField.text = "\(avaliacaoSendoEditada.nota)"
        stepper.addTarget(self, action: #selector(getter: stepper), for: .touchDown)
    }
}
