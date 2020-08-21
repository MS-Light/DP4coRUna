//
//  Wifi.swift
//  DP4coRUna
//
//  Created by User on 8/19/20.
//

import Foundation
import UIKit
import SystemConfiguration.CaptiveNetwork

struct WiFiInfo {
    var rssi: String
    var networkName: String
    var macAddress: String
}

enum WiFISignalStrength: Int {
    case weak = 0
    case ok = 1
    case veryGood = 2
    case excellent = 3

    func convertBarsToDBM() -> Int {
       switch self {
       case .weak:
           return -90
       case .ok:
           return -70
       case .veryGood:
           return -50
       case .excellent:
           return -30
       }
   }
}

class WiFiInfoService: NSObject {
    //  MARK - WiFi info
    func getWiFiInfo() -> WiFiInfo? {
        guard let interfaces = CNCopySupportedInterfaces() as? [String] else {
            return nil
        }
        var wifiInfo: WiFiInfo?
        for interface in interfaces {
            guard let interfaceInfo = CNCopyCurrentNetworkInfo(interface as CFString) as NSDictionary? else {
                return nil
            }
            guard let ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String else {
                return nil
            }
            guard let bssid = interfaceInfo[kCNNetworkInfoKeyBSSID as String] as? String else {
                return nil
            }
            var rssi: Int = 0
            if let strength = getWifiStrength() {
                rssi = strength
            }
            wifiInfo = WiFiInfo(rssi: "\(rssi)", networkName: ssid, macAddress: bssid)
            break
        }
        return wifiInfo
    }

    //  MARK - WiFi signal strength
    private func getWifiStrength() -> Int? {
        print("select phone")
        return isiPhoneX() ? getWifiStrengthOnIphoneX() : getWifiStrengthOnDevicesExceptIphoneX()
    }

    private func getWifiStrengthOnDevicesExceptIphoneX() -> Int? {
        print("Did enter get wifiStrength")
//        var rssi: Int?
//        guard let statusBar = UIApplication.shared.value(forKey: Constants.AppKeys.statusBar.rawValue) as? UIView,
//            let foregroundView = statusBar.value(forKey: Constants.AppKeys.foregroundView.rawValue) as? UIView
//        else {
//            return rssi
//        }
//        for view in foregroundView.subviews {
//           if let statusBarDataNetworkItemView = NSClassFromString("UIStatusBarDataNetworkItemView"), view.isKind(of: statusBarDataNetworkItemView) {
//              if let val = view.value(forKey: Constants.AppKeys.wifiStrengthRaw.rawValue) as? Int {
//                  rssi = val
//                  break
//              }
//           }
//        }
//        return rssi
        if let statusBarManager = UIApplication.shared.keyWindow?.windowScene?.statusBarManager,
                    let localStatusBar = statusBarManager.value(forKey: "createLocalStatusBar") as? NSObject,
                    let statusBar = localStatusBar.value(forKey: "statusBar") as? NSObject,
                    let _statusBar = statusBar.value(forKey: "_statusBar") as? UIView,
                    let currentData = _statusBar.value(forKey: "currentData")  as? NSObject,
                    let celluar = currentData.value(forKey: "cellularEntry") as? NSObject,
                    let signalStrength = celluar.value(forKey: "displayValue") as? Int {
                    print(Int(signalStrength))
                    return Int(signalStrength)
                } else {
                    print("return 0")
                    return 0
            }
    }

    private func getWifiStrengthOnIphoneX() -> Int? {
        guard let numberOfActiveBars = getWiFiNumberOfActiveBars(), let bars = WiFISignalStrength(rawValue: numberOfActiveBars) else {
            return nil
        }
        return bars.convertBarsToDBM()
    }

    private func getWiFiNumberOfActiveBars() -> Int? {
        var numberOfActiveBars: Int?
        guard let containerBar = UIApplication.shared.value(forKey: Constants.AppKeys.statusBar.rawValue) as? UIView else {
            return nil
        }
        guard let statusBarModern = NSClassFromString("UIStatusBar_Modern"), containerBar.isKind(of: statusBarModern),
              let statusBar = containerBar.value(forKey: Constants.AppKeys.statusBar.rawValue) as? UIView else {
              return nil
        }
        guard let foregroundView = statusBar.value(forKey: Constants.AppKeys.foregroundView.rawValue) as? UIView else {
            return nil
        }
        for view in foregroundView.subviews {
            for v in view.subviews {
               if let statusBarWifiSignalView = NSClassFromString("_UIStatusBarWifiSignalView"), v.isKind(of: statusBarWifiSignalView) {
                   if let val = v.value(forKey: Constants.AppKeys.numberOfActiveBars.rawValue) as? Int {
                       numberOfActiveBars = val
                       break
                   }
               }
            }
            if let _ = numberOfActiveBars {
               break
            }
        }
        return numberOfActiveBars
    }
    
    func isiPhoneX() -> Bool {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                //print(“iPhone 5 or 5S or 5C”)
                break
            case 1334:
                //print(“iPhone 6/6S/7/8”)
                break
            case 2208:
                //print(“iPhone 6+/6S+/7+/8+”)
                break
            case 2436:
                //print(“iPhone X”)
                return true
            default:
                break
            //print(“unknown”)
            }
        }
    return false
    }
}

public class Constants{
    enum AppKeys: String {
        case foregroundView         = "foregroundView"
        case numberOfActiveBars     = "numberOfActiveBars"
        case statusBar              = "statusBar"
        case wifiStrengthRaw        = "wifiStrengthRaw"
    }
}
    
