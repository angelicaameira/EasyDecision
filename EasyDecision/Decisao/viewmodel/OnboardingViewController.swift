//
//  OnboardingViewController.swift
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
  Feature(title: "Take better decisions", featureDescription: "Easy Decision helps you take decisions based on real data", icon: "questionmark"),
  Feature(title: "Easy to use", featureDescription: "Set the parameters, tell the app how important each option is to you, and Easy Decision will give you the best decision", icon: "shuffle"),
  Feature(title: "Respects your privacy", featureDescription: "Your decisions are your business and we want nothing to do with it, so we don't collect any data you type into the app", icon: "shuffle"),
  Feature(title: "No advertisements", featureDescription: "No distractions while trying to take important decisions! No annoying full page popups!", icon: "shuffle"),
]

#if DEBUG
@available(iOS 15.0, *)
private struct ViewControllerRepresentable: UIViewControllerRepresentable {
  let viewController = OnboardingViewController()
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
      .previewDisplayName("OnboardingViewController")
    ViewRepresentable()
      .previewLayout(.fixed(width: 400, height: 150))
      .previewDisplayName("FeatureRow")
  }
}
#endif

class FeatureRow: UIView {
  private var _feature: Feature?
  var feature: Feature? {
    get {
      return _feature
    }
    set {
      _feature = newValue
      viewTitulo.text = newValue?.title
      viewDescricao.text = newValue?.featureDescription
      viewIcon.image = UIImage(systemName: newValue?.icon ?? "questionmark")
    }
  }
  
  private lazy var viewTitulo: UILabel = {
    let view = UILabel()
    view.text = "Uninitialized title"
    view.numberOfLines = .max
    view.textColor = .label
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var viewDescricao: UILabel = {
    let view = UILabel()
    view.text = "Uninitialized description"
    view.numberOfLines = .max
    view.textColor = .secondaryLabel
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var viewIcon: UIImageView = {
    let view = UIImageView()
    view.image = UIImage(systemName: "questionmark")
    view.tintColor = .systemPurple
    view.contentMode = .scaleAspectFill
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
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
    view.distribution = .equalCentering
    view.spacing = 15
    view.axis = .horizontal
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(hStack)
    NSLayoutConstraint.activate([
      hStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      hStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      hStack.topAnchor.constraint(equalTo: self.topAnchor),
      hStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      
      viewTitulo.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85),
      viewDescricao.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85),
      viewIcon.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.11),
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


class OnboardingViewController: UIViewController {
  //MARK: tela
  
  private lazy var vStack: UIStackView = {
    let view = UIStackView(arrangedSubviews: [saudacaoBoasVindas])
    
    for feature in welcomeFeatures {
      let featureRow = FeatureRow()
      featureRow.feature = feature
      view.addArrangedSubview(featureRow)
    }
    
    view.alignment = .center
    view.distribution = .fillProportionally
    view.spacing = 25
    view.axis = .vertical
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var saudacaoBoasVindas: UILabel = {
    let view = UILabel()
    view.text = "Welcome to Easy Decision!"
    view.font = .boldSystemFont(ofSize: 25)
    view.textAlignment = .center
    view.numberOfLines = .max
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var scrollView: UIScrollView = {
    var view = UIScrollView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 200, right: -60)
    return view
  }()
  
  var continuarButton: UIButton = {
    let view = UIButton()
    view.addTarget(OnboardingViewController.self, action: #selector(goToContinuar), for: .touchUpInside)
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
    
    view.backgroundColor = .systemBackground
    
//    self.title = "Welcome to Easy Decision"
//    self.navigationController?.navigationBar.prefersLargeTitles = true
//    self.navigationItem.largeTitleDisplayMode = .always
    
    view.addSubview(scrollView)
    scrollView.addSubview(vStack)
    view.addSubview(blurredView)
    view.addSubview(continuarButton)
    
    NSLayoutConstraint.activate([
      saudacaoBoasVindas.heightAnchor.constraint(equalToConstant: 120),
      
      //vStack
      vStack.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 0),
      vStack.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: 0),
      vStack.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 0),
      vStack.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: 0),
      vStack.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -60),
      
      // ScrollView
      scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
      scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
      scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
      scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
      
      // BlurredView
      blurredView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
      blurredView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
      blurredView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
      blurredView.topAnchor.constraint(equalTo: self.continuarButton.topAnchor, constant: -20),
      
      // ContinuarButton
      continuarButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20),
      continuarButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
      continuarButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
      continuarButton.heightAnchor.constraint(equalToConstant: 50)
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



//Onboarding { // 182
//  ScrollView {// 181
//    vStack { // 184
//      saudacaoBoasVindas //134
//      FeatureRow {//135
//        HStack { //115
//          viewIcon //101
//          vStack {//102
//            titulo //90
//            descricao // 91
//          }
//        }
//      }
//    }
//  }
//  blurredView //182
//  continuarButton //183
//}
