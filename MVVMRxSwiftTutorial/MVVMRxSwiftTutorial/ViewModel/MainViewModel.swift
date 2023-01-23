//
//  MainViewModel.swift
//  MVVMRxSwiftTutorial
//
//  Created by 정현우 on 2023/01/23.
//

import Foundation
import RxSwift

final class MainViewModel {
	let title = "MVVM News"
	
	private let articleService: ArticleServiceProtocol
	
	init(articleService: ArticleServiceProtocol) {
		self.articleService = articleService
	}
	
	func fetchArticles() -> Observable<[ArticleViewModel]> {
		articleService.fetchNews().map {$0.map {ArticleViewModel(article: $0)}}
	}
}
