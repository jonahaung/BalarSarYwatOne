//
//  SceneDelegate.swift
//  BalarSarYwat
//
//  Created by Aung Ko Min on 1/11/19.
//  Copyright © 2019 Aung Ko Min. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    static var sharedInstance: SceneDelegate? {
        struct Singleton {
            static let instance = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        }
        return Singleton.instance
    }


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            window = UIWindow(windowScene: windowScene)
//            window?.tintColor = .orange
            window?.makeKeyAndVisible()
           
            
            
            PersistanceManager.shared.loadContainer {
                
                var viewControllers: [UIViewController] = [MainViewController()]
                if let folderName = userDefaults.currentStringObjectState(for: userDefaults.lastOpenedFolder), let folder = Folder.fetch(name: folderName) {
                    
                    let notesVC = NotesViewController(folder: folder)
                    viewControllers.append(notesVC)
                    if let noteName = userDefaults.currentStringObjectState(for: userDefaults.lastOpenedNote), let note = Note.fetch(title: noteName) {
                        let notePadVC = NotePadViewController(note: note)
                        viewControllers.append(notePadVC)
                    } else {
                        
                    }
                    
                }
                let navigationController = NavigationController()
                navigationController.viewControllers = viewControllers
                self.window?.rootViewController = navigationController
                StartUp.start()
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        PersistanceManager.shared.saveContext()
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        PersistanceManager.shared.saveContext()
    }


}

