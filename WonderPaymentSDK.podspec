Pod::Spec.new do |s|
  s.name                    = "WonderPaymentSDK"
  s.version                 = "0.7.8"
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

        # 自动查找当前目录下的 Xcode 项目文件（.xcodeproj）
        project_file=$(find . -maxdepth 1 -name "*.xcodeproj" -print -quit)
        if [ -z "$project_file" ]; then
          echo "⚠️ 警告：未找到 Xcode 项目文件 (.xcodeproj)，请手动添加QueriesSchemes！"
          exit 0
        fi

        # 获取所有 Targets
        echo "正在提取 Targets..."
        targets=$(xcodebuild -list -project "$project_file" | awk '/Targets:/ {flag=1; next} /^$/ {flag=0} flag {gsub(/^[[:space:]]+/, "", $0); print}')

        # 存储符合条件的 Info.plist 路径
        declare -a info_plist_files=()

        # 遍历每个 Target
        for target in $targets; do
          echo "正在检查 Target: $target"
          
          # 获取 Build Settings 并过滤应用类型
          build_settings=$(xcodebuild -target "$target" -project "$project_file" -showBuildSettings 2>/dev/null)
          if echo "$build_settings" | grep -q "PRODUCT_TYPE = com.apple.product-type.application"; then
            echo "  ✅ 是应用程序类型"
            
            # 提取 INFOPLIST_FILE 路径
            plist_path=$(echo "$build_settings" | awk -F ' *= *' '/^ *INFOPLIST_FILE *=/{print $2}')
            
            if [ -n "$plist_path" ]; then
              info_plist_files+=("$plist_path")
              echo "  ✅ 找到 Info.plist: $plist_path"
            else
              echo "  ⚠️ 未找到 INFOPLIST_FILE"
            fi
          else
            echo "  ❌ 非应用程序类型（跳过）"
          fi
        done


        for INFOPLIST_PATH in "${info_plist_files[@]}"; do
          echo "正在修改▸ $INFOPLIST_PATH"
          
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
        done
        SCRIPT
        :execution_position => :before_compile
      }
    ]
end
