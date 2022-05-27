//
//  AppDelegate.swift
//  FIT3178 Assignment
//
//  Created by Brandon Lim on 27/04/2022.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var databaseController: DatabaseProtocol?
    let dateFormatter = DateFormatter()
    var lastOnline: Date?
    var todayDate: String?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        databaseController = CoreDataController()
        let date = Date()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "MMMM yyyy"
       
        let _ = databaseController?.addBudget(budget: 0)
        let budget = databaseController?.fetchBudget()
        if budget == nil{
            let _ = databaseController?.addBudget(budget: 0)
        }
        
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: date)
        let currentYear = calendar.component(.year, from: date)
        
        guard let lastOnline = lastOnline else {
            return true
        }

        let lastMonth = calendar.component(.month, from: lastOnline)
        let lastYear = calendar.component(.year, from: lastOnline)
        
        if currentMonth != lastMonth || currentYear != lastYear {
            // reset category database
            // create a new instance of everything being 0
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

