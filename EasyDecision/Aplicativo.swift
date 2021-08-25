//
//  Aplicativo.swift
//  EasyDecision
//
//  Created by Angélica Andrade de Meira on 18/07/21.
//

import Foundation

class iOS {
}
class EasyDecision {
    var appDelegate
    var storyboard // telas
}

var sistema = iOS()
// tocou no ícone do aplicativo
var aplicativo = EasyDecision()
aplicativo.appDelegate = AppDelegate()
aplicativo.appDelegate.application(aplicativo, didFinishLaunchingWithOptions: options)
aplicativo.procuraArquivoDeTelas()
// achou no Info.plist: telas Main.storyboard
aplicativo.storyboard = Storyboard(tela: Main.storyboard)
aplicativo.storyboard.entryPoint = UINavigationController()

var navigationController = aplicativo.storyboard.entryPoint

navigationController.rootViewController = DecisaoTableViewController()

var decisaoTableViewController = navigationController.rootViewController

decisaoTableViewController.viewDidLoad()
decisaoTableViewController.numberOfSections(in: tableView)
decisaoTableViewController.viewWillAppear()
var qtdLinhas = decisaoTableViewController.tableView(tabela, numberOfRowsInSection: secao)
for linha in qtdLinhas {
    decisaoTableViewController.tableView(tabela, cellForRowAt: linha,secao)
}
    
decisaoTableViewController.viewDidAppear()

// usuário apertou pra sair da tela
decisaoTableViewController.viewWillDisappear()
decisaoTableViewController.viewDidDisappear()
