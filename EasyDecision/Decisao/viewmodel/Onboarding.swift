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
        view.setTitle("Continue", for: .normal)
        view.backgroundColor = .systemPurple
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var descricao: UITextView = {
        let view = UITextView()
        view.text = "ahjafjfhsfbashfbfhjsbfhbhjsdfbhjdsfbjsdhfbhjsdfsfbshjfbhjesfbebfhnkjnkjzbnvjkzbjsvbbdskfuhfiuslfhisueldghsuieglliuefgaisufgaluwisfghiuawlfglaigsfauisgfayusigflawiueaiulfguaielgfuilaefgaiuwalgfyifglagwfuykas"
        view.font = .systemFont(ofSize: 14)
        view.tintColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func loadView() {
        super.loadView()
        self.title = "Bem Vindo(a)!"
        view.backgroundColor = .white
        
        view.addSubview(continuarButton)
        view.addSubview(descricao)
        
        continuarButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        continuarButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        continuarButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        
        descricao.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        descricao.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        descricao.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
 
    }
    
    @objc func goToContinuar(sender: Any) {
        self.dismiss(animated: true)
    }
}
