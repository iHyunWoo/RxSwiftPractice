//
//  ArticleService.swift
//  MVVMRxSwiftTutorial
//
//  Created by 정현우 on 2023/01/23.
//

import Foundation
import Alamofire
import RxSwift

protocol ArticleServiceProtocol {
	func fetchNews() -> Observable<[Article]>
}

class ArticleService: ArticleServiceProtocol {
	
	func fetchNews() -> Observable<[Article]> {
		return Observable.create { (observer) -> Disposable in
			self.fetchNews { (error, articles) in
				if let error = error {
					observer.onError(error)
				}
				
				if let articles = articles {
					observer.onNext(articles)
				}
				
				observer.onCompleted()
				
			}
			return Disposables.create()
		}
	}
	
	private func fetchNews(completion: @escaping ((Error?, [Article]?) -> Void)) {
		let urlString = "https://newsapi.org/v2/everything?q=tesla&from=2022-12-23&sortBy=publishedAt&apiKey=7ed9be78aff342b8a8c7f189bf710f9c"
		
		guard let url = URL(string: urlString) else {return completion(NSError(domain: "newsapi", code: 404), nil)}
		
		AF.request(
			url, method: .get, parameters: nil, encoding: JSONEncoding.default)
			.responseDecodable(of: ArticleResponse.self) { response in
				if let error = response.error {
					return completion(error, nil)
				}
				
				if let articles = response.value?.articles {
					return completion(nil, articles)
				}
			}
	}
}
