Pod::Spec.new do |s|
  s.name                    = "WonderPaymentSDK"
  s.version                 = "0.1.0"
  s.summary                 = "Wonder Payment SDK for iOS devices"
  s.description             = "beta testing"

  s.ios.deployment_target   = '12.0'
  s.homepage                = "https://wonder.app/"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author                  = "Wonder Developer"
  s.source                  = { :http => "https://github.com/wonder-platform/WonderPayment-iOS.git" }
  s.resource_bundles = {
      'PaymentSDK_Resources' => [
      'PaymentSDK/Assets/anim/**.*',
      'PaymentSDK/Assets/icons/common/**.*',
      'PaymentSDK/Assets/icons/flags/**.*'
      ]
    }
  s.source_files = 'PaymentSDK/Classes/**/*'
  s.frameworks = 'UIKit'
  s.frameworks  = 'PassKit'
  s.dependency 'AlipaySDK-iOS'
  s.dependency 'WechatOpenSDK-XCFramework'
  s.dependency 'SVGKit'
  s.dependency 'QMUIKit'
  s.dependency "lottie-ios", "3.3.0"
  s.static_framework = true
end