//
//  ViewController.swift
//  OptSortSwift
//
//  Created by Zdzislaw Sroczynski
//  All rights reserved.
//

import UIKit

public extension UIDevice {
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad6,11", "iPad6,12":                    return "iPad 5"
            case "iPad7,5", "iPad7,6":                      return "iPad 6"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
    
}

class ViewController: UIViewController {
    var RandSeed : Int32 = 1234
    
    func timeBlockWithMach(_ block: () -> Void) -> TimeInterval {
        var info = mach_timebase_info()
        guard mach_timebase_info(&info) == KERN_SUCCESS else { return -1 }
        
        let start = mach_absolute_time()
        block()
        let end = mach_absolute_time()
        
        let elapsed = end - start
        
        let nanos = elapsed * UInt64(info.numer) / UInt64(info.denom)
        return TimeInterval(nanos) / TimeInterval(NSEC_PER_SEC)
    }
    
    // Random integer, implemented as a deterministic linear congruential generator
    // with 134775813 as a and 1 as c.
    func Random(_ ARange: Int) -> Int
    {
      var Temp: Int32;
      Temp = RandSeed &* 0x08088405 + 1;
      RandSeed = Temp;
      var Temp2 : Int;
      Temp2 = Int(Int32(truncatingIfNeeded:(UInt64(ARange) &* UInt64(bitPattern:Int64(Temp))) >> 32))
      if Temp2<0 {Temp2+=ARange}
      return Int(Temp2)
    }
    
    func getSwiftVer() -> String
    {
        var v : String = "<=2.0"
        #if swift(>=5.9)
        v = "5.9"
        #elseif swift(>=5.8)
        v = "5.8"
        #elseif swift(>=5.7)
        v = "5.7"
        #elseif swift(>=5.6)
        v = "5.6"
        #elseif swift(>=5.5)
        v = "5.5"
        #elseif swift(>=5.4)
        v = "5.4"
        #elseif swift(>=5.3)
        v = "5.3"
        #elseif swift(>=5.2)
        v = "5.2"
        #elseif swift(>=5.1)
        v = "5.1"
        #elseif swift(>=5.0)
        v = "5.0"
        #elseif swift(>=4.2)
        v = "4.2"
        #elseif swift(>=4.1)
        v = "4.1"
        #elseif swift(>=4.0)
        v = "4"
        #elseif swift(>=3.0)
        v = "3"
        #elseif swift(>=2.2)
        v = "2.2"
        #elseif swift(>=2.1)
        v = "2.1"
        #endif
        return v
    }
    
    
    func doTest(_ itemsCount:Int, _ itemsToShow:Int, _ usePLColl : Bool = true, _ randomSeed:Int = 1234)
    {
        RandSeed = Int32(randomSeed)
        DispatchQueue.global(qos: .userInitiated).async {
            
            DispatchQueue.main.async {
                self.MemoLog.text = "Compiler: Swift " + self.getSwiftVer() + "\n" + "Device: " + UIDevice.modelName + " (iOS "+UIDevice.current.systemVersion+")\n"

                self.BtnDoTest.isEnabled = false
                self.view.bringSubviewToFront(self.ActInd)
                self.ActInd.startAnimating()
            }
            
    
            var names:[String] = []
            
            let chstart = Int(UnicodeScalar("A").value)
            var tmpstr : String;
            for var ii in 1...itemsCount
            {
                tmpstr = ""
                for ch in 1...(self.Random(8)+1)
                {
                    tmpstr += [Character(UnicodeScalar(chstart + self.Random(26))!)]
                }
                names.append(tmpstr)
            }
            
            names[itemsCount - 3] = "ŻÓŁWIK"
            names[itemsCount - 2] = "ŻABA"
            names[itemsCount - 1] = "ŻONA"
            names[itemsCount - 4] = "ŁĄKA"
            names[itemsCount - 5] = "ŁANIA"
            names[itemsCount - 6] = "LADA"
            names[itemsCount - 7] = "LOS"
            names[itemsCount - 8] = "ZONA"
            
            //var names = Array(repeating: "", count: maxv)
//            for i in 0...maxv-1{
//                names[i]="aaaaa"
//            }
            
            func order(_ s1: String, _ s2: String) -> Bool {
                return s1 < s2
            }
            
            
            let pllocale = Locale(identifier: "pl")
            
            func orderLoc(_ s1: String, _ s2: String) -> Bool {
                return (s1.compare(s2, locale:pllocale) == ComparisonResult.orderedAscending)
            }
            var res : Double
            if usePLColl
            {
              res = self.timeBlockWithMach{names.sort(by: orderLoc) }
            }
            else
            {
              res = self.timeBlockWithMach{names.sort(by: order) }
            }
            DispatchQueue.main.async {
                self.ActInd.stopAnimating()
                self.MemoLog.text += "Elapsed time: " + String(format:"%.3f", res) + " s."
                    for s in (itemsCount-itemsToShow)...(itemsCount-1)
                    {
                        self.MemoLog.text += "\n"+names[s]
                    }
                self.BtnDoTest.isEnabled = true
            }
        }
    }
    
    @IBOutlet weak var EditItems: UITextField!
    
    @IBOutlet weak var EditRandomSeed: UITextField!
    @IBOutlet weak var SwitchPL: UISwitch!
    @IBOutlet weak var EditItemsToShow: UITextField!
    @IBOutlet weak var ActInd: UIActivityIndicatorView!
    @IBOutlet weak var MemoLog: UITextView!
    @IBOutlet weak var BtnDoTest: UIButton!
    @IBAction func BtnDoTestClick(_ sender: Any) {
        doTest(Int(EditItems?.text ?? "0")!, Int(EditItemsToShow?.text ?? "0")!, SwitchPL.isOn, Int(EditRandomSeed?.text ?? "0")!)
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ActInd.stopAnimating()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func touchesBegan(_ touches:Set<UITouch>, with event: UIEvent?)
    {
        let dotyk:UITouch = touches.first!
        if (EditRandomSeed.isFirstResponder && dotyk.view != EditRandomSeed)
        {
            EditRandomSeed.resignFirstResponder()
        }
        if (EditItemsToShow.isFirstResponder && dotyk.view != EditItemsToShow)
        {
            EditItemsToShow.resignFirstResponder()
        }
        if (EditItems.isFirstResponder && dotyk.view != EditItems)
        {
            EditItems.resignFirstResponder()
        }
        if (MemoLog.isFirstResponder && dotyk.view != MemoLog)
        {
            MemoLog.resignFirstResponder()
        }
        super.touchesBegan(touches, with:event)
    }

}

