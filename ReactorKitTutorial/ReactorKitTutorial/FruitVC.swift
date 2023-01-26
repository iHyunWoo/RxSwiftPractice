//
//  FruitVC.swift
//  ReactorKitTutorial
//
//  Created by 정현우 on 2023/01/26.
//

import UIKit
import ReactorKit
import RxCocoa

class FruitVC: UIViewController {
	
	// MARK: Properties
	private lazy var appleButton: UIButton = {
		let button = UIButton(type: UIButton.ButtonType.system)
		button.setTitle("사과", for: .normal)
		
		return button
	}()
	
	private lazy var bananaButton: UIButton = {
		let button = UIButton(type: UIButton.ButtonType.system)
		button.setTitle("바나나", for: .normal)
		
		return button
	}()
	
	private lazy var grapeButton: UIButton = {
		let button = UIButton(type: UIButton.ButtonType.system)
		button.setTitle("포도", for: .normal)
		
		return button
	}()
	
	private lazy var selectedLabel: UILabel = {
		let label = UILabel()
		
		return label
	}()
	
	private lazy var stackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [appleButton, bananaButton, grapeButton, selectedLabel])
		stackView.axis = .vertical
		stackView.spacing = 20
		
		return stackView
	}()
	
	// MARK: Binding Properties
	let disposeBag = DisposeBag()
	let fruitReact = FruitReactor()
	
	// MARK: Lifecycles
	override func viewDidLoad() {
		super.viewDidLoad()
		configureUI()
		bind(reactor: fruitReact)
	}
}

extension FruitVC {
	// MARK: Configures
	func configureUI() {
		view.backgroundColor = .white
		
		view.addSubview(stackView)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
	}
	
	// MARK: Helpers
	func bind(reactor: FruitReactor) {
		appleButton.rx.tap.map {FruitReactor.Action.apple}
			.bind(to: reactor.action)
			.disposed(by: disposeBag)
		
		bananaButton.rx.tap.map {FruitReactor.Action.banana}
			.bind(to: reactor.action)
			.disposed(by: disposeBag)
		
		grapeButton.rx.tap.map {FruitReactor.Action.grape}
			.bind(to: reactor.action)
			.disposed(by: disposeBag)
		
		reactor.state.map {$0.fruitName}
			.distinctUntilChanged()  // 값이 변경될때만 호출되게 중복 호출 문제 없앰
//			.map {$0}
			.subscribe(onNext: { fruitName in
				self.selectedLabel.text = fruitName
			})
			.disposed(by: disposeBag)
		
		reactor.state.map {$0.isLoading}
			.distinctUntilChanged()
			.subscribe(onNext: { isLoading in
				if isLoading == true {
					self.selectedLabel.text = "로딩중입니다"
				}
			})
			.disposed(by: disposeBag)
	}
}

