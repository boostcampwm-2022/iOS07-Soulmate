//
//  DetailViewController.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/08.
//

import UIKit

import SnapKit

final class DetailViewController: UIViewController {
    let images = [
        UIImage(named: "emoji"),
        UIImage(named: "heart"),
        UIImage(named: "nav3On"),
        UIImage(named: "Phone"),
        UIImage(named: "friendAccept")
    ]

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceVertical = false
        scrollView.bounces = true
        scrollView.backgroundColor = .systemPink
        
        self.view.addSubview(scrollView)
        return scrollView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()

        scrollView.addSubview(pageControl)
        return pageControl
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(ProfileCell.self, forCellReuseIdentifier: "ProfileCell")
        tableView.register(GreetingCell.self, forCellReuseIdentifier: "GreetingCell")
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        return tableView
    }()
    

    
    
    
    
    
    
    
    
    private lazy var applyButton: GradientButton = {
        let button = GradientButton(title: "대화친구 신청하기")
        self.view.addSubview(button)
        return button
    }()
    
    // MARK: - 초기화
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureLayout()
        
        bind()
    }
    
    
}

// MARK: - configure
private extension DetailViewController {
    private func bind() {

    }
    
    private func configureView() {
        self.view.backgroundColor = .gray
        
        setPageControl()
        addContentScrollView()
    }
    
    private func configureLayout() {
        scrollView.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(self.view.snp.width)
        }
        
        pageControl.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(12)
            $0.centerX.equalTo(self.view.snp.centerX)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.bottom)
            $0.bottom.equalTo(applyButton.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
        
        applyButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            $0.bottom.equalTo(self.view.snp.bottom).inset(46)
            $0.height.equalTo(54)
        }
    }
}

// MARK: - 스크롤뷰 및 페이지컨트롤
extension DetailViewController: UIScrollViewDelegate {
    private func addContentScrollView() {
        for i in 0..<images.count {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            let xPos = scrollView.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPos, y: 0,
                                     width: scrollView.bounds.width,
                                     height: scrollView.bounds.height)
            imageView.image = images[i]
            scrollView.addSubview(imageView)
            scrollView.contentSize.width = imageView.frame.width * CGFloat(i + 1)
        }
    }
    
    private func setPageControl() {
        pageControl.numberOfPages = images.count
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .white
    }
    
    private func setPageControlSelectedPage(currentPage: Int) {
        pageControl.currentPage = currentPage
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = scrollView.contentOffset.x / scrollView.frame.size.width
        setPageControlSelectedPage(currentPage: Int(round(value)))
    }
}

// MARK: - 테이블 뷰
extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as? ProfileCell else { fatalError() }
            cell.partnerName.text =
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GreetingCell", for: indexPath) as? GreetingCell else { fatalError() }
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BasicInfoCell", for: indexPath) as? BasicInfoCell else { fatalError() }
            return cell
        default:
            fatalError()
        }
    }
    

    
    
}

// MARK: - 프로필 셀
final class ProfileCell: UITableViewCell {
    private lazy var partnerSubView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        contentView.addSubview(view)
        return view
    }()

    private lazy var partnerName: UILabel = {
        let label = UILabel()
        label.text = "초록잎"
        label.frame = CGRect(x: 0, y: 0, width: 58, height: 26)
        label.textColor = UIColor.darkText
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 22)
        partnerSubView.addSubview(label)
        return label
    }()
    
    private lazy var partnerAge: UILabel = {
        let label = UILabel()
        label.text = "25"
        label.frame = CGRect(x: 0, y: 0, width: 23, height: 26)
        label.textColor = UIColor.darkText
        label.font = UIFont(name: "AppleSDGothicNeo-Light", size: 22)
        partnerSubView.addSubview(label)
        return label
    }()
    
    private lazy var partnerMapImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mapColor")
        imageView.frame = CGRect(x: 0, y: 0, width: 13.04, height: 18)
        imageView.contentMode = .scaleAspectFit
        partnerSubView.addSubview(imageView)
        return imageView
    }()
    
    private lazy var partnerDistance: UILabel = {
        let label = UILabel()
        label.text = "3 km"
        label.frame = CGRect(x: 0, y: 0, width: 32, height: 20)
        label.textColor = UIColor.lightText
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
        partnerSubView.addSubview(label)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(
    
    
    func configureView() {
        self.backgroundColor = .white
    }
    
    func configureLayout() {
        
        partnerName.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.left.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(50)
        }
        
        partnerAge.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.left.equalToSuperview().inset(84)
            $0.bottom.equalToSuperview().inset(50)
        }
        
        partnerMapImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(57)
            $0.left.equalToSuperview().inset(22.48)
            $0.bottom.equalToSuperview().inset(25)
        }
        
        partnerDistance.snp.makeConstraints {
            $0.top.equalToSuperview().inset(56)
            $0.left.equalToSuperview().inset(44)
            $0.bottom.equalToSuperview().inset(24)
        }
        
        partnerSubView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        var separator = UIView(frame: .zero)
        separator.backgroundColor = .labelGrey
        self.contentView.addSubview(separator)
        separator.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
}

