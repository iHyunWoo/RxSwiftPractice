//
//  SceneDelegate.swift
//  MVVMRxSwiftTutorial
//
//  Created by 정현우 on 2023/01/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?


	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		
		guard let windowScene = (scene as? UIWindowScene) else { return }
		self.window = UIWindow(windowScene: windowScene)
		let coordinator = Coordinator(window: self.window!)
		coordinator.start()

	}
}

