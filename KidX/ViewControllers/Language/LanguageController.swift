//
//  LanguageController.swift
//  BaseApp
//
//  Created by Tran Van Quang on 5/3/26.
//

import UIKit

class LanguageController: BaseController, XibLoadable {
    
    @IBOutlet weak var tbvList: UITableView!
    
    private let profileVM: ProfileViewModel
    private var languages: [LanguageModel] = []
    private var setLanguageCompletion: ((String) -> Void)?
    private var selectLanguageCompletion: ((String) -> Void)?

    init(profileVM: ProfileViewModel) {
        self.profileVM = profileVM
        super.init(nibName: Self.xibName, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.languages = profileVM.languages
        setupTableView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupTableView() {
        self.tbvList.registerNib(for: LanguageCell.self)
        self.tbvList.delegate = self
        self.tbvList.dataSource = self
        self.tbvList.showsVerticalScrollIndicator = false
    }
    
    func registerSetLanguageEvent(completion: @escaping (String) -> Void) {
        self.setLanguageCompletion = completion
    }
    
    func registerSelectLanguageEvent(completion: @escaping (String) -> Void) {
        self.selectLanguageCompletion = completion
    }
    
    @IBAction func btnConfirmTapped(_ sender: Any) {
        onDone()
        profileVM.changedLanguageSuccessfully()
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        profileVM.goBack()
    }
    
    private func onDone() {
        guard let language = profileVM.selectedLanguage else { return }
        LocalizeHelper.shared.setLanguage(language)
    }
}

extension LanguageController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LanguageCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configData(languages[indexPath.row], profileVM.selectedLanguage)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LanguageCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let language = languages[indexPath.row]
        profileVM.selectLanguage(language)
        tableView.reloadData()
        selectLanguageCompletion?(language.code)
    }
}

