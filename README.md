# 데일리샷 클론

## 프로젝트 정보

## 프로젝트 설명
<details>
  <summary>프로젝트 구조</summary>
  
  ```bash 
  .
  ├── Config.xcconfig
  ├── DailyshotClone
  │   ├── GoogleService-Info.plist
  │   ├── Services
  │   │   ├── CartManager.swift
  │   │   ├── Extensions.swift
  │   │   ├── ImageCacheManager.swift
  │   │   ├── UserManager.swift
  │   │   ├── WebService.swift
  │   │   └── WishListManager.swift
  │   ├── Models
  │   │   ├── Cart.swift
  │   │   ├── DetailDataSource.swift
  │   │   ├── HomeDataSource.swift
  │   │   ├── Item.swift
  │   │   ├── Store.swift
  │   │   └── User.swift
  │   ├── ViewModels
  │   │   ├── CartViewModel.swift
  │   │   ├── CategoryItemListViewModel.swift
  │   │   ├── CategoryViewModel.swift
  │   │   ├── FilterListViewModel.swift
  │   │   ├── HomeViewModel.swift
  │   │   ├── ItemDetailViewModel.swift
  │   │   ├── ItemListViewModel.swift
  │   │   ├── SelectStoreViewModel.swift
  │   │   ├── SignInViewModel.swift
  │   │   ├── SignUpViewModel.swift
  │   │   └── WishListViewModel.swift
  │   ├── ViewControllers
  │   │   ├── CartViewController.swift
  │   │   ├── CategoryItemListViewController.swift
  │   │   ├── CategoryViewController.swift
  │   │   ├── HomeViewController.swift
  │   │   ├── ItemDetailViewController.swift
  │   │   ├── ItemListViewController.swift
  │   │   ├── MainTabBarViewController.swift
  │   │   ├── MyPageViewController.swift
  │   │   ├── SelectStoreViewcontroller.swift
  │   │   ├── SignUpViewController.swift
  │   │   ├── SingInViewController.swift
  │   │   └── WishListViewController.swift
  │   ├── Views
  │   │   ├── CustomStepper.swift
  │   │   ├── Cart
  │   │   │   ├── CartCell.swift
  │   │   │   ├── CartFooterView.swift
  │   │   │   └── CartHeaderView.swift
  │   │   ├── Category
  │   │   │   ├── CategoryCell.swift
  │   │   │   ├── FilterListCell.swift
  │   │   │   ├── FilterListHeaderCell.swift
  │   │   │   ├── FilterView.swift
  │   │   │   └── SectionBackgroundView.swift
  │   │   ├── Detail
  │   │   │   ├── ItemDetailDescriptionCell.swift
  │   │   │   ├── ItemDetailInformationCell.swift
  │   │   │   ├── ItemDetailMainCell.swift
  │   │   │   ├── ItemDetailReviewCell.swift
  │   │   │   ├── ItemDetailStoreCell.swift
  │   │   │   └── ItemDetailTastingNotesCell.swift
  │   │   ├── Home+List
  │   │   │   ├── BannerCell.swift
  │   │   │   ├── BannerImageCell.swift
  │   │   │   ├── HomeCellType.swift
  │   │   │   ├── HomeItemHeaderCell.swift
  │   │   │   ├── ItemListHeaderCell.swift
  │   │   │   ├── LargeItemCell.swift
  │   │   │   ├── MediumItemCell.swift
  │   │   │   ├── MenuButtonCell.swift
  │   │   │   ├── MenuCell.swift
  │   │   │   ├── SmallItemCell.swift
  │   │   │   └── SmallItemImageCell.swift
  │   │   └── WishList
  │   │       └── WishListCell.swift
  │   ├── Predifined
  │   │   ├── AppDelegate.swift
  │   │   ├── Assets.xcassets
  │   │   ├── Base.lproj
  │   │   ├── Info.plist
  │   │   └── SceneDelegate.swift
  │   ├── Resource
  │   │   └── productData.json
  ├── Podfile
  ├── Podfile.lock
  └── Pods
  ```

</details>

## 주요 기능

## 화면 구성

### 홈 화면

<p align="center"> 
  <img src="https://github.com/user-attachments/assets/fc3b80ce-59e7-4c03-8195-1362f6679b75" width="24%" alt="홈 화면">
  <img src="https://github.com/user-attachments/assets/b7d95160-f7df-4a88-9c5f-09971a7df0e1" width="24%" alt="small"> 
  <img src="https://github.com/user-attachments/assets/3554f131-c879-4a0b-934f-1c2d81743b8b" width="24%" alt="medium"> 
  <img src="https://github.com/user-attachments/assets/d76b7521-1093-422c-82c0-03ca526b0c1a" width="24%" alt="large"> 
</p>
