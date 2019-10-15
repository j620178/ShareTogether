//
//  Check.swift
//  ShareTogether
//
//  Created by littlema on 2019/10/11.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation
import MapKit

extension CLLocationManager {
    
    func checkAuthorizationStatus() -> UIAlertController? {
        
        if CLLocationManager.authorizationStatus()
            == .notDetermined {

            self.requestWhenInUseAuthorization()

            self.startUpdatingLocation()

        } else if CLLocationManager.authorizationStatus()
            == .denied {

            let alertController = UIAlertController(
                title: "定位權限已關閉",
                message:
                "如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟",
                preferredStyle: .alert)
            
            let okAction = UIAlertAction(
                title: "確認", style: .default, handler: nil)
            
            alertController.addAction(okAction)
            
            return alertController

        } else if CLLocationManager.authorizationStatus()
            == .authorizedWhenInUse {

            self.startUpdatingLocation()
        }
        
        return nil
    }
}
