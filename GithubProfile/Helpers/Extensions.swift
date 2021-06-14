import Foundation
import UIKit
import Kingfisher


extension UIView {
    func lableWithText(text: String, andFont font: UIFont) -> UILabel{
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = text
        label.font = font
        return label
    }
    
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

extension UIImageView {
    
    class func imageWithUrl(url: String, isRounded: Bool) -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        if(isRounded){
            imageView.setRound()
        }
        imageView.kf.setImage(with: URL.init(string: url), options: [.loadDiskFileSynchronously,.cacheOriginalImage,.memoryCacheExpiration(.expired)]) { result in
        }
        KF.url(URL.init(string: url))
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .onSuccess { result in  }
            .set(to: imageView)
        return imageView
    }
    
    func setRound(imageWidth: CGFloat? = nil) {
        layer.cornerRadius = imageWidth != nil ? imageWidth! / 2 : (frame.width / 2)
        layer.masksToBounds = true
    }
}

extension UIButton {
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping()->()) {
        @objc class ClosureSleeve: NSObject {
            let closure:()->()
            init(_ closure: @escaping()->()) { self.closure = closure }
            @objc func invoke() { closure() }
        }
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, "\(UUID())", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}

extension UIColor {
    func colorFromHexString(_ hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if cString.count != 6 {
            return UIColor.gray
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func hexStr(hexStr: NSString, alpha: CGFloat) -> UIColor {
        let hexStr = hexStr.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: hexStr as String)
        var color: UInt32 = 0
        if scanner.scanHexInt32(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red: r, green: g, blue: b, alpha: alpha)
        } else {
            print("invalid hex string", terminator: "")
            return UIColor.white
        }
    }
}

extension UIFontDescriptor.AttributeName {
    static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}

extension UIFont {

    @objc class func mySystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.regular, size: size)!
    }

    @objc class func myBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.bold, size: size)!
    }

    @objc class func myItalicSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.italic, size: size)!
    }

    @objc convenience init(myCoder aDecoder: NSCoder) {
        if let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor {
            if let fontAttribute = fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String {
                var fontName = ""
                switch fontAttribute {
                case "CTFontRegularUsage":
                    fontName = AppFontName.regular
                case "CTFontEmphasizedUsage", "CTFontBoldUsage", "CTFontHeavyUsage":
                    fontName = AppFontName.bold
                case "CTFontObliqueUsage":
                    fontName = AppFontName.italic
                case "CTFontDemiUsage", "CTFontMediumUsage":
                    fontName = AppFontName.semiBold
                default:
                    fontName = AppFontName.regular
                }
                self.init(name: fontName, size: fontDescriptor.pointSize)!
            }
            else {
                self.init(myCoder: aDecoder)
            }
        }
        else {
            self.init(myCoder: aDecoder)
        }
    }

     class func overrideInitialize() {
        if self == UIFont.self {
           let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:)))
           let mySystemFontMethod = class_getClassMethod(self, #selector(mySystemFont(ofSize:)))
           method_exchangeImplementations(systemFontMethod!, mySystemFontMethod!)

           let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:)))
           let myBoldSystemFontMethod = class_getClassMethod(self, #selector(myBoldSystemFont(ofSize:)))
           method_exchangeImplementations(boldSystemFontMethod!, myBoldSystemFontMethod!)

           let italicSystemFontMethod = class_getClassMethod(self, #selector(italicSystemFont(ofSize:)))
           let myItalicSystemFontMethod = class_getClassMethod(self, #selector(myItalicSystemFont(ofSize:)))
           method_exchangeImplementations(italicSystemFontMethod!, myItalicSystemFontMethod!)

           let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:))) // Trick to get over the lack of UIFont.init(coder:))
           let myInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:)))
           method_exchangeImplementations(initCoderMethod!, myInitCoderMethod!)
    }
  }
}
