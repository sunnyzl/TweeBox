//
//  ImageContainerViewController.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/21.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher


class ImageContainerViewController: UIViewController {

    public var tweet: Tweet? {
        didSet {
            print(">>> container tweet >> \(tweet)")
            setLayout()
        }
    }
    
    private var media: [TweetMedia]? {
        return tweet?.entities?.realMedia
    }
    
    private var clickedIndex = 0
    private var images = [UIImage]()
    private var imageViews = [UIImageView]()
    
    private let placeholder = UIImage(named: "picPlaceholder")!
    private let cutPoint = CGPoint(x: 0.5, y: 0.5)
    
    private func setLayout() {
        
        view.isUserInteractionEnabled = true
        
        if let media = media {
            switch media.count {
            case 1:
                let firstImageView = addImageView(at: 0)

                firstImageView.snp.makeConstraints({ (make) in
                    make.size.equalTo(view)
                    make.center.equalTo(view)
                })
                
            case 2:
                let firstImageView = addImageView(at: 0)
                firstImageView.snp.makeConstraints({ (make) in
                    make.width.equalTo(view).multipliedBy(0.5)
                    make.height.equalTo(view)
                    make.top.equalTo(view)
                    make.leading.equalTo(view)
                })
                
                let secondImageView = addImageView(at: 1)
                secondImageView.snp.makeConstraints({ (make) in
                    make.size.equalTo(firstImageView)
                    make.top.equalTo(firstImageView)
                    make.trailing.equalTo(view)
                })

            case 3:
                let firstImageView = addImageView(at: 0)
                firstImageView.snp.makeConstraints({ (make) in
                    make.width.equalTo(view).multipliedBy(0.5)
                    make.height.equalTo(view)
                    make.top.equalTo(view)
                    make.leading.equalTo(view)
                })
                
                let secondImageView = addImageView(at: 1)
                secondImageView.snp.makeConstraints({ (make) in
                    make.width.equalTo(firstImageView)
                    make.height.equalTo(firstImageView).multipliedBy(0.5)
                    make.top.equalTo(firstImageView)
                    make.trailing.equalTo(view)
                })
                
                let thirdImageView = addImageView(at: 2)
                thirdImageView.snp.makeConstraints({ (make) in
                    make.size.equalTo(secondImageView)
                    make.bottom.equalTo(firstImageView)
                    make.trailing.equalTo(view)
                })
                
            case 4:
                let firstImageView = addImageView(at: 0)
                firstImageView.snp.makeConstraints({ (make) in
                    make.width.equalTo(view).multipliedBy(0.5)
                    make.height.equalTo(view).multipliedBy(0.5)
                    make.top.equalTo(view)
                    make.leading.equalTo(view)
                })
                
                let secondImageView = addImageView(at: 1)
                secondImageView.snp.makeConstraints({ (make) in
                    make.size.equalTo(firstImageView)
                    make.top.equalTo(firstImageView)
                    make.trailing.equalTo(view)
                })
                
                let thirdImageView = addImageView(at: 2)
                thirdImageView.snp.makeConstraints({ (make) in
                    make.size.equalTo(firstImageView)
                    make.bottom.equalTo(view)
                    make.leading.equalTo(view)
                })
                
                let fourthImageView = addImageView(at: 3)
                fourthImageView.snp.makeConstraints({ (make) in
                    make.size.equalTo(firstImageView)
                    make.bottom.equalTo(view)
                    make.trailing.equalTo(view)
                })
                
            default:
                break
            }
        }
    }
    
    
    private func addImageView(at index: Int) -> UIImageView {
        
        let imageView = UIImageView()
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        
        var ratio: CGFloat {
            let total = media!.count
            if (total == 2) || (total == 3 && index == 0) {
                return Constants.thinAspectRatio
            } else {
                return Constants.normalAspectRatio
            }
        }

        
        let cutSize = media![index].getCutSize(with: ratio, at: Constants.picQuality)
        let processor = CroppingImageProcessor(size: cutSize, anchor: cutPoint)
        
        imageView.kf.setImage(
            with: media![index].mediaURL,
            placeholder: placeholder,
            options: [
                .transition(.fade(Constants.picFadeInDuration)),
                .processor(processor)
            ]
        )
        { [weak self] (image, error, cacheType, url) in
            if let image = image {
                self?.images.append(image)
            }
        }
        imageViews.append(imageView)
        
        // add tap gesture
        let gestures = [#selector(tapOnFirstImage(_:)), #selector(tapOnSecondImage(_:)), #selector(tapOnThirdImage(_:)), #selector(tapOnFourthImage(_:))]
        
        let tapGesture = UITapGestureRecognizer(target: self, action: gestures[index])
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        imageView.addGestureRecognizer(tapGesture)
        
        return imageView
    }
    
    @IBAction func tapOnFirstImage(_ sender: UIGestureRecognizer) {
        clickedIndex = 0
        performSegue(withIdentifier: "Image Tapped", sender: imageViews[0])
    }
    @IBAction func tapOnSecondImage(_ sender: UIGestureRecognizer) {
        clickedIndex = 1
        performSegue(withIdentifier: "Image Tapped", sender: imageViews[1])
    }
    @IBAction func tapOnThirdImage(_ sender: UIGestureRecognizer) {
        clickedIndex = 2
        performSegue(withIdentifier: "Image Tapped", sender: imageViews[2])
    }
    @IBAction func tapOnFourthImage(_ sender: UIGestureRecognizer) {
        clickedIndex = 3
        performSegue(withIdentifier: "Image Tapped", sender: imageViews[3])
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Image Tapped" {
            if let imageViewer = segue.destination as? ImageViewerViewController {
                imageViewer.image = images[clickedIndex]
                imageViewer.imageURL = tweet?.entities?.mediaToShare?[clickedIndex].mediaURL
            }
        }
    }
}













