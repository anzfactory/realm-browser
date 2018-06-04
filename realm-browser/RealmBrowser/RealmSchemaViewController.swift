//
//  RealmSchemaViewController.swift
//  realm-browser
//
//  Created by shingo asato on 2018/06/04.
//  Copyright © 2018年 anz. All rights reserved.
//

import UIKit

import RealmSwift

class RealmSchemaViewController: UIViewController {
    
    var schema: ObjectSchema?
    
    private let tableView: UITableView = UITableView(frame: .zero, style: .plain)
    
    private var result: Results<DynamicObject>?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = schema?.className
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let schema = self.schema else {
            return
        }
        result = getObjects(schema: schema)
    }

}

// MARK: - UI
extension RealmSchemaViewController {
    private func setupUI() {
        view.backgroundColor = .white
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SubTitleCell.self, forCellReuseIdentifier: "CELL")
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
extension RealmSchemaViewController {
    private func getObjects(schema: ObjectSchema) -> Results<DynamicObject>? {
        var result: Results<DynamicObject>? = nil
        do {
            let realm = try Realm()
            try realm.write {
                result = realm.dynamicObjects(schema.className)
            }
        } catch {
            print(error)
        }
        return result
    }
}

// MARK: - UITableViewDataSource
extension RealmSchemaViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let result = self.result else {
            return 0
        }
        return result.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let property = schema?.primaryKeyProperty else {
            return nil
        }
        if let object = result?[section], let value = object[property.name] {
            return "\(property.name): \(value)"
        } else {
            return "\(property.name): nil"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let schema = self.schema else {
            return 0
        }
        return schema.ex.propertiesWithoutPrimary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)
        let props = schema?.ex.propertiesWithoutPrimary
        if let object = result?[indexPath.section], let property = props?[indexPath.row], let value = object[property.name] {
            cell.textLabel?.text = "\(value)"
        }
        cell.detailTextLabel?.text = props?[indexPath.row].name
        return cell
    }
}

// MARK: - UITableViewDelegate
extension RealmSchemaViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let property = schema?.ex.propertiesWithoutPrimary[indexPath.row] else {
            return
        }
        
        let message: String?
        if let value = result?[indexPath.section][property.name] {
            message = "\(value)"
        } else {
            message = nil
        }
        
        let vc = UIAlertController(title: property.name, message: message, preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    present(vc, animated: true, completion: nil)
    }
}
