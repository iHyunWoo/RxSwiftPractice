//
//  ArticleViewModel.swift
//  MVVMRxSwiftTutorial
//
//  Created by 정현우 on 2023/01/23.
//

import Foundation

struct ArticleViewModel {
	private let article: Article
	
	var imageUrl: String? {
		return article.urlToImage
	}
	
	var title: String? {
		return article.title
	}
	
	var description: String? {
		return article.description
	}
	
	init(article: Article) {
		self.article = article
		
	}
}
