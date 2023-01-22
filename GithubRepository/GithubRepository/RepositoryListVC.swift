//
//  RepositoryListVC.swift
//  GithubRepository
//
//  Created by 정현우 on 2023/01/21.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


class RepositoryListVC: UIViewController {
	
	let tableView: UITableView = {
		let tableView = UITableView()
		
		return tableView
	}()
	
	private let organization = "Apple"
	private let repositories = BehaviorSubject<[Repository]>(value: [])
	private let disposeBag = DisposeBag()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = organization + " Repositories"
		configureRefreshControl()
		configureTableView()
		configureViews()
		
	}

}

extension RepositoryListVC {
	private func configureRefreshControl() {
		let refreshControl = UIRefreshControl()
		refreshControl.backgroundColor = .white
		refreshControl.tintColor = .darkGray
		refreshControl.attributedTitle = NSAttributedString(string: "당겨서 새로고침")
		refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
		tableView.refreshControl = refreshControl
	}
	
	private func configureTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(RepositoryListTableViewCell.self, forCellReuseIdentifier: RepositoryListTableViewCell.identifier)
//		tableView.rowHeight = 140
	}
	
	private func configureViews() {
		view.backgroundColor = .white
		view.addSubview(tableView)
		
		tableView.snp.makeConstraints {
			$0.edges.equalTo(view.safeAreaLayoutGuide)
		}
	}
	
	@objc func refresh() {
		DispatchQueue.global(qos: .background).async { [weak self] in
			guard let self = self else {return}
			self.fetchRepositories(of: self.organization)
		}
	}
	
	private func fetchRepositories(of organization: String) {
		Observable.from([organization])  // from은 배열만 받음
			.map { organization -> URL in  // organization 각각을 URL로 맵핑함
				return URL(string: "https://api.github.com/orgs/\(organization)/repos")!
			}
			.map { url -> URLRequest in  // url 각각을 URLRequest로 맵핑
				var request = URLRequest(url: url)
				request.httpMethod = "GET"
				return request
			}
			.flatMap { request -> Observable<(response: HTTPURLResponse, data: Data)> in  // flatMap은 request를 다른 Observable로 맵핑
				return URLSession.shared.rx.response(request: request)
			}
			.filter { responds, _ in
				return 200..<300 ~= responds.statusCode  // statuscode가 200..<300 사이인 경우만 통과(나머진 거름filter)
			}
			.map { _, data -> [[String: Any]] in  // 받은 data를 String:Any의 배열로 리턴
				guard let json = try? JSONSerialization.jsonObject(with: data),
					  let result = json as? [[String: Any]] else {return []}
				
				return result
			}
			.filter { result in
				result.count > 0  // 만약 디코딩이 실패하면 빈 배열이 return 되는데 이를 거름
			}
			.map { objects in
				return objects.compactMap { dic -> Repository? in  // compactMap은 nil 제거
					// Repository 모델로 디코딩
					guard let id = dic["id"] as? Int,
						  let name = dic["name"] as? String,
						  let description = dic["description"] as? String,
						  let stargazersCount = dic["stargazers_count"] as? Int,
						  let language = dic["language"] as? String else {return nil}
					
					return Repository(id: id, name: name, description: description, stargazersCount: stargazersCount, language: language)
				}
			}
			.subscribe(onNext: { [weak self] newRepositories in
				self?.repositories.onNext(newRepositories)  // 변수 repositories에 값을 넣음
				
				DispatchQueue.main.async {
					self?.tableView.reloadData()
					self?.tableView.refreshControl?.endRefreshing()
				}
			})
			.disposed(by: disposeBag)
	}
}


extension RepositoryListVC: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		do {
			return try repositories.value().count  // repositories subject에서 값을 뽑아올 수 있음
		} catch {
			return 0
		}
		
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryListTableViewCell.identifier, for: indexPath) as? RepositoryListTableViewCell else {return UITableViewCell()}
		
		var currentRepo: Repository? {
			do {
				return try repositories.value()[indexPath.row]
			} catch {
				return nil
			}
		}
		cell.repository = currentRepo
		
		return cell
	}
}
