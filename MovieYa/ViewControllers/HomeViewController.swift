//
//  HomeViewController.swift
//  MovieYa
//
//  Created by 이상준 on 2023/09/21.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "person.crop.circle")
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProfileImg))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showImage(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showImage(true)
    }
    
    
    private func configureUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "MovieYa"
        
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(imageView)
        imageView.layer.cornerRadius = NavigationBarConst.ImageSizeForLargeState / 2
        imageView.clipsToBounds = true
        
        imageView.snp.makeConstraints {
            $0.right.equalToSuperview().inset(NavigationBarConst.ImageRightMargin)
            $0.bottom.equalToSuperview().inset(NavigationBarConst.ImageBottomMarginForLargeState)
            $0.width.height.equalTo(NavigationBarConst.ImageSizeForLargeState)
        }
    }
    
    private func moveAndResizeImage(for height: CGFloat) {
        let coeff: CGFloat = {
            let delta = height - NavigationBarConst.NavBarHeightSmallState
            let heightDifferenceBetweenStates = (NavigationBarConst.NavBarHeightLargeState - NavigationBarConst.NavBarHeightSmallState)
            return delta / heightDifferenceBetweenStates
        }()
        
        let factor = NavigationBarConst.ImageSizeForSmallState / NavigationBarConst.ImageSizeForLargeState
        
        let scale: CGFloat = {
            let sizeAddendumFactor = coeff * (1.0 - factor)
            return min(1.0, sizeAddendumFactor + factor)
        }()
        
        // Value of difference between icons for large and small states
        let sizeDiff = NavigationBarConst.ImageSizeForLargeState * (1.0 - factor) // 8.0
        let yTranslation: CGFloat = {
            /// This value = 14. It equals to difference of 12 and 6 (bottom margin for large and small states). Also it adds 8.0 (size difference when the image gets smaller size)
            let maxYTranslation = NavigationBarConst.ImageBottomMarginForLargeState - NavigationBarConst.ImageBottomMarginForSmallState + sizeDiff
            return max(0, min(maxYTranslation, (maxYTranslation - coeff * (NavigationBarConst.ImageBottomMarginForSmallState + sizeDiff))))
        }()
        
        let xTranslation = max(0, sizeDiff - coeff * sizeDiff)
        
        imageView.transform = CGAffineTransform.identity
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: xTranslation, y: yTranslation)
    }
    
    private func showImage(_ show: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.imageView.alpha = show ? 1.0 : 0.0
        }
    }
    
    @objc func didTapProfileImg() {
        print("클릭")
    }
}
