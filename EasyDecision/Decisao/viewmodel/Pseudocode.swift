// MARK: - Add subviews
OnboardingView.addSubview(ScrollView)
OnboardingView.addSubview(botaoContinue)
OnboardingView.addSubview(enfeiteDoBotaoContinue)

ScrollView.addSubview(VStack)

VStack.addSubview(SaudacaoText)
VStack.addSubview(FeatureRow)

FeatureRow.addSubview(HStack) - ok

HStack.addSubview(ImageView)
HStack.addSubview(VStack)

VStack.addSubview(TituloText)
VStack.addSubview(DescricaoText)

OnboardingView {
  ScrollView {
    VStack {
      SaudacaoText
      FeatureRow {
        HStack {
          ImageView
          VStack {
            TituloText
            DescricaoText
          }
        }
      }
    }
  }
  botãoContinue
  enfeiteDoBotaoContinue
}

// MARK: - Create constraints
ScrollView.top.OnboardingView.top(0)
ScrollView.leading.OnboardingView.leading(0)
ScrollView.trailing.OnboardingView.trailing(0)
ScrollView.bottom.OnboardingView.bottom(0)

VStack.top.ScrollView.top(0)
VStack.leading.ScrollView.leading(0)
VStack.trailing.ScrollView.trailing(0)
VStack.bottom.ScrollView.bottom(0)

HStack.top.FeatureRow.top(0)
HStack.leading.FeatureRow.leading(0)
HStack.trailing.FeatureRow.trailing(0)
HStack.bottom.FeatureRow.bottom(0)



// MARK: - Hierarquia de views desejada
OnboardingView {
  ScrollView {
    VStack {
      SaudacaoText
      FeatureRow {
        HStack {
          ImageView
          VStack {
            TituloText
            DescricaoText
          }
        }
      }
    }
  }
  BlurredView -ok
  ContinueButton -ok
}
