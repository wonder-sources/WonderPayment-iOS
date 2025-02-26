Pod::Spec.new do |s|
  s.name                    = "WonderPaymentSDK"
  s.version                 = "0.7.5"
  s.summary                 = "Wonder Payment SDK for iOS devices"
  s.description             = "beta testing"

  s.ios.deployment_target   = '13.0'
  s.homepage                = "https://wonder.app/"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author                  = { 'Jax' => 'yx.xuya@gmail.com' }
  s.source                  = { :git => "https://github.com/wonder-platform/WonderPayment-iOS.git", :tag => s.version.to_s}
  s.swift_versions = ['4.2', '5.0', '5.1']
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
  s.dependency "QMUIKit", "~> 4.8.0"
  s.dependency "lottie-ios", "~> 3.4.0"
  s.dependency "IQKeyboardManagerSwift", "6.3.0"
  s.dependency "TangramKit"
  s.dependency "UPPay"

  s.static_framework = true

  s.script_phases = [
      {
        :name => 'UpdateQueriesSchemes',
        :script => <<-SCRIPT,
        SCHEMES=(
                "weixin"
                "weixinULAPI"
                "weixinURLParamsAPI"
                "uppaysdk"
                "uppaywallet"
                "uppayx1"
                "uppayx2"
                "uppayx3"
                "octopus"
                "alipayhk"
                "alipays"
              )
          cd "${PODS_ROOT}/../"
          PROJECT_ROOT=`pwd`
          # 查找所有宿主工程的 Info.plist（排除 Pods 目录）
          INFOPLIST_PATH=$(find $PROJECT_ROOT -name "Info.plist" -not -path "*/Pods/*" -not -path "*/Target Support Files/*" -not -path "*/Tests/*" | head -n 1)
          if [ -z "$INFOPLIST_PATH" ]; then
            echo "⚠️警告: 未找到宿主工程Info.plist文件，请手动修改QueriesSchemes配置"
            exit 0
          fi
          
          PLIST_BUDDY="/usr/libexec/PlistBuddy"
          
          # 检查或创建 LSApplicationQueriesSchemes 数组
          if ! ${PLIST_BUDDY} -c "Print :LSApplicationQueriesSchemes" "${INFOPLIST_PATH}" &>/dev/null; then
            ${PLIST_BUDDY} -c "Add :LSApplicationQueriesSchemes array" "${INFOPLIST_PATH}" || true
            echo "✅ 创建 LSApplicationQueriesSchemes 数组"
          fi
          
          # 遍历所有需要添加的 Scheme
          for SCHEME in "${SCHEMES[@]}"; do
            # 检查是否已存在
            if ${PLIST_BUDDY} -c "Print :LSApplicationQueriesSchemes" "${INFOPLIST_PATH}" | grep -q "${SCHEME}"; then
              echo "   [已存在] ${SCHEME}"
            else
              # 添加到数组末尾
              ${PLIST_BUDDY} -c "Add :LSApplicationQueriesSchemes: string ${SCHEME}" "${INFOPLIST_PATH}" || true
              echo "   ✅ 添加 ${SCHEME}"
            fi
          done
        SCRIPT
        :execution_position => :before_compile
      }
    ]
end
