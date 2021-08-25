//
//  CriterioTableViewCell.swift
//  EasyDecision
//
//  Created by Angélica Andrade de Meira on 09/07/21.
//

import UIKit

class CriterioTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var peso: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    var criterio: Criterio?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.title.text = criterio?.descricao
        self.peso.text = "\(String(describing: criterio?.peso))"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
