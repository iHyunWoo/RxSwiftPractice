//
//  RepositoryListTableViewCell.swift
//  GithubRepository
//
//  Created by 정현우 on 2023/01/21.
//

import UIKit
import SnapKit

class RepositoryListTableViewCell: UITableViewCell {
	static let identifier = "RepositoryListTableViewCell"
	var repository: Repository?
	
	let nameLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 15, weight: .bold)
		
		return label
	}()
	
	let descriptionLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 15, weight: .regular)
		label.numberOfLines = 2
		
		return label
	}()
	
	let starImageView: UIImageView = {
		let imageView = UIImageView()
		
		return imageView
	}()
	
	let starLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 16, weight: .regular)
		label.textColor = .gray
		
		return label
	}()
	
	let languageLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 16, weight: .regular)
		label.textColor = .gray
		
		return label
	}()
	
	override func layoutSubviews() {
		super.layoutSubviews()
		configureViews()
		configureData()
	}
	

}

extension RepositoryListTableViewCell {
	func configureViews() {
		contentView.backgroundColor = .white
		[nameLabel, descriptionLabel, starImageView, starLabel, languageLabel]
			.forEach {contentView.addSubview($0)}
		
		nameLabel.snp.makeConstraints {
			$0.top.leading.trailing.equalToSuperview().inset(18)
		}
		
		descriptionLabel.snp.makeConstraints {
			$0.top.equalTo(nameLabel.snp.bottom).offset(3)
			$0.leading.trailing.equalTo(nameLabel)
		}
		
		starImageView.snp.makeConstraints {
			$0.top.equalTo(descriptionLabel.snp.bottom).offset(8)
			$0.leading.equalTo(descriptionLabel)
			$0.width.height.equalTo(20)
			$0.bottom.equalToSuperview().inset(18)
		}
		
		starLabel.snp.makeConstraints {
			$0.centerY.equalTo(starImageView)
			$0.leading.equalTo(starImageView.snp.trailing).offset(5)
		}
		
		languageLabel.snp.makeConstraints {
			$0.centerY.equalTo(starLabel)
			$0.leading.equalTo(starLabel.snp.trailing).offset(12)
		}
		
		
	}
	
	func configureData() {
		guard let repository = repository else {return}
		nameLabel.text = repository.name
		descriptionLabel.text = repository.description
		starImageView.image = UIImage(systemName: "star")
		starLabel.text = "\(repository.stargazersCount)"
		languageLabel.text = repository.language
	}
}
