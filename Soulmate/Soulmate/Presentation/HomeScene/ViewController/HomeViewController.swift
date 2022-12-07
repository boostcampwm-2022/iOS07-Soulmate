//
//  HomeViewController.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/08.
//

import UIKit
import SnapKit
import Combine
import CoreLocation

final class HomeViewController: UIViewController {
    
    var bag = Set<AnyCancellable>()
    
    var locationManager: CLLocationManager?

    private var viewModel: HomeViewModel?
    let refreshControl = UIRefreshControl()
    var data = [UserPreview]()
    
    // MARK: - UI
    private lazy var logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.frame = CGRect(x: 0, y: 0, width: 140, height: 18)
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        return imageView
    }()
    
    private lazy var heart: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "heart")
        imageView.frame = CGRect(x: 0, y: 0, width: 17.07, height: 14.06)
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        return imageView
    }()

    
    private lazy var numOfHeartLabel: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
        label.textColor = UIColor.labelDarkGrey
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        self.view.addSubview(label)
        return label
    }()
    
    // MARK: - 컬렉션뷰
    private lazy var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(PartnerCell.self, forCellWithReuseIdentifier: "PartnerCell")
        cv.register(RecommendView.self, forCellWithReuseIdentifier: "RecommendView")
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cv.showsVerticalScrollIndicator = false
        cv.bounces = true
        cv.isPagingEnabled = false
        cv.backgroundColor = .clear
        
        self.view.addSubview(cv)
        return cv
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(viewModel: HomeViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    // MARK: - 초기화
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureLayout()
        
        bind()
        
        configureLocationService()
    }
    
    func configureLocationService() {
        locationManager = CLLocationManager()
        
        locationManager?.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager?.distanceFilter = 2000
        locationManager?.allowsBackgroundLocationUpdates = true
                
        locationManager?.delegate = self
        
        locationManager?.startUpdatingLocation()
        locationManager?.startMonitoringSignificantLocationChanges()
    }
}

// MARK: - View Generators

private extension HomeViewController {
    func bind() {
        guard let viewModel = viewModel else { return }
        let output = viewModel.transform(input: HomeViewModel.Input())

        output.didRefreshedPreviewList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                print("refreshed?")
                self?.collectionView.reloadData()
            }
            .store(in: &bag)
    }
    
    func configureView() {
        view.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        refreshControl.tintColor = .mainPurple
        refreshControl.addTarget(self, action: #selector(self.refreshFunc), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    func configureLayout() {
        logo.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(view.snp.top).offset(64)
            $0.width.equalTo(140)
            $0.height.equalTo(18)
        }
        
        heart.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-45.46)
            $0.top.equalTo(view.snp.top).offset(65.97)
            $0.width.equalTo(17.07)
            $0.height.equalTo(14.06)
        }
        
        numOfHeartLabel.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalTo(view.snp.top).offset(64)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(logo.snp.bottom).offset(20)
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(20)
        }
    }
    
    @objc func refreshFunc() {
        collectionView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func setAuthAlertAction() {
         let authAlertController = UIAlertController(
            title: "위치 사용 권한이 필요합니다.",
            message: "위치 권한을 허용해야만 앱을 사용하실 수 있습니다.", preferredStyle: .alert
         )
         
         let getAuthAction = UIAlertAction(title: "설정", style: .default, handler: { (UIAlertAction) in
             if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                 UIApplication.shared.open(appSettings,options: [:],completionHandler: nil)
             }
         })
         authAlertController.addAction(getAuthAction)
         self.present(authAlertController, animated: true, completion: nil)
     }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        switch section {
        case 0:
            if data.isEmpty, viewModel.recommendedMatePreviewList.count <= 2 {
                data = viewModel.recommendedMatePreviewList
            } else if data.isEmpty, viewModel.recommendedMatePreviewList.count > 2 {
                (0..<2).forEach {
                    data.append(viewModel.recommendedMatePreviewList[$0])
                }
            }
            return data.count
            
        case 1:
            return 1
            
        default:
            fatalError("indexPath.section")
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PartnerCell", for: indexPath) as? PartnerCell,
            let viewModel = viewModel else {
                return UICollectionViewCell()
            }
            
            Task {
                guard let imageKey = viewModel.recommendedMatePreviewList[indexPath.row].imageKey,
                      let imageData = try await viewModel.fetchImage(key: imageKey),
                      let uiImage = UIImage(data: imageData) else { return }
                cell.fill(userPreview: viewModel.recommendedMatePreviewList[indexPath.row])
                await MainActor.run { cell.fill(userImage: uiImage) }
            }
            return cell
            
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendView", for: indexPath) as? RecommendView else {
                return UICollectionViewCell()
            }
            return cell
        default:
            fatalError("indexPath.section")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: view.frame.size.width - 40, height: view.frame.size.width - 40)
            
        case 1:
            return CGSize(width: view.frame.size.width - 40, height: 54)
            
        default:
            fatalError("indexPath.section")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        switch indexPath.section {
        case 0:
            viewModel.mateSelected(index: indexPath.row)
            
        case 1:
            let numberOfItem = self.collectionView.numberOfItems(inSection: 0)
            if viewModel.recommendedMatePreviewList.count - numberOfItem >= 1 {
                print("1명 더 추천 완료! 하트 -10개!")
                data.insert(viewModel.recommendedMatePreviewList[numberOfItem], at: numberOfItem)
                collectionView.insertItems(at: [IndexPath(item: numberOfItem, section: 0)])
                collectionView.reloadData()
            } else {
                let alert = UIAlertController(title: "😭", message: "가까운 거리에 더 이상 추천 상대가 없어요!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(okAction)
                present(alert, animated: true)
            }
            
            
        default:
            fatalError("indexPath.section")
        }
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Task {
            guard let location = locations.last else { return }
            var locationInstance = Location(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
            viewModel?.updateLocation(location: locationInstance)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .notDetermined:
            manager.requestAlwaysAuthorization()
        case .restricted, .notDetermined, .denied:
            manager.requestAlwaysAuthorization()
        }
    }
}
