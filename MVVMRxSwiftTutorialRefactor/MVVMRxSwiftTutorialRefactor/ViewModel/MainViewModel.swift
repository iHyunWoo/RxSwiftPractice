//
//  MainViewModel.swift
//  MVVMRxSwiftTutorialRefactor
//
//  Created by 정현우 on 2023/01/24.
//

import Alamofire
import RxSwift

class MainViewModel {
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
	
	
	func fetchNews(completion: @escaping ((Error?, [Article]?) -> Void)) {
		let urlString = "https://newsapi.org/v2/everything?q=tesla&from=2022-12-23&sortBy=publishedAt&apiKey=7ed9be78aff342b8a8c7f189bf710f9c"
		
		let url = URL(string: urlString)!
		AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default)
			.validate(statusCode: 200..<300)
			.responseDecodable(of: ArticleResponse.self) { response in
				switch response.result {
				case .success(let result):
					return completion(nil, result.articles)
				case .failure(let error):
					return completion(error, nil)
				}
			}
	}
}
