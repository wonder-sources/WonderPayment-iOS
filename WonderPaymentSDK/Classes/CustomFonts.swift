//
//  CustomFonts.swift
//  WonderPaymentSDK
//
//  Created by X on 2024/4/7.
//

import CoreText

public class CustomFonts: NSObject {

  public enum Style: CaseIterable {
    case medium
    case regular
    case semibold
    public var value: String {
      switch self {
      case .medium: return "Outfit-Medium"
      case .regular: return "Outfit-Regular"
      case .semibold: return "Outfit-SemiBold"
      }
    }
    public var font: UIFont {
      return UIFont(name: self.value, size: 14) ?? UIFont.init()
    }
  }

  // Lazy var instead of method so it's only ever called once per app session.
  public static var loadFonts: () -> Void = {
    let fontNames = Style.allCases.map { $0.value }
    for fontName in fontNames {
      loadFont(withName: fontName)
    }
    return {}
  }()

  private static func loadFont(withName fontName: String) {
    guard
      let fontURL = resBundle?.url(forResource: fontName, withExtension: "ttf"),
      let fontData = try? Data(contentsOf: fontURL) as CFData,
      let provider = CGDataProvider(data: fontData),
      let font = CGFont(provider) else {
        return
    }
    CTFontManagerRegisterGraphicsFont(font, nil)
  }

}
