//
//  RealmSchemaListViewController.swift
//  realm-browser
//
//  Created by shingo asato on 2018/06/04.
//  Copyright © 2018年 anz. All rights reserved.
//

import UIKit

import RealmSwift

class RealmSchemaListViewController: UIViewController {
    
    private let tableView: UITableView = UITableView(frame: .zero, style: .plain)
    
    private var schemaList: [ObjectSchema]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Schamaリスト"
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        schemaList = getAllSchema()
    }
}

// MARK: - UI
extension RealmSchemaListViewController {
    private func setupUI() {
        view.backgroundColor = .white
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CELL")
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - Realm
extension RealmSchemaListViewController {
    private func getAllSchema() -> [ObjectSchema]? {
        do {
            let realm = try Realm()
            return realm.schema.objectSchema.filter({ (objectSchema) -> Bool in
                return !objectSchema.className.hasPrefix("RLM") && !objectSchema.className.hasPrefix("RealmSwift")
            })
        } catch {
            print(error)
            return nil
        }
    }
}

// MARK: - UITableViewDataSource
extension RealmSchemaListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let schemaList = schemaList else {
            return 0
        }
        return schemaList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)
        cell.textLabel?.text = schemaList?[indexPath.row].className
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

// MARK: - UITableViewDelegate
extension RealmSchemaListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = RealmSchemaViewController()
        vc.schema = schemaList?[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
