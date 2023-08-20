//
//  File.swift
//  NSC_iOS
//
//  Created by Dhruvit on 12/08/20.
//  Copyright © 2020 Dhruvit. All rights reserved.
//

import Foundation
import SVProgressHUD

// MARK: - Application Theme
struct Theme {
    
    static var shared = Theme()
    
    static var colors = AppColors()
    static var images = AppImages()
    static var strings = AppStrings()
    static var fonts = AppFonts()
    static var dateFormats = AppDateFormats()
    
    func changeTheme() {
        Theme.colors = AppColors()
        Theme.images = AppImages()
        Theme.strings = AppStrings()
        Theme.fonts = AppFonts()
        Theme.dateFormats = AppDateFormats()
    }
    
}


// MARK: - Application Images
struct AppImages {
    let btnBgWOShadow = UIImage(named: "btnBgWOShadow")
}


// MARK: - Application Date Formats
struct AppDateFormats {
    let backend = kbackenddate
    let backend2 = kbackend2date
    let common = kcommondate
    let navigationBarFormat = knavigationBarFormatdate
    let eventsFormat = keventsFormatdate
    let eventStartDateFormat = keventStartDateFormatdate
    let comment = kcommentdate
    let DOB_Backend = kDOB_Backenddate
    let DOB_App = kDOB_Backenddate
    let Billing_Order_App = kBilling_Order_Appdate
}


// MARK: - UIStatusBarStyle - autoDarkContent

extension UIStatusBarStyle {
    static var autoDarkContent: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
}
