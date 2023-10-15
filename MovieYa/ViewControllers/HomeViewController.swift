//
//  HomeViewController.swift
//  MovieYa
//
//  Created by 이상준 on 2023/09/21.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class HomeViewController: UICollectionViewController {
    private let viewModel: HomeViewModel
    private let disposeBag = DisposeBag()
    
    private let nowPlayingViewModel = BehaviorRelay<[MovieViewModel]>(value: [])
    private let popularViewModel = BehaviorRelay<[MovieViewModel]>(value: [])
    private let topRatedViewModel = BehaviorRelay<[MovieViewModel]>(value: [])
    private let upcomingViewModel = BehaviorRelay<[MovieViewModel]>(value: [])
    
    var nowPlayingViewModelObserver: Observable<[MovieViewModel]> {
        return nowPlayingViewModel.asObservable()
    }
    
    var popularViewModelObserver: Observable<[MovieViewModel]> {
        return popularViewModel.asObservable()
    }
    
    var topRatedViewModelObserver: Observable<[MovieViewModel]> {
        return topRatedViewModel.asObservable()
    }
    
    var upcomingViewModelObserver: Observable<[MovieViewModel]> {
        return upcomingViewModel.asObservable()
    }
    
    private var sections: [HomeSection] = [.nowPlaying, .popular, .topRated, .upcoming]
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "person.crop.circle")
        iv.image?.withTintColor(.white)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProfileImg))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    init(collectionViewLayout: UICollectionViewLayout, viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: collectionViewLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchMovieList()
        subscribe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
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
        navigationItem.title = "MovieYa"
        navigationController?.navigationBar.tintColor = .white
        
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        
        navigationBar.addSubview(imageView)
        imageView.layer.cornerRadius = NavigationBarConst.ImageSizeForLargeState / 2
        imageView.clipsToBounds = true
        
        imageView.snp.makeConstraints {
            $0.right.equalToSuperview().inset(NavigationBarConst.ImageRightMargin)
            $0.bottom.equalToSuperview().inset(NavigationBarConst.ImageBottomMarginForLargeState)
            $0.width.height.equalTo(NavigationBarConst.ImageSizeForLargeState)
        }
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .black
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.register(MovieHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MovieHeaderView.identifier)
    }
    
    private func fetchMovieList() {
        Observable.combineLatest(
            viewModel.fetchNowPlaying(),
            viewModel.fetchPopular(),
            viewModel.fetchTopRated(),
            viewModel.fetchUpcoming()
        ) { nowPlaying, popular, topRated, upcoming in
            return (nowPlaying, popular, topRated, upcoming)
        }
        .subscribe(onNext: { [weak self] data in
            let (nowPlaying, popular, topRated, upcoming) = data
            self?.nowPlayingViewModel.accept(nowPlaying)
            self?.popularViewModel.accept(popular)
            self?.topRatedViewModel.accept(topRated)
            self?.upcomingViewModel.accept(upcoming)
        }).disposed(by: disposeBag)
        
//        viewModel.fetchNowPlaying().subscribe(onNext: { [weak self] movieViewModel in
//            self?.nowPlayingViewModel.accept(movieViewModel)
//        }).disposed(by: disposeBag)
//        
//        viewModel.fetchPopular().subscribe(onNext: { [weak self] movieViewModel in
//            self?.popularViewModel.accept(movieViewModel)
//        }).disposed(by: disposeBag)
//        
//        viewModel.fetchTopRated().subscribe(onNext: { [weak self] movieViewModel in
//            self?.topRatedViewModel.accept(movieViewModel)
//        }).disposed(by: disposeBag)
//        
//        viewModel.fetchUpcoming().subscribe(onNext: { [weak self] movieViewModel in
//            self?.upcomingViewModel.accept(movieViewModel)
//        }).disposed(by: disposeBag)
    }
    
    private func subscribe() {
        Observable.combineLatest(
            nowPlayingViewModelObserver,
            popularViewModelObserver,
            topRatedViewModelObserver,
            upcomingViewModelObserver
        ) { nowPlaying, popular, topRated, upcoming in
            return [nowPlaying, popular, topRated, upcoming]
        }
        .subscribe(onNext: { [weak self] movies in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }).disposed(by: disposeBag)
        
//
//        nowPlayingViewModelObserver
//            .subscribe(onNext: { [weak self] movies in
//                guard let section = (self?.sections.firstIndex { $0 == .nowPlaying }) else { return }
//                self?.collectionView.reloadSections([section])
//        }).disposed(by: disposeBag)
//        
//        popularViewModelObserver
//            .subscribe(onNext: { [weak self] movies in
//                guard let section = (self?.sections.firstIndex { $0 == .popular }) else { return }
//                self?.collectionView.reloadSections([section])
//        }).disposed(by: disposeBag)
//        
//        topRatedViewModelObserver
//            .subscribe(onNext: { [weak self] movies in
//                guard let section = (self?.sections.firstIndex { $0 == .topRated }) else { return }
//                self?.collectionView.reloadSections([section])
//        }).disposed(by: disposeBag)
//        
//        upcomingViewModelObserver
//            .subscribe(onNext: { [weak self] movies in
//                guard let section = (self?.sections.firstIndex { $0 == .upcoming }) else { return }
//                self?.collectionView.reloadSections([section])
//        }).disposed(by: disposeBag)
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

extension HomeViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch sections[section] {
        case .nowPlaying:
            return nowPlayingViewModel.value.count
        case .popular:
            return popularViewModel.value.count
        case .topRated:
            return topRatedViewModel.value.count
        case .upcoming:
            return upcomingViewModel.value.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as! MovieCollectionViewCell
        
        let movieViewModel: MovieViewModel
        switch sections[indexPath.section] {
        case .nowPlaying:
            movieViewModel = nowPlayingViewModel.value[indexPath.row]
        case .popular:
            movieViewModel = popularViewModel.value[indexPath.row]
        case .topRated:
            movieViewModel = topRatedViewModel.value[indexPath.row]
        case .upcoming:
            movieViewModel = upcomingViewModel.value[indexPath.row]
        }
        cell.viewModel.onNext(movieViewModel)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MovieHeaderView.identifier, for: indexPath) as! MovieHeaderView
            headerView.configure(title: sections[indexPath.section].rawValue)
            return headerView
        default:
            return UICollectionReusableView()
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        moveAndResizeImage(for: height)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}
