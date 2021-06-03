//
//  DecisaoAPI.swift
//  EasyDecision
//
//  Created by Angélica Andrade de Meira on 29/05/21.
//

import UIKit
import Foundation

class DecisaoTableViewController: UITableViewController {
    
    var decisoes: [String] = []
    
    @IBAction func botaoAdd(_ sender: Any) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return decisoes.count
    }
    
    var alterna = true
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celula = UITableViewCell(style: .default, reuseIdentifier: "celulaDeDecisao")
        //let decisao = decisoes[indexPath.row]
        let decisao = Decisao(descricao: decisoes[indexPath.row])
        celula.textLabel?.text = decisao.descricao
        return celula
    }
     
    func add(decisao: Decisao){
        decisoes.append(decisao.descricao)
        tableView.reloadData()
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? AdicionaDecisaoViewController{
            viewController.tableViewController = self
        }
    }
}
