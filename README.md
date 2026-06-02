# 얼마썼어!? 🎁
> 나의 컬렉션 지출 기록장

![Swift](https://img.shields.io/badge/Swift-5.4-orange?style=flat-square&logo=swift)
![Xcode](https://img.shields.io/badge/Xcode-12.5-blue?style=flat-square&logo=xcode)
![iOS](https://img.shields.io/badge/iOS-14.0+-lightgrey?style=flat-square&logo=apple)
![Architecture](https://img.shields.io/badge/Architecture-MVVM-green?style=flat-square)

<br>

## 📌 프로젝트 소개

최근 20~30대 사이에서 피규어, 레고, 키링 등을 수집하는 **키덜트 문화**가 급부상하고 있습니다.  
하지만 기존 가계부 앱은 일상 지출 중심이라 컬렉터들의 소비 패턴을 반영하기 어렵습니다.

**얼마썼어!?** 는 컬렉터를 위한 특화형 가계부 앱으로,  
지출 관리와 소장품 아카이빙을 하나의 앱에서 해결할 수 있습니다.

<br>

## ✨ 주요 기능

### 🏠 홈 탭
- 총 수집 수 / 총 지출액 대시보드 카드
- 이번 달 소비 현황 요약
- 최근 추가한 아이템 5개 미리보기

### 🎁 컬렉션 탭
- LazyVGrid 기반 그리드 레이아웃
- 카테고리별 필터링 (전체 / 피규어 / 키링 / 포카 / 굿즈 / 레고 / 기타)
- 아이템 추가 / 편집 / 삭제
- 사진 첨부 (UIImagePickerController)
- 아이템 상세 페이지

### 📊 지출 통계 탭
- 총 구매액 / 총 판매액 / 순지출 계산
- 카테고리별 지출 비율 바 차트 (커스텀 구현)
- 월별 지출 추이 바 차트 (최근 6개월)
- 판매 기록 추가 / 삭제

### ⭐ 위시리스트 탭
- 구매 예정 아이템 목록 관리
- 상태 뱃지: 갖고싶다 / 구매완료
- 구매완료 시 컬렉션 탭으로 자동 이동

<br>

## 🛠 기술 스택

| 항목 | 내용 |
|------|------|
| 언어 | Swift 5.4 |
| UI 프레임워크 | SwiftUI |
| 최소 타겟 | iOS 14.0 |
| 아키텍처 | MVVM |
| 데이터 저장 | UserDefaults + Codable |
| 사진 첨부 | UIImagePickerController |
| 차트 | SwiftUI 커스텀 구현 |
| 상태 관리 | ObservableObject + @Published + @StateObject |
| 개발 환경 | macOS Big Sur / Xcode 12.5 |

<br>

## 📁 프로젝트 구조

```
EolmaSseosseo/
├── Models/
│   ├── Category.swift
│   ├── CollectionItem.swift
│   ├── WishlistItem.swift
│   └── SaleRecord.swift
├── ViewModels/
│   ├── CollectionViewModel.swift
│   ├── WishlistViewModel.swift
│   └── StatsViewModel.swift
├── Views/
│   ├── HomeView.swift
│   ├── CollectionView.swift
│   ├── AddItemView.swift
│   ├── ItemDetailView.swift
│   ├── EditItemView.swift
│   ├── StatsView.swift
│   ├── AddSaleView.swift
│   ├── WishlistView.swift
│   └── AddWishlistItemView.swift
├── Utilities/
│   ├── Color+Hex.swift
│   ├── UserDefaultsManager.swift
│   ├── ImagePicker.swift
│   └── Formatters.swift
├── EolmaSseosseoApp.swift
└── ContentView.swift
```

<br>

## 🎨 디자인 콘셉트

컬러풀하고 팝한 느낌의 UI를 목표로 했습니다.

| 역할 | 색상 | 코드 |
|------|------|------|
| Primary | 코랄레드 | `#FF6B6B` |
| Secondary | 민트 | `#4ECDC4` |
| Accent | 옐로우 | `#FFE66D` |
| Background | 라이트그레이 | `#F7F7F7` |

<br>

## 📱 앱 화면

> 시연 영상: [YouTube 링크](#) ← 영상 업로드 후 링크 추가

<br>

## 🚀 실행 방법

1. 이 저장소를 클론해요.
```bash
git clone https://github.com/your-username/EolmaSseosseo.git
```

2. Xcode 12.5 이상으로 `EolmaSseosseo.xcodeproj` 를 열어요.

3. 시뮬레이터 또는 실기기를 선택하고 실행해요. (iOS 14.0 이상)

> 별도의 외부 라이브러리나 CocoaPods 설정 없이 바로 실행 가능합니다.

<br>

## 👨‍💻 개발자

| 이름 | 학번 |
|------|------|
| 김호진 | 2171440 |

<br>

---

> iOS 프로그래밍 미니프로젝트 | 2026# EolmaSseosseo
