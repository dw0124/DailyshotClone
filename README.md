# 데일리샷 클론

## 프로젝트 정보

**해당 프로젝트는 데일리샷의 클론 프로젝트입니다.**

기술 스택: iOS, Swift, RxSwift, MVVM, SnapKit, Firebase, Naver Maps

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

## 화면 구성 및 기능

### 홈 화면

배너 이미지가 무한히 순환되도록 캐러셀(Carousel) 스타일로 구현하였습니다.

TableViewController의 섹션에 CollectionViewController를 삽입하여 상품을 small, medium, large 세가지 스타일로 표시했습니다.

<p align="left"> 
  <img src="https://github.com/user-attachments/assets/fc3b80ce-59e7-4c03-8195-1362f6679b75" width="24%" alt="홈 화면">
  <img src="https://github.com/user-attachments/assets/b7d95160-f7df-4a88-9c5f-09971a7df0e1" width="24%" alt="small"> 
  <img src="https://github.com/user-attachments/assets/3554f131-c879-4a0b-934f-1c2d81743b8b" width="24%" alt="medium"> 
  <img src="https://github.com/user-attachments/assets/d76b7521-1093-422c-82c0-03ca526b0c1a" width="24%" alt="large"> 
</p>

##

### 상세 화면

TableViewController를 사용해 상품, 판매처, 테이스팅 노트, 상세 정보, 설명 등의 정보를 제공합니다.

화면 하단의 버튼을 통해 위시리스트에 추가 또는 삭제, 판매처를 선택하는 화면을 보여줍니다.

<p align="left"> 
  <img src="https://github.com/user-attachments/assets/32026d51-1047-4317-bb79-41e0bbbc6bf5" width="24%" alt="상세 화면">
  <img src="https://github.com/user-attachments/assets/1d1d0711-b43c-46af-bc32-6425c0ab225f" width="24%" alt="상세 화면">
  <img src="https://github.com/user-attachments/assets/69435ab7-3010-45b8-8676-a860183457cb" width="24%" alt="상세 화면">
</p>

##

### 판매처 선택 화면

사용자는 판매처, 상품, 상품개수를 장바구니에 추가할 수 있습니다.

<p align="left"> 
  <img src="https://github.com/user-attachments/assets/9c7ad213-a153-42dd-901d-c131c9727831" width="24%" alt="판매처 선택 화면">
</p>

##

### 위시리스트 화면

사용자의 위시리스트에 저장되어 있는 상품ID를 통해 위시리스트를 불러옵니다.

<p align="left"> 
  <img src="https://github.com/user-attachments/assets/c05b3c4b-0457-4c49-9846-972402126b26" width="24%" alt="위시리스트">
</p>

##

### 장바구니 화면

사용자는 원하는 상품을 장바구니에서 삭제할 수 있습니다.

각 상품의 수량을 조절할 수 있습니다. 수량 조절 버튼을 통해 수량을 변경하면 해당 상품의 가격이 자동으로 업데이트됩니다.

사용자가 장바구니에서 선택한 상품들의 가격을 합산하여 총 가격을 계산하고 화면에 표시합니다.

<p align="left"> 
  <img src="https://github.com/user-attachments/assets/20b7d4b5-ce47-4013-bd94-be12eac3f8b6" width="24%" alt="상세 화면">
</p>
