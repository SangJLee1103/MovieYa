//
//  MovieHeaderView.swift
//  MovieYa
//
//  Created by 이상준 on 2023/09/24.
//

import UIKit
import SnapKit

class MovieHeaderView: UICollectionReusableView {
    
    static let identifier = "MovieHeaderView"
    
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.font = .boldSystemFont(ofSize: 18)
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
}