// MARK: - 인사말 셀
final class GreetingCell: UITableViewCell {
    private lazy var title: UILabel = {
        let label = UILabel()
        label.text = "인사말"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        label.textColor = UIColor.darkText
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.text = "솔직한 사람이 좋아요😋"
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        textView.textColor = UIColor.lightText
        contentView.addSubview(textView)
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        self.backgroundColor = .white
    }
    
    func configureLayout() {
        title.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo(42)
            $0.height.equalTo(22)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(title).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        var separator = UIView(frame: .zero)
        separator.backgroundColor = .labelGrey
        self.contentView.addSubview(separator)
        separator.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
}

// MARK: - 기본정보 셀
final class BasicInfoCell: UITableViewCell {
    private lazy var heightLabel: UILabel = {
        let label = UILabel()
        label.text = "키"
        label.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 14)
        label.textColor = UIColor.lightText
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var mbtiLabel: UILabel = {
        let label = UILabel()
        label.text = "MBTI"
        label.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 14)
        label.textColor = UIColor.lightText
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var drinkLabel: UILabel = {
        let label = UILabel()
        label.text = "음주"
        label.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 14)
        label.textColor = UIColor.lightText
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var smokeLabel: UILabel = {
        let label = UILabel()
        label.text = "흡연"
        label.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 14)
        label.textColor = UIColor.lightText
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var heightInput: UILabel = {
        let label = UILabel()
        label.text = "161cm"
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
        label.textColor = UIColor.darkText
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var mbtiInput: UILabel = {
        let label = UILabel()
        label.text = "ISFP"
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
        label.textColor = UIColor.darkText
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var drinkInput: UILabel = {
        let label = UILabel()
        label.text = "가끔 마심"
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
        label.textColor = UIColor.darkText
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var smokeInput: UILabel = {
        let label = UILabel()
        label.text = "비흡연"
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
        label.textColor = UIColor.darkText
        contentView.addSubview(label)
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        self.backgroundColor = .white
    }
    
    func configureLayout() {
        heightLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(33)
        }
        
        mbtiLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(heightLabel.snp.bottom).offset(22)
        }
        
        drinkLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(mbtiLabel.snp.bottom).offset(22)
        }
        
        smokeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(drinkLabel.snp.bottom).offset(22)
        }
        
        heightInput.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(118)
            $0.top.equalToSuperview().offset(32)
        }
        
        mbtiInput.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(118)
            $0.top.equalTo(heightInput.snp.bottom).offset(20)
        }
        
        drinkInput.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(118)
            $0.top.equalTo(mbtiInput.snp.bottom).offset(20)
        }
        
        smokeInput.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(118)
            $0.top.equalTo(drinkInput.snp.bottom).offset(20)
        }
    }
}


// MARK: - 미리보기
#if DEBUG
import SwiftUI
struct DetailViewControllerRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // leave this empty
    }
    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> some UIViewController {
        DetailViewController()
    }
    @available(iOS 13.0, *)
    struct SnapKitVCRepresentable_PreviewProvider: PreviewProvider {
        static var previews: some View {
            Group {
                DetailViewControllerRepresentable()
                    .ignoresSafeArea()
                    .previewDisplayName("Preview")
                    .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            }
        }
    }
} #endif
