//
//  SavedCollectionController.swift
//  KidX
//
//  Created by mt on 30/6/26.
//

import UIKit

final class SavedCollectionController: BaseController, XibLoadable {
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var selectButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // Bottom delete bar outlets/views
    @IBOutlet private weak var deleteBarView: UIView!
    @IBOutlet private weak var deleteButton: UIButton!
    @IBOutlet private weak var deleteBarBottomConstraint: NSLayoutConstraint!
    
    private let viewModel: SavedCollectionViewModel
    
    // Edit mode state
    private var isEditingMode = false {
        didSet {
            updateEditingState()
        }
    }
    
    private var selectedIndexes = Set<Int>() {
        didSet {
            updateDeleteButtonTitle()
        }
    }
    
    init(viewModel: SavedCollectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: Self.xibName, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        super.setupUI()
        setupLabels()
        setupCollectionView()
        setupDeleteBar()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadData()
    }
    
    private func setupLabels() {
        titleLabel.text = viewModel.titleText
        titleLabel.textColor = AppColor.text.color
        
        subtitleLabel.text = viewModel.subtitleText
        subtitleLabel.textColor = AppColor.grey.color
        
        backButton.setImage(UIImage(resource: .icFlcBack), for: .normal)
        backButton.tintColor = AppColor.text.color
        
        selectButton.setTitle("Edit".localize(), for: .normal)
        selectButton.setTitleColor(AppColor.primary.color, for: .normal)
        selectButton.titleLabel?.font = UIFont.custom(16, .semiBold)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(for: SavedObjectCollectionViewCell.self)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        
        // Dynamic grid layout padding
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 16
            layout.minimumInteritemSpacing = 12
        }
    }
    
    private func setupDeleteBar() {
        deleteBarView.backgroundColor = .white
        deleteBarView.layer.shadowColor = UIColor.black.cgColor
        deleteBarView.layer.shadowOffset = CGSize(width: 0, height: -4)
        deleteBarView.layer.shadowOpacity = 0.08
        deleteBarView.layer.shadowRadius = 12
        deleteBarView.layer.cornerRadius = 24
        deleteBarView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        deleteButton.backgroundColor = .systemRed
        deleteButton.tintColor = .white
        deleteButton.titleLabel?.font = UIFont.custom(16, .semiBold)
        deleteButton.layer.cornerRadius = 18
        deleteButton.clipsToBounds = true
        
        // Hide delete bar initially by positioning it offscreen
        deleteBarBottomConstraint.constant = -120
        deleteBarView.isHidden = true
        updateDeleteButtonTitle()
    }
    
    private func bindViewModel() {
        viewModel.onDataChanged = { [weak self] in
            guard let self = self else { return }
            // Verify if selected indexes are still valid (e.g. index < count)
            let maxCount = self.viewModel.items.count
            self.selectedIndexes = Set(self.selectedIndexes.filter { $0 < maxCount })
            self.collectionView.reloadData()
            self.selectButton.isHidden = maxCount == 0
            if maxCount == 0 && self.isEditingMode {
                self.isEditingMode = false
            }
        }
    }
    
    private func updateEditingState() {
        selectButton.setTitle(isEditingMode ? "Cancel".localize() : "Edit".localize(), for: .normal)
        selectButton.setTitleColor(isEditingMode ? AppColor.grey.color : AppColor.primary.color, for: .normal)
        
        if !isEditingMode {
            selectedIndexes.removeAll()
        }
        
        // Animate the bottom delete bar visibility
        deleteBarView.isHidden = false
        deleteBarBottomConstraint.constant = isEditingMode ? 0 : -120
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: { finished in
            if !self.isEditingMode {
                self.deleteBarView.isHidden = true
            }
        })
        
        collectionView.reloadData()
    }
    
    private func updateDeleteButtonTitle() {
        if selectedIndexes.isEmpty {
            deleteButton.setTitle("Delete".localize(), for: .normal)
            deleteButton.backgroundColor = UIColor(hex: 0xE5E5EA)
            deleteButton.setTitleColor(UIColor(hex: 0x8E8E93), for: .normal)
            deleteButton.isEnabled = false
        } else {
            deleteButton.setTitle("\("Delete".localize()) (\(selectedIndexes.count))", for: .normal)
            deleteButton.backgroundColor = UIColor(hex: 0xFF3B30)
            deleteButton.setTitleColor(.white, for: .normal)
            deleteButton.isEnabled = true
        }
    }
    
    // MARK: - Actions
    @IBAction private func handleBack(_ sender: UIButton) {
        viewModel.navigateBack()
    }
    
    @IBAction private func handleSelectTapped(_ sender: UIButton) {
        isEditingMode.toggle()
    }
    
    @IBAction private func handleDeleteSelectedTapped(_ sender: UIButton) {
        let alert = UIAlertController(
            title: "Confirm".localize(),
            message: "Are you sure you want to delete these objects?".localize(),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel".localize(), style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete".localize(), style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            let indexes = Array(self.selectedIndexes)
            self.viewModel.deleteObjects(at: indexes)
            self.isEditingMode = false
        }))
        present(alert, animated: true)
    }
    
    private func promptSingleDelete(at index: Int) {
        let alert = UIAlertController(
            title: "Confirm".localize(),
            message: "Are you sure you want to delete this object?".localize(),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel".localize(), style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete".localize(), style: .destructive, handler: { [weak self] _ in
            self?.viewModel.deleteObject(at: index)
        }))
        present(alert, animated: true)
    }
}

// MARK: - CollectionView DataSource & Delegate
extension SavedCollectionController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: SavedObjectCollectionViewCell.self)
        let item = viewModel.items[indexPath.item]
        
        let isSelected = selectedIndexes.contains(indexPath.item)
        cell.configure(
            image: item.image,
            name: item.name,
            dateText: item.dateText,
            showActions: true,
            isSelectable: isEditingMode,
            isItemSelected: isSelected
        )
        
        cell.onDeleteTapped = { [weak self] in
            self?.promptSingleDelete(at: indexPath.item)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isEditingMode {
            if selectedIndexes.contains(indexPath.item) {
                selectedIndexes.remove(indexPath.item)
            } else {
                selectedIndexes.insert(indexPath.item)
            }
            collectionView.reloadItems(at: [indexPath])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalPadding: CGFloat = 40
        let spacing: CGFloat = 12
        let availableWidth = collectionView.bounds.width - horizontalPadding - spacing
        let width = availableWidth / 2
        return CGSize(width: width, height: width * 1.2)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 20, bottom: isEditingMode ? 140 : 110, right: 20)
    }
}
