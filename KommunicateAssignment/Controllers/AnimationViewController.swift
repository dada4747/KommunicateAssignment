//
//  LogoViewController.swift
//  KommunicateAssignment
//
//  Created by admin on 30/05/22.
//

import UIKit

class AnimationViewController: UIViewController {

    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        imageView.image = UIImage.init(named: "logo")
        return imageView
    }()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.addSubview(imageView)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.center = view.center
       animate()
    }
    private func animate(){
        UIView.animate(withDuration: 2) {
            let size = self.view.frame.width * 3
            let diffX  = size - self.view.frame.size.width
            let diffY = self.view.frame.size.height - size
            self.imageView.frame = CGRect(x: -(diffX/2), y: diffY/2, width: size, height: size)
            self.imageView.alpha = 0
        } completion: { isCompleted in
            if isCompleted {
                self.navigationController?.pushViewController(DashboardViewController(), animated: true)
            }
        }

        
    }
}

