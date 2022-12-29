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

struct Feature: Identifiable {
  let id = UUID()
  let title: String
  let featureDescription: String
  let icon: String
}

let welcomeFeatures = [
  Feature(title: "About Easy Decision", featureDescription: "Easy Decision is a app that was created to help people choose any decisions.", icon: "questionmark"),
  Feature(title: "How can I use?", featureDescription: "With Easy Decision You can register your personals decisions, and the app will ask to you register some important points about each decision, like options and criterias. After, it calculate and returns with the best decision.", icon: "shuffle"),
  Feature(title: "Privacy policy", featureDescription: "We do not collect any data whatsoever. App crash and analytics is provided by Apple only if you allow when asked by your Apple device, and is bound by Apple's privacy policy. Analytics data does not contain personal information and will only be used for fixing bugs, crashes and improving the app.", icon: "shuffle"),
  Feature(title: "Feature 4", featureDescription: "TANTO FAZ O QUE ESCREVE AQUI, NÃO GASTE TEMPO COM ISSO.", icon: "shuffle")
]

#if DEBUG
@available(iOS 15.0, *)
private struct ViewControllerRepresentable: UIViewControllerRepresentable {
  let viewController = UINavigationController(rootViewController: Onboarding())
  func makeUIViewController(context: Context) -> some UIViewController {
    return viewController
  }
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}

struct ViewRepresentable: UIViewRepresentable {
  typealias UIViewType = FeatureRow
  
  func makeUIView(context: Context) -> FeatureRow {
    let featureRow = FeatureRow()
    featureRow.feature = Feature(title: "Exemplo", featureDescription: "Exemplo descrição", icon: "questionmark")
    return featureRow
  }
  
  func updateUIView(_ uiView: FeatureRow, context: Context) { }
}

@available(iOS 15.0, *)
struct ViewControllerPreview: PreviewProvider {
  static var previews: some SwiftUI.View {
    ViewControllerRepresentable()
      .previewDisplayName("Onboarding")
    ViewRepresentable()
      .previewLayout(.fixed(width: 400, height: 150))
      .previewDisplayName("FeatureRow")
  }
}
#endif

class FeatureRow: UIView {
  var feature: Feature?
  
  private var viewTitulo: UILabel {
    let view = UILabel()
    view.text = feature?.title ?? "Title test\nExample title\nTitle test\nExample title"
    view.numberOfLines = .max
    view.textColor = .label
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }
  private var viewDescricao: UILabel {
    let view = UILabel()
    view.text = feature?.featureDescription ?? "Description test\nMulti\nline\n1\n2\n3\n4\n5"
    
    view.numberOfLines = .max
    view.textColor = .secondaryLabel
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }
  private var viewIcon: UIImageView {
    let view = UIImageView()
    view.image = UIImage(systemName: feature?.icon ?? "questionmark")
    view.tintColor = .systemPurple
    view.contentMode = .scaleAspectFill
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }
  private lazy var vStack: UIStackView = { [self] in
    var view = UIStackView(arrangedSubviews: [
      viewTitulo,
      viewDescricao
    ])
    view.alignment = .leading
    view.distribution = .fillProportionally
    view.axis = .vertical
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  private lazy var hStack: UIStackView = { [self] in
    var view = UIStackView(arrangedSubviews: [
      viewIcon,
      vStack
    ])
    view.alignment = .center
    view.distribution = .fill
    view.spacing = 15
    view.axis = .horizontal
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    //      self.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(hStack)
    NSLayoutConstraint.activate([
      hStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      hStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      hStack.topAnchor.constraint(equalTo: self.topAnchor),
      hStack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    ])
  }
  
  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
}

class Onboarding: UIViewController {
  //MARK: tela
  
  var saudacaoBoasVindas: UILabel = {
    let view = UILabel()
    view.text = "Welcome to Easy Decision!"
    view.font = .boldSystemFont(ofSize: 30)
    view.textAlignment = .center
    view.numberOfLines = .max
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  var scrollView: UIScrollView = {
    var view = UIScrollView()
//    view.addSubview(saudacaoBoasVindas)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  var continuarButton: UIButton = {
    let view = UIButton()
    view.addTarget(Onboarding.self, action: #selector(goToContinuar), for: .touchUpInside)
    view.setTitle("Continue", for: .normal)
    view.backgroundColor = .systemPurple
    view.layer.cornerRadius = 10
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  var blurredView = {
    var view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
    view.insetsLayoutMarginsFromSafeArea = false
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  override func loadView() {
    super.loadView()
    view.backgroundColor = .white
    
    let featuresViewArray: [FeatureRow] = []
    for feature in welcomeFeatures {
      let featureRow = FeatureRow()
      featureRow.feature = feature
    }
    
    view.addSubview(scrollView)
    view.addSubview(blurredView)
    view.addSubview(continuarButton)
    //view.addSubview(hStack)
    //view.addSubview(vStack)
    
    NSLayoutConstraint.activate([
      blurredView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
      blurredView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
      blurredView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
      blurredView.topAnchor.constraint(equalTo: self.continuarButton.topAnchor, constant: -20),
      
      
      continuarButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
      continuarButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
      continuarButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      continuarButton.heightAnchor.constraint(equalToConstant: 50),
      
      
//              saudacaoBoasVindas.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 60),
//              saudacaoBoasVindas.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -10),
//              saudacaoBoasVindas.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 10),
      
      
      
      
      
      
//              hStack.topAnchor.constraint(equalTo: self.saudacaoBoasVindas.bottomAnchor, constant: 40),
//              hStack.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: 0),
//              hStack.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 30),
//              hStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
//              hStack.bottomAnchor.constraint(equalTo: self.hStackFeature2.Anchor, constant: -20),
      
      
      
      
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
  
  override func viewWillDisappear(_ animated: Bool) {
    super.loadView()
    self.dismiss(animated: true)
    UserDefaults.standard.set(true, forKey: "didShowOnboarding")
  }
  
  @objc func goToContinuar(sender: Any) {
    self.dismiss(animated: true)
    UserDefaults.standard.set(true, forKey: "didShowOnboarding")
  }
}

