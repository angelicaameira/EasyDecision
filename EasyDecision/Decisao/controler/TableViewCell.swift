//
//  CriterioTableViewCell.swift
//  EasyDecision
//
//  Created by Angélica Andrade de Meira on 09/07/21.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var peso: UILabel!
    
    var criterio: CDCriterio?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.title.text = criterio?.descricao
        self.peso.text = "\(String(describing: criterio?.peso))"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
