//
//  Onboarding.swift
//  EasyDecision
//
//  Created by Angélica Andrade de Meira on 18/12/22.
//

import Foundation
import UIKit
import SwiftUI
import SQLite

#if DEBUG
@available(iOS 15.0, *)
private struct ViewControllerRepresentable: UIViewControllerRepresentable {
    let viewController = UINavigationController(rootViewController: Onboarding())
    func makeUIViewController(context: Context) -> some UIViewController {
        return viewController
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}

@available(iOS 15.0, *)
struct ViewControllerPreview: PreviewProvider {
    static var previews: some SwiftUI.View {
        ViewControllerRepresentable()
    }
}
#endif

class Onboarding: UIViewController {
    //MARK: tela
    private lazy var continuarButton: UIButton = {
        let view = UIButton()
        view.addTarget(self, action: #selector(goToContinuar), for: .touchUpInside)
        view.setTitle("Continuar", for: .normal)
        view.backgroundColor = .systemPurple
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var descricao: UILabel = {
        let view = UILabel()
        view.text = "ahjafjfhsfbashfbfhjsbfhbhjsdfbhjdsfbjsdhfbhjsdfsfbshjfbhjesfbebfhnkjnkjzbnvjkzbjsvbbdskfuhfiuslfhisueldghsuieglliuefgaisufgaluwisfghiuawlfglaigsfauisgfayusigflawiueaiulfguaielgfuilaefgaiuwalgfyifglagwfuykas"
        view.font = .systemFont(ofSize: 20)
        view.tintColor = .gray
        view.numberOfLines = .max
        view.textAlignment = .justified
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titulo: UILabel = {
        let view = UILabel()
        view.text = "Bem Vindo(a)!"
        view.font = .boldSystemFont(ofSize: 30)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .center
        
        
      
        
        
        
        return view
    }()
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        
        view.addSubview(continuarButton)
        view.addSubview(titulo)
        view.addSubview(descricao)
        
        continuarButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        continuarButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        continuarButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        
        titulo.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
        titulo.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        titulo.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        
        descricao.topAnchor.constraint(equalTo: self.titulo.bottomAnchor, constant: 30).isActive = true
        descricao.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        descricao.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
    }
    
    @objc func goToContinuar(sender: Any) {
        self.dismiss(animated: true)
        UserDefaults.standard.set(true, forKey: "didShowOnboarding")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.loadView()
        self.dismiss(animated: true)
        UserDefaults.standard.set(true, forKey: "didShowOnboarding")
    }
}
