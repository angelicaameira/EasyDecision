//
//  DecisaoAPI.swift
//  EasyDecision
//
//  Created by Angélica Andrade de Meira on 29/05/21.
//

import Foundation
import UIKit

class DecisaoTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destino = segue.destination as? DetalheTableViewController {
            if segue.identifier == "gato" {
                    destino.animal = Gato(nome: "Mr Whisky", cor: "marronzinho")
                }
                if segue.identifier == "felino" {
                    destino.animal = Felino()
                }
                if segue.identifier == "leao" {
                    destino.animal = Leao()
                }
                if segue.identifier == "guepardo" {
                    destino.animal = Guepardo()
                }
                if segue.identifier == "coco" {
                    destino.animal = Coco(nome: "Mia", cor: "cor de coco")
                }
            }
        }
}
