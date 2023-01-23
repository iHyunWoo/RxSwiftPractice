//
//  ArticleCollectionViewCell.swift
//  MVVMRxSwiftTutorial
//
//  Created by 정현우 on 2023/01/23.
//

import UIKit
import RxSwift
import SnapKit
import SDWebImage

class ArticleCollectionViewCell: UICollectionViewCell {
	
	static let identifier = "ArticleCollectionViewCell"
    
	let disposeBag = DisposeBag()
	var viewModel = PublishSubject<ArticleViewModel>()
	
	lazy var imageView: UIImageView = {
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
	
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configureUI()
		subscribe()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func subscribe() {
		self.viewModel.subscribe(onNext: { articleViewModel in
			if let urlString = articleViewModel.imageUrl {
				self.imageView.sd_setImage(with: URL(string: urlString))
			}
			self.titleLabel.text = articleViewModel.title
			self.descriptionLabel.text = articleViewModel.description
				
		}).disposed(by: disposeBag)
	}
	
	func configureUI() {
		contentView.backgroundColor = .white
		
		[imageView, titleLabel, descriptionLabel]
			.forEach {contentView.addSubview($0)}
		
		imageView.snp.makeConstraints {
			$0.width.height.equalTo(60)
			$0.centerY.equalToSuperview()
			$0.leading.equalToSuperview().inset(20)
		}
		
		titleLabel.snp.makeConstraints {
			$0.top.equalTo(imageView.snp.top)
			$0.leading.equalTo(imageView.snp.trailing).offset(20)
			$0.trailing.equalToSuperview().inset(40)
		}
		
		descriptionLabel.snp.makeConstraints {
			$0.top.equalTo(titleLabel.snp.bottom).offset(10)
			$0.leading.equalTo(titleLabel)
			$0.trailing.equalTo(titleLabel)
		}
	}
}
