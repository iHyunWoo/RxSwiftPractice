//
//  MainTableViewCell.swift
//  MVVMRxSwiftTutorialRefactor
//
//  Created by 정현우 on 2023/01/24.
//

import UIKit
import RxSwift
import SnapKit

class MainTableViewCell: UITableViewCell {
	static let identifier = "MainTableViewCell"
	
	let disposeBag = DisposeBag()
	var viewModel = PublishSubject<Article>()
	
	lazy var thumbnailImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.layer.cornerRadius = 8
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.backgroundColor = .secondarySystemBackground
		
		return imageView
	}()
	
	lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 20, weight: .bold)
		
		return label
	}()
	
	lazy var descriptionLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 3
		
		return label
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		subscribe()
		configureViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	

	
	func subscribe() {
		self.viewModel.subscribe(onNext: { article in
			self.titleLabel.text = article.title
			self.descriptionLabel.text = article.description
		}).disposed(by: disposeBag)
	}
	
	func configureViews() {
		contentView.backgroundColor = .white
		
		[thumbnailImageView, titleLabel, descriptionLabel]
			.forEach {contentView.addSubview($0)}
		
		thumbnailImageView.snp.makeConstraints {
			$0.width.height.equalTo(60)
			$0.centerY.equalToSuperview()
			$0.leading.equalToSuperview().inset(20)
		}
		
		titleLabel.snp.makeConstraints {
			$0.top.equalTo(thumbnailImageView.snp.top)
			$0.leading.equalTo(thumbnailImageView.snp.trailing).offset(20)
			$0.trailing.equalToSuperview().inset(40)
		}
		
		descriptionLabel.snp.makeConstraints {
			$0.top.equalTo(titleLabel.snp.bottom).offset(10)
			$0.leading.equalTo(titleLabel)
			$0.trailing.equalTo(titleLabel)
		}
	}

}
