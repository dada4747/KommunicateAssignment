//
//  File2.swift
//  KommunicateAssignment
//
//  Created by admin on 02/06/22.
//

import UIKit
class AvatarImageView: UIImageView {
    let cache = NetworkManager.shared.cache
    let placeholderImage = UIImage(named: "avatar-placeholder")!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        confuger()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - confugure avatar image
    private func confuger() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius  = 10
        clipsToBounds = true
        image = placeholderImage
    }
}
