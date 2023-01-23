//
//  Coordinator.swift
//  MVVMRxSwiftTutorial
//
//  Created by 정현우 on 2023/01/23.
//

import UIKit

class Coordinator {
	let window: UIWindow
	
	init(window: UIWindow) {
		self.window = window
	}
	
	func start() {
		let rootVC = MainVC(viewModel: MainViewModel(articleService: ArticleService()))
		let navigationVC = UINavigationController(rootViewController: rootVC)
		window.rootViewController = navigationVC
		window.makeKeyAndVisible()
	}
}
