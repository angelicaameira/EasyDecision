//
//  ResultadoTVCell.swift
//  EasyDecision
//
//  Created by Angélica Andrade de Meira on 23/11/21.
//

import UIKit

class ResultadoTVCell: UITableViewCell {
    
    lazy var title: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var numero: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        title.textAlignment = .left
        title.textColor =  .black
        title.layer.masksToBounds = true
        numero.textAlignment = .left
        numero.textColor =  .black
        numero.layer.masksToBounds = true
        
        self.addSubview(title)
        self.addSubview(numero)
        
        title.trailingAnchor.constraint(equalTo: self.numero.leadingAnchor, constant: -15).isActive = true
        title.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        title.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
        numero.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
        numero.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
        numero.leadingAnchor.constraint(equalTo: self.title.trailingAnchor, constant: 15).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
