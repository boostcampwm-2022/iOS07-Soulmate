//
//  AddPhotoCell.swift
//  Soulmate
//
//  Created by termblur on 2022/11/17.
//

import UIKit
import Vision

import SnapKit

final class AddPhotoCell: UICollectionViewCell {
    weak var viewController: UIViewController?
    
    lazy var addPhotoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 14
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.backgroundGrey?.cgColor
        imageView.backgroundColor = UIColor.backgroundGrey
        self.contentView.addSubview(imageView)
        return imageView
    }()
    
    private lazy var loadingIndicator: LoadingIndicator = {
        let loading = LoadingIndicator()
        addPhotoImageView.addSubview(loading)
        return loading
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        configureView()
    }
    
    func configureView() {
        addPhotoImageView.contentMode = .center
        addPhotoImageView.image = UIImage(named: "plusGrey")
        addPhotoImageView.layer.borderColor = UIColor.backgroundGrey?.cgColor
        loadingIndicator.stopAnimating()
    }
    
    func configureLayout() {
        addPhotoImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func fill(with photoData: Data?) {
        if let data = photoData,
            var originImage = UIImage(data: data) {
            self.loadingIndicator.startAnimating()
            
            let request = VNDetectFaceRectanglesRequest { req, err in
                if let err = err {
                    print("Failed to detect faces: ", err)
                    return
                }
                
                if let faces = req.results as? [VNFaceObservation] {
                    if faces.count >= 1 { // 얼굴 인식 성공 했을 경우
                        // print(faces.count, "Face found!")
                        DispatchQueue.main.async {
                            self.addPhotoImageView.layer.borderColor = UIColor.backgroundGrey?.cgColor
                            self.addPhotoImageView.contentMode = .scaleAspectFill
                            self.addPhotoImageView.image = originImage
                            self.loadingIndicator.stopAnimating()
                        }
                        
                        /*
                        // 이하 테스트코드! 얼굴 인식된 부분 빨간 사각형 그리기
                        print(faces.count, "Face found!")
                        for face in faces {
                            // 원본 이미지 그리기
                            UIGraphicsBeginImageContextWithOptions(originImage.size, false, 1.0)
                            originImage.draw(in: CGRect(x: 0, y: 0, width: originImage.size.width, height: originImage.size.height))
                            
                            // rect 구하기
                            let rect = face.boundingBox
                            let flip = CGAffineTransform.init(scaleX: 1, y: -1).translatedBy(x: 0, y: -originImage.size.height)
                            let scale = CGAffineTransform.identity.scaledBy(x: originImage.size.width, y: originImage.size.height)
                            let convertedFace = rect.applying(scale).applying(flip)
                            
                            // image에 rect 그리기
                            guard let draw = UIGraphicsGetCurrentContext() else { return }
                            draw.setStrokeColor(UIColor.red.cgColor)
                            draw.setLineWidth(0.01 * originImage.size.width)
                            draw.stroke(convertedFace)
                            
                            // 결과값 얻기
                            guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return }
                            UIGraphicsEndImageContext()
                            
                            originImage = result
                            DispatchQueue.main.async {
                                self.addPhotoImageView.layer.borderColor = UIColor.backgroundGrey?.cgColor
                                self.addPhotoImageView.contentMode = .scaleAspectFill
                                self.addPhotoImageView.image = originImage
                                self.loadingIndicator.stopAnimating()
                            }
                        }
                         */
                    } else { // 얼굴 인식 실패했을 경우
                        // print("Face not found!")
                        DispatchQueue.main.async {
                            self.addPhotoImageView.contentMode = .center
                            self.addPhotoImageView.image = UIImage(named: "plusGrey")
                            self.addPhotoImageView.layer.borderColor = UIColor.red.cgColor
                            self.loadingIndicator.stopAnimating()
                        }
                        return
                    }
                }
            }
            request.usesCPUOnly = true
            
            guard let cgImage = originImage.cgImage else { return }
            DispatchQueue.global().async {
                let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                do {
                    try handler.perform([request])
                } catch let reqErr {
                    print("Failed to perform request: ", reqErr)
                }
            }
        }
    }
}
