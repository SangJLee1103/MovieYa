//
//  MovieCollectionViewCell.swift
//  MovieYa
//
//  Created by 이상준 on 2023/09/23.
//

import UIKit
import SnapKit
import RxSwift
import SDWebImage
import RxRelay

class MovieCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MovieCollectionViewCell"
    
    var viewModel = PublishSubject<MovieViewModel>()
    private let disposeBag = DisposeBag()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .systemGray6
        iv.layer.cornerRadius = 6
        return iv
    }()
    
    private let adultLabel: UILabel = {
        let lb = UILabel()
        lb.text = "청불"
        lb.font = .systemFont(ofSize: 11)
        lb.backgroundColor = .red
        lb.textColor = .white
        lb.isHidden = true
        lb.layer.cornerRadius = 15
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.top.trailing.leading.bottom.equalToSuperview()
        }
        
        imageView.addSubview(adultLabel)
        adultLabel.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.trailing.bottom.equalToSuperview().inset(10)
        }
    }
    
    private func bind() {
        self.viewModel.subscribe(onNext:{ movieViewModel in
            if let posterUrl = movieViewModel.posterPath {
                print(posterUrl)
                self.imageView.sd_setImage(with: URL(string: posterUrl))
            } else {
                print("없음")
            }
        }).disposed(by: disposeBag)
    }
}
