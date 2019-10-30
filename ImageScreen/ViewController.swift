//
//  ViewController.swift
//  ImageDownloader
//
//  Created by Вика on 29/10/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var size : CGSize {
        return self.view.bounds.size
    }
    
    lazy var showButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.backgroundColor = UIColor.white
        button.setTitle("Show", for: .normal)
//        button.setTitleColor(UIColor.black, for: .normal)
        button.frame.size = CGSize(width: 100, height: 50)
        button.center = CGPoint(x: size.width / 2, y: size.height * 3 / 4)
        
        button.addTarget(self, action:  #selector(didTapShowButton), for:.touchDown)
        
        return button
    }()
    
    lazy var downloadButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.backgroundColor = UIColor.white
        button.setTitle("Download", for: .normal)
//        button.setTitleColor(UIColor.black, for: .normal)
        button.frame.size = CGSize(width: 100, height: 50)
        button.center = CGPoint(x: size.width / 2, y: size.height * 3 / 4 + 50)
        
        button.addTarget(self, action:  #selector(didTapDownloadButton), for:.touchDown)
        
        return button
    }()
    
    lazy var clearCacheButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.backgroundColor = UIColor.white
        button.setTitle("Clear cash", for: .normal)
//        button.setTitleColor(UIColor.black, for: .normal)
        button.frame.size = CGSize(width: 100, height: 50)
        button.center = CGPoint(x: size.width / 2, y: size.height * 3 / 4 + 100)
        
        button.addTarget(self, action:  #selector(didTapClearCacheButton), for:.touchDown)
        
        return button
    }()
    
    lazy var imageView : UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        imageView.center = CGPoint(x: size.width / 2, y: size.height / 2)
        
        return imageView
    }()
    
//    var alertController: UIAlertController = {
//        let alert = UIAlertController(title: "Error", message: "", preferredStyle: UIAlertController.Style.alert)
//        let defaultAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action) in
//        }
//        alert.addAction(defaultAction)
//
//        return alert
//    }()
    
    let presenter: PresenterInput
    
    init(presenter: PresenterInput) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createUI()
        presenter.viewDidLoad()
    }
    
    func createUI() {
        view.backgroundColor = .white
        
        view.addSubview(downloadButton)
        view.addSubview(showButton)
        view.addSubview(clearCacheButton)
        view.addSubview(imageView)
    }
    
    @objc func didTapDownloadButton(button: UIButton) {
        presenter.didTapDownloadButton()
    }
    
    @objc func didTapShowButton(button: UIButton) {
        presenter.didTapShowButton()
    }
    
    @objc func didTapClearCacheButton(button: UIButton) {
        presenter.didTapClearCacheButton()
    }
}

extension ViewController: PresenterOutput {
    
    func showImage(image: UIImage) {
        imageView.image = image
    }
    
    func hideImage() {
        imageView.image = nil
    }
}

