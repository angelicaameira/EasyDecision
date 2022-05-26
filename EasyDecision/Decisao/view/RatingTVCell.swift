//
//  CriterioTableViewCell.swift
//  EasyDecision
//
//  Created by Angélica Andrade de Meira on 09/07/21.
//

import UIKit

class RatingTVCell: UITableViewCell {
    
    lazy var title: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var peso: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        title.textAlignment = .left
        title.textColor =  .black
        title.layer.masksToBounds = true
        peso.textAlignment = .left
        peso.textColor =  .black
        peso.layer.masksToBounds = true
        
        self.addSubview(title)
        self.addSubview(peso)
        
        title.trailingAnchor.constraint(equalTo: self.peso.leadingAnchor, constant: -15).isActive = true
        title.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        title.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
        peso.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).isActive = true
        peso.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -45).isActive = true
        peso.leadingAnchor.constraint(equalTo: self.title.trailingAnchor, constant: 15).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
