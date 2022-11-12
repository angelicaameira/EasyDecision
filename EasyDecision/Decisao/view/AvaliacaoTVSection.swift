//
//  AvaliacaoTVSection.swift
//  EasyDecision
//
//  Created by Angélica Andrade de Meira on 25/05/22.
//

import UIKit

class AvaliacaoTVSection: UITableViewHeaderFooterView {
    
    lazy var descricaoOpcao: UILabel = {
        let view = UILabel(frame: .zero)
        view.numberOfLines = 0
        view.textColor = .gray
        view.font = .boldSystemFont(ofSize: 16)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.addSubview(descricaoOpcao)
        
        descricaoOpcao.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        descricaoOpcao.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        descricaoOpcao.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        descricaoOpcao.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
