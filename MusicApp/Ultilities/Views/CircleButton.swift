//
//  SecondCircleButton.swift
//  MusicApp
//
//  Created by HungDo on 10/13/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

enum CircleButtonType: String {
    case border
    case inner
}

class CircleButton: UIView {
    
    // MARK: Properties

    var type: CircleButtonType = .border
    
    var image: UIImage? = nil {
        didSet {
            self.imageView.image = image
            update()
        }
    }
    
    var borderWidth: CGFloat = 1 { didSet { update() } }
    var circleColor: UIColor = UIColor.white { didSet { update() } }
    var innerColor: UIColor? = UIColor.black.withAlphaComponent(0.7) { didSet { update() } }
    
    // MARK: Subviews
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate lazy var innerView: UIView = {
        let innerView = UIView(frame: self.frame)
        innerView.translatesAutoresizingMaskIntoConstraints = false
        return innerView
    }()
    
    // MARK: State
    
    fileprivate var state: UIControlState = .normal
    
    // MARK: Touch Events
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if type == .border {
            update(forState: .selected)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if type == .border {
            update(forState: .selected)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if type == .border {
            update(forState: .normal)
        }
        sendTouchUpInsideEvent()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if type == .border {
            update(forState: .normal)
        }
        sendTouchUpInsideEvent()
    }
    
    // MARK: Target - Actions
    
    private var targets: [NSObjectProtocol?] = []
    private var actions: [Selector] = []
    private var events: [UIControlEvents] = []
    
    func addTarget(_ target: NSObjectProtocol?, action: Selector, forEvent event: UIControlEvents) {
        if let index = events.index(of: event) {
            targets[index] = target
            actions[index] = action
        } else {
            targets.append(target)
            actions.append(action)
            events.append(event)
        }
    }
    
    private func sendTouchUpInsideEvent() {
        if let index = events.index(of: .touchUpInside) {
            let target = targets[index]
            let action = actions[index]
            let _ = target?.perform(action, with: self)
        }
    }
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        let size = min(frame.size.width, frame.size.height)
        let center = CGPoint(
            x: frame.origin.x + frame.size.width / 2,
            y: frame.origin.y + frame.size.height / 2
        )
        super.init(frame: CGRect(x: center.x - size / 2, y: center.y - size / 2, width: size, height: size))
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        setup()
        update()
    }
    
    func setup() {
        
    }
    
    // MARK: Update UI
    
    private func update() {
        if !imageViewConstraints.isEmpty {
            self.removeConstraints(imageViewConstraints)
        }
        
        if innerView.superview === self {
            innerView.removeFromSuperview()
        }
        
        if (!innerViewConstraints.isEmpty) {
            self.removeConstraints(innerViewConstraints)
        }
        
        imageViewConstraints = [
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7),
            imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7)
        ]
        self.addConstraints(imageViewConstraints)
        
        switch type {
        case .border: updateForBorderButton()
        case .inner:  updateForInnerButton()
        }
        
        self.layoutIfNeeded()
    }
    
    private func update(forState state: UIControlState) {
        if self.state == state { return }
        self.state = state
        
        if type == .border {
            updateBorderButton(forState: state)
        }
    }
    
    // MARK: Constraints
    
    fileprivate var imageViewConstraints: [NSLayoutConstraint] = []
    fileprivate var innerViewConstraints: [NSLayoutConstraint] = []

}

// MARK: Border Circle Button

extension CircleButton {
    
    fileprivate func updateForBorderButton() {
        self.layer.borderWidth = self.borderWidth
        self.layer.borderColor = self.circleColor.cgColor
        self.layer.cornerRadius = min(frame.size.width, frame.size.height) / 2
    }
    
    fileprivate func updateBorderButton(forState state: UIControlState) {
        if state.rawValue == UIControlState.normal.rawValue {
            updateNormalStateForBorderButton()
        } else if state.rawValue == UIControlState.selected.rawValue {
            updateSelectedStateForBorderButton()
        }
    }
    
    private func updateSelectedStateForBorderButton() {
        print(#function)
    }
    
    private func updateNormalStateForBorderButton() {
        print(#function)
    }
    
}

// MARK: Inner Circle Button

extension CircleButton {
    
    fileprivate func updateForInnerButton() {
        self.updateForBorderButton()
        
        if innerView.superview === self { return }
        
        innerView.backgroundColor = innerColor
        self.addSubview(innerView)
        self.sendSubview(toBack: innerView)
        
        let scaleOffset: CGFloat = 0.8
        let size = min(self.bounds.size.width, self.bounds.size.height) / 2
        innerView.layer.cornerRadius = size * scaleOffset
        
        innerViewConstraints = [
            innerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            innerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            innerView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: scaleOffset),
            innerView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: scaleOffset)
        ]
        self.addConstraints(innerViewConstraints)
    }
    
}
