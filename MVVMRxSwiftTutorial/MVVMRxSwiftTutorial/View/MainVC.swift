//
//  MainVC.swift
//  MVVMRxSwiftTutorial
//
//  Created by 정현우 on 2023/01/23.
//

import UIKit
import RxSwift
import RxRelay
import SnapKit

class MainVC: UIViewController {
	
	// MARK: Properties
	let disposeBag = DisposeBag()
	let viewModel: MainViewModel
	
	private lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		
		return collectionView
	}()
	
	// ~~Subject는 Observable과 Observer의 역할을 모두하는 클래스
	// ~~Relay는 Subject의 Wrapper클래스로 .completed나 .error를 발생하지 않고
	// dispose되게 전까지 계속 작동하기 때문에 UI Event에서 많이 사용
	private let articleViewModel = BehaviorRelay<[ArticleViewModel]>(value: [])
	
//	var articlesObserver: Observable<[Article]> {
//		return articles.asObservable()
//	}
	
	// MARK: Lifecycles
	init(viewModel: MainViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		configureUI()
		configureCollectionView()
		fetchArticles()
		subscribe()
    }
	
	// MARK: Configures
	func configureUI() {
		navigationItem.title = viewModel.title
		
		view.backgroundColor = .white
		
		view.addSubview(collectionView)
		collectionView.snp.makeConstraints {
			$0.edges.equalTo(view.safeAreaLayoutGuide)
		}
	}
	
	func configureCollectionView() {
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.register(ArticleCollectionViewCell.self, forCellWithReuseIdentifier: ArticleCollectionViewCell.identifier)
	}
	
	func fetchArticles() {
		viewModel.fetchArticles().subscribe(onNext: { articleViewModels in
			self.articleViewModel.accept(articleViewModels)
		}).disposed(by: disposeBag)
	}
	
	func subscribe() {
		self.articleViewModel.asObservable().subscribe(onNext: { articles in
			DispatchQueue.main.async { [weak self] in
				self?.collectionView.reloadData()
			}
			
		}).disposed(by: disposeBag)
	}

}

extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.articleViewModel.value.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArticleCollectionViewCell.identifier, for: indexPath) as? ArticleCollectionViewCell else {return UICollectionViewCell()}
		cell.imageView.image = nil
		
		let articleViewModel = self.articleViewModel.value[indexPath.row]
		cell.viewModel.onNext(articleViewModel)
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		return CGSize(width: view.frame.width, height: 120)
	}
	
	
}
