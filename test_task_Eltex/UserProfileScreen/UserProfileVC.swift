//
//  UserProfileVC.swift
//  test_task_Eltex
//
//  Created by Konstantin on 04.10.2022.
//

import UIKit

final class UserProfileVC: UIViewController {
    
    // MARK: - Properties
    private lazy var roleIDLabel: UILabel = {
        let label = UILabel()
        label.text = "roleId: "
        label.textColor = Constants.blueColorForLabels
        label.font = Constants.fontForLabels
        return label
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "username: "
        label.textColor = Constants.blueColorForLabels
        label.font = Constants.fontForLabels
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "email: "
        label.textColor = Constants.blueColorForLabels
        label.font = Constants.fontForLabels
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.backgroundColor = .white
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.sectionHeaderHeight = UITableView.automaticDimension
        table.estimatedSectionHeaderHeight = 40
        return table
    }()
    
    var permissions: [String] = []
    var textFieldsStackView = UIStackView()
    
    private var networkProfileManager: NetworkProfileProtocol
    private var storageManager: StorageManagerProtocol
    
    // MARK: - Initialization
    init(networkProfile: NetworkProfileProtocol, storage: StorageManagerProtocol) {
        self.networkProfileManager = networkProfile
        self.storageManager = storage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func loadView() {
        super.loadView()
        self.getUserInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupViews()
        self.setupNavigationController()
        self.setConstraints()
    }
    
    // MARK: - Methods
    private func getUserInfo() {
        let token = self.storageManager.getTokenFromStorage()
        self.networkProfileManager.getUserProfileInfo(token: token) { [weak self] res in
            switch res {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.configureViews(data: data)
                }
            case .failure(let err):
                DispatchQueue.main.async {
                    self?.showError(message: err.localizedDescription)
                }
            }
        }
    }
    
    private func configureViews(data: UserInfoModel) {
        self.roleIDLabel.text? += data.roleId ?? ""
        self.usernameLabel.text? += data.username ?? ""
        self.emailLabel.text? += data.email ?? "-"
        self.permissions = data.permissions
        self.tableView.reloadData()
    }
    
    private func setupViews() {
        
        self.textFieldsStackView = UIStackView(arrangedSubviews: [roleIDLabel, usernameLabel, emailLabel],
                                               axis: .vertical,
                                               spacing: 10,
                                               distribution: .fillProportionally)
        
        self.view.addSubview(self.textFieldsStackView)
        self.view.addSubview(self.tableView)
    }
    
    private func setupNavigationController() {
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(logOutTapped))
        self.navigationItem.rightBarButtonItem?.tintColor = Constants.redColorForLogOut
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            self.textFieldsStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.textFieldsStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: Constants.topAnchorStackView),
            self.textFieldsStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.lead_trailAnchorStackView),
            self.textFieldsStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Constants.lead_trailAnchorStackView)
        ])
        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.textFieldsStackView.bottomAnchor, constant: Constants.top_botAnchorTableView),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -Constants.top_botAnchorTableView)
        ])
    }
    
    @objc
    private func logOutTapped() {
        self.storageManager.isLoginIn = false
        let vc = Assembly.shared.createAuthorizationVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - TableView Methods
extension UserProfileVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return permissions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.textColor = Constants.blueColorForLabels
        cell.textLabel?.text = permissions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let header = "Permissions"
        return header
    }
    
}
