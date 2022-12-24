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
  
  private lazy var saudacaoBoasVindas: UILabel = {
    let view = UILabel()
    view.text = "Bem Vindo(a)!"
    view.font = .boldSystemFont(ofSize: 30)
    view.textAlignment = .center
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var continuarButton: UIButton = {
    let view = UIButton()
    view.addTarget(self, action: #selector(goToContinuar), for: .touchUpInside)
    view.setTitle("Continue", for: .normal)
    view.backgroundColor = .systemPurple
    view.layer.cornerRadius = 10
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var tituloFeature3: UILabel = {
    var view = UILabel()
    view.text = "Privacy policy"
    view.font = .systemFont(ofSize: 20)
    view.numberOfLines = .max
    view.textColor = .black
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var descricaoFeature3: UILabel = {
    var view = UILabel()
    view.text = "We do not collect any data whatsoever. App crash and analytics is provided by Apple only if you allow when asked by your Apple device, and is bound by Apple's privacy policy. Analytics data does not contain personal information and will only be used for fixing bugs, crashes and improving the app."
    view.font = .systemFont(ofSize: 20)
    view.textColor = .systemGray
    view.numberOfLines = .max
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var iconeFeature3: UIImageView = {
    var view = UIImageView()
    view.image = UIImage(systemName: "lock")
    view.tintColor = .systemPurple
    view.contentMode = .scaleAspectFill
    NSLayoutConstraint.activate([
      view.widthAnchor.constraint(equalToConstant: 40)
    ])
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var tituloFeature1: UILabel = {
    var view = UILabel()
    view.text = "About Easy Decision"
    view.font = .systemFont(ofSize: 20)
    view.numberOfLines = .max
    view.textColor = .black
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var descricaoFeature1: UILabel = {
    var view = UILabel()
    view.text = "Easy Decision is a app that was created to help people choose any important decisions."
    view.font = .systemFont(ofSize: 20)
    view.textColor = .systemGray
    view.numberOfLines = .max
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private lazy var tituloFeature2: UILabel = {
    var view = UILabel()
    view.text = "How it works?"
    view.font = .systemFont(ofSize: 20)
    view.textColor = .black
    view.numberOfLines = .max
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var descricaoFeature2: UILabel = {
    var view = UILabel()
    view.text = "With Easy Decision You can register your personals decisions, and the app will ask to you register some important points about each decision, like options and criteria. After, it calculate and returns with the best decision."
    view.font = .systemFont(ofSize: 20)
    view.textColor = .systemGray
    view.numberOfLines = .max
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var iconeFeature2: UIImageView = {
    var view = UIImageView()
    view.image = UIImage(systemName: "shuffle")
    view.tintColor = .systemPurple
    view.contentMode = .scaleAspectFill
    NSLayoutConstraint.activate([
      view.widthAnchor.constraint(equalToConstant: 40)
    ])
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var iconeFeature1: UIImageView = {
    var view = UIImageView()
    view.image = UIImage(systemName: "person.fill.questionmark")
    view.contentMode = .scaleAspectFill
    view.tintColor = .systemPurple
    NSLayoutConstraint.activate([view.widthAnchor.constraint(equalToConstant: 40)])
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var vStackFeature1: UIStackView = {
    var view = UIStackView(arrangedSubviews: [
      tituloFeature1,
      descricaoFeature1
    ])
    view.alignment = .leading
    view.distribution = .fillProportionally
    view.axis = .vertical
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var vStackFeature2: UIStackView = {
    var view = UIStackView(arrangedSubviews: [
      tituloFeature2,
      descricaoFeature2
    ])
    view.alignment = .leading
    view.distribution = .fillProportionally
    view.axis = .vertical
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var vStackFeature3: UIStackView = {
    var view = UIStackView(arrangedSubviews: [
      tituloFeature3,
      descricaoFeature3
    ])
    view.alignment = .leading
    view.distribution = .fillProportionally
    view.axis = .vertical
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var hStackFeature1: UIStackView = {
    var view = UIStackView(arrangedSubviews: [
      iconeFeature1,
      vStackFeature1
    ])
    view.alignment = .center
    view.distribution = .fill
    view.spacing = 15
    view.axis = .horizontal
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var hStackFeature2: UIStackView = {
    var view = UIStackView(arrangedSubviews: [
      iconeFeature2,
      vStackFeature2
    ])
    view.alignment = .center
    view.distribution = .fill
    view.spacing = 15
    view.axis = .horizontal
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var hStackFeature3: UIStackView = {
    var view = UIStackView(arrangedSubviews: [
      iconeFeature3,
      vStackFeature3
    ])
    view.alignment = .center
    view.distribution = .fill
    view.spacing = 15
    view.axis = .horizontal
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var scrollView: UIScrollView = {
    var view = UIScrollView()
    view.addSubview(saudacaoBoasVindas)
    view.addSubview(hStackFeature1)
    view.addSubview(hStackFeature2)
    view.addSubview(hStackFeature3)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var blurredView = {
    var view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
    view.insetsLayoutMarginsFromSafeArea = false
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  override func loadView() {
    super.loadView()
    view.backgroundColor = .white
  
    view.addSubview(scrollView)
    view.addSubview(blurredView)
    view.addSubview(continuarButton)
    
    NSLayoutConstraint.activate([
      blurredView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
      blurredView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
      blurredView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
      blurredView.topAnchor.constraint(equalTo: self.continuarButton.topAnchor, constant: -20),
      
      
      continuarButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
      continuarButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
      continuarButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      continuarButton.heightAnchor.constraint(equalToConstant: 50),
       
      
      saudacaoBoasVindas.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 60),
      saudacaoBoasVindas.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -10),
      saudacaoBoasVindas.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 10),
  //    saudacaoBoasVindas.bottomAnchor.constraint(equalTo: self.hStackFeature1.topAnchor, constant: -20),
      
      
      hStackFeature1.topAnchor.constraint(equalTo: self.saudacaoBoasVindas.bottomAnchor, constant: 40),
      hStackFeature1.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: 0),
      hStackFeature1.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 30),
      hStackFeature1.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
  //    hStackFeature1.bottomAnchor.constraint(equalTo: self.hStackFeature2.Anchor, constant: -20),
  //
      hStackFeature2.topAnchor.constraint(equalTo: self.hStackFeature1.bottomAnchor, constant: 20),
      hStackFeature2.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -20),
      hStackFeature2.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 30),
  //    hStackFeature1.bottomAnchor.constraint(equalTo: self.hStackFeature3.topAnchor, constant: -20),
  //
      hStackFeature3.topAnchor.constraint(equalTo: self.hStackFeature2.bottomAnchor, constant: 20),
      hStackFeature3.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -20),
      hStackFeature3.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 30),
      hStackFeature3.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: -110),
       
      
      scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
      scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
      scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
      scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
    ])
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    isModalInPresentation = true
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
