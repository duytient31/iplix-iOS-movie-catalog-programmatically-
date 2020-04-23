//
//  PersonDetailViewController.swift
//  iplix
//
//  Created by TEMP on 4/10/20.
//  Copyright © 2020 aldovernando. All rights reserved.
//

import UIKit

class PersonDetailViewController: UIViewController {

    var backBtn: UIBarButtonItem!
    
    private let scroller: UIScrollView = {
           let scroll = UIScrollView()
           scroll.translatesAutoresizingMaskIntoConstraints = false
           
           return scroll
    }()
    
    private let content: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let name: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let birthdayLabel: UILabel = {
        let label = UILabel()
        label.text = "Birthday"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let birthday: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let placebirthLabel: UILabel = {
        let label = UILabel()
        label.text = "Place of Birth"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let placebirth: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let biographyLabel: UILabel = {
        let label = UILabel()
        label.text = "Biography"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let biography: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var network = ViewController.network
    var personId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backBtn = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backBtn(_:)) )
        navigationItem.leftBarButtonItem = backBtn
        
        content.addSubview(name)
        content.addSubview(birthdayLabel)
        content.addSubview(birthday)
        content.addSubview(placebirthLabel)
        content.addSubview(placebirth)
        content.addSubview(biographyLabel)
        content.addSubview(biography)
        
        scroller.addSubview(content)
        
        view.backgroundColor = .white
        view.addSubview(scroller)
        
        NSLayoutConstraint.activate([

            // scroll view constraints
            scroller.topAnchor.constraint(equalTo: view.topAnchor),
            scroller.leftAnchor.constraint(equalTo: view.leftAnchor),
            scroller.rightAnchor.constraint(equalTo: view.rightAnchor),
            scroller.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // content view constraints
            content.topAnchor.constraint(equalTo: scroller.topAnchor),
            content.leftAnchor.constraint(equalTo: scroller.leftAnchor),
            content.rightAnchor.constraint(equalTo: scroller.rightAnchor),
            content.bottomAnchor.constraint(equalTo: scroller.bottomAnchor),
            content.widthAnchor.constraint(equalToConstant: view.frame.width),
            
            // name constraints
            name.topAnchor.constraint(equalTo: content.topAnchor, constant: 20),
            name.leftAnchor.constraint(equalTo: content.leftAnchor, constant: 16),
            name.rightAnchor.constraint(equalTo: content.rightAnchor, constant: -16),
            
            // birthday label constraints
            birthdayLabel.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 20),
            birthdayLabel.leftAnchor.constraint(equalTo: content.leftAnchor,constant: 16),
            birthdayLabel.rightAnchor.constraint(equalTo: content.rightAnchor, constant: -16),
                
            // birthday constraints
            birthday.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor, constant: 10),
            birthday.leftAnchor.constraint(equalTo: content.leftAnchor,constant: 16),
            birthday.rightAnchor.constraint(equalTo: content.rightAnchor, constant: -16),
                    
            // placebirth label constraints
            placebirthLabel.topAnchor.constraint(equalTo: birthday.bottomAnchor, constant: 20),
            placebirthLabel.leftAnchor.constraint(equalTo: content.leftAnchor,constant: 16),
            placebirthLabel.rightAnchor.constraint(equalTo: content.rightAnchor, constant: -16),
                
            // placebirth constraints
            placebirth.topAnchor.constraint(equalTo: placebirthLabel.bottomAnchor, constant: 10),
            placebirth.leftAnchor.constraint(equalTo: content.leftAnchor,constant: 16),
            placebirth.rightAnchor.constraint(equalTo: content.rightAnchor, constant: -16),
            
            // biography label constraints
            biographyLabel.topAnchor.constraint(equalTo: placebirth.bottomAnchor, constant: 20),
            biographyLabel.leftAnchor.constraint(equalTo: content.leftAnchor,constant: 16),
            biographyLabel.rightAnchor.constraint(equalTo: content.rightAnchor, constant: -16),
                
            // biography constraints
            biography.topAnchor.constraint(equalTo: biographyLabel.bottomAnchor, constant: 10),
            biography.leftAnchor.constraint(equalTo: content.leftAnchor,constant: 16),
            biography.rightAnchor.constraint(equalTo: content.rightAnchor, constant: -16),
            biography.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: 20)
            
        ])
        
        loadData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        scroller.contentSize = CGSize(width: UIScreen.main.bounds.width, height: content.frame.height + 50)
    }
    
    @objc func backBtn(_ sender: UIBarButtonItem) {
        
        navigationController?.popViewController(animated: true)
    }

}


// MARK: Functions
extension PersonDetailViewController {
    
    
    // load person detail
    func loadData() {
        if let id = personId {
            network.getPersonDetail(id: id) { response in
                self.name.text = response.name
                self.birthday.text = response.birthday
                self.placebirth.text = response.place_of_birth
                self.biography.text = response.biography
            }
        }
    }
}
