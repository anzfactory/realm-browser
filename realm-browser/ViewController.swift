//
//  ViewController.swift
//  realm-browser
//
//  Created by shingo asato on 2018/06/04.
//  Copyright © 2018年 anz. All rights reserved.
//

import UIKit

import RealmSwift

class ViewController: UIViewController {
    
    private let button: UIButton = UIButton(type: .system)
    private let dataButton: UIButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - UI
extension ViewController {
    private func setupUI() {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Open", for: .normal)
        button.addTarget(self, action: #selector(type(of: self).tapOpen(sender:)), for: .touchUpInside)
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        dataButton.translatesAutoresizingMaskIntoConstraints = false
        dataButton.setTitle("Create data", for: .normal)
        dataButton.addTarget(self, action: #selector(type(of: self).tapData(sender:)), for: .touchUpInside)
        view.addSubview(dataButton)
        NSLayoutConstraint.activate([
            dataButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dataButton.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 16.0)
        ])
    }
}

// MARK: - Events
extension ViewController {
    @objc private func tapOpen(sender: UIButton) {
        let vc = RealmSchemaListViewController()
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    @objc private func tapData(sender: UIButton) {
        createData()
    }
}

// MARK: - Realm
extension ViewController {
    /*
     dynamic var id: Int = 0
     dynamic var name: String = ""
     dynamic var level: Int = 0
     dynamic var createdAt: Date = Date()
     dynamic var updatedAt: Date = Date()
     */
    private func createData() {
        let weaponData: [(Int, String, Int, Int, Date, Date)] = [
            (1, "ひのきのぼう", 2, 1, Date(), Date()),
            (2, "こんぼう", 5, 10, Date(), Date()),
            (3, "どうのつるぎ", 10, 50, Date(), Date())
        ]
        let monsterData: [(Int, String, Int, Date, Date)] = [
            (1, "すらいむ", 1, Date(), Date()),
            (2, "どらきー", 3, Date(), Date()),
            (3, "ぶらうにー", 4, Date(), Date())
        ]
        
        do {
            let realm = try Realm()
            try realm.write {
                for data in weaponData {
                    let weapon = Weapon()
                    weapon.id = data.0
                    weapon.name = data.1
                    weapon.atk = data.2
                    weapon.price = data.3
                    weapon.createdAt = data.4
                    weapon.updatedAt = data.5
                    realm.add(weapon, update: true)
                }
                for data in monsterData {
                    let monster = Monster()
                    monster.id = data.0
                    monster.name = data.1
                    monster.level = data.2
                    monster.createdAt = data.3
                    monster.updatedAt = data.4
                    realm.add(monster, update: true)
                }
            }
        } catch {
            print(error)
        }
    }
}
