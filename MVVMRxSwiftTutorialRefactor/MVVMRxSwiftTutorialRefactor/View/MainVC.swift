//
//  MainVC.swift
//  MVVMRxSwiftTutorialRefactor
//
//  Created by 정현우 on 2023/01/24.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay

class MainVC: UIViewController {
	
	lazy var tableView: UITableView = {
		let tableView = UITableView()
		
		return tableView
	}()
	let viewModel: MainViewModel
	let disposeBag = DisposeBag()
	let articles = BehaviorRelay<[Article]>(value: [])
	
	init(viewModel: MainViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		configureViews()
		configureTableView()
		fetchArticles()
		subscribe()
	}
	
	


}

extension MainVC {
	private func configureViews() {
		view.addSubview(tableView)
		
		tableView.snp.makeConstraints {
			$0.edges.equalTo(view.safeAreaLayoutGuide)
		}
	}
	
	private func configureTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
	}
	
	private func fetchArticles() {
		viewModel.fetchNews().subscribe(onNext: { articles in
			self.articles.accept(articles)
		}).disposed(by: disposeBag)
	}
	
	private func subscribe() {
		
		articles.subscribe(onNext: { articles in
			DispatchQueue.main.async { [weak self] in
				self?.tableView.reloadData()
			}
		}).disposed(by: disposeBag)
	}
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.articles.value.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else {return UITableViewCell()}
		let viewModel = self.articles.value[indexPath.row]
		cell.viewModel.onNext(viewModel)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 120
	}
	
	
}

