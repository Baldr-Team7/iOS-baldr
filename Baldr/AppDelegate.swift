//
//  AppDelegate.swift
//  Baldr
//
//  Created by Thomas Emilsson on 9/23/16.
//  Copyright © 2016 Thomas Emilsson. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    var window: UIWindow?
    var container: NSPersistentContainer!

    
    
    // CORE DATA
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.container.viewContext
        //return appDelegate.persistentContainer.viewContext
    }
    
    func storeLightCell(name: String, color: String, state: Bool, expanded: Bool) {
        let context = getContext()
        
        // retrieve entity
        let entity = NSEntityDescription.entity(forEntityName: "LightCell", in: context)
        
        let transaction = NSManagedObject(entity: entity!, insertInto: context)
    
        // update entity values
        
        transaction.setValue(name, forKey: "name")
        transaction.setValue(color, forKey: "color")
        transaction.setValue(state, forKey: "state")
        transaction.setValue(expanded, forKey: "expanded")
        
        // Save Object
        
        do {
            try context.save()
            print("saved Object")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }
    
    func retrieveLightCells() {
        let fetchRequest: NSFetchRequest<LightCell> = LightCell.fetchRequest()
        
        do {
            
            let searchResults = try.getContext().fetch(fetchRequest)
            
            print("number of results = \(searchResults.count)")
            
            for lightCells in searchResults as [NSManagedObject] {
                
                print("\(lightCells.value(forKey: "name"))")
                print("\(lightCells.value(forKey: "color"))")
                print("\(lightCells.value(forKey: "state"))")
                print("\(lightCells.value(forKey: "expanded"))")
                
            }
        } catch {
            print("Error with request \(error)")
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

