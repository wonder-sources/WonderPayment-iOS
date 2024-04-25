Pod::Spec.new do |s|
  s.name                    = "WonderPaymentSDK"
  s.version                 = "0.2.4"
  s.summary                 = "Wonder Payment SDK for iOS devices"
  s.description             = "beta testing"

  s.ios.deployment_target   = '12.0'
  s.homepage                = "https://wonder.app/"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author                  = "Wonder Developer"
  s.source                  = { :git => "https://github.com/wonder-platform/WonderPayment-iOS.git", }
  s.resource_bundles = {
      'WonderPaymentSDK_Resources' => [
      'WonderPaymentSDK/Assets/anim/**.*',
      'WonderPaymentSDK/Assets/icons/common/**.*',
      'WonderPaymentSDK/Assets/icons/flags/**.*',
      'WonderPaymentSDK/Assets/fonts/**.*'
      ]
    }
  s.source_files = 'WonderPaymentSDK/Classes/**/*'
  s.frameworks = 'UIKit'
  s.frameworks  = 'PassKit'
  s.dependency 'AlipaySDK-iOS'
  s.dependency 'WechatOpenSDK-XCFramework'
  s.dependency 'SVGKit'
  s.dependency 'QMUIKit'
  s.dependency "lottie-ios", "~> 3.4.0"
  s.dependency "IQKeyboardManagerSwift", "6.3.0"
  s.dependency "TangramKit"
  s.dependency "UPPay"

  s.static_framework = true
end
