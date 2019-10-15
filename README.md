# ShareTogether

一款與好友出遊時便利的線上分帳 App，並提供記事本、留言、推播通知等便利功能

[<img src="https://github.com/nick1ee/Shalk/raw/master/screenshot/DownloadAppStoreBadge.png" width="160">](https://apps.apple.com/tw/app/sharetogether/id1481312982)

### Features
* 群組管理
    - 新增群組
    - 新增 / 移除成員
* 消費資訊
    - 瀏覽詳細內容
    - 地圖瀏覽
    - 關鍵字搜尋
* 新增消費
    - 提供消費類型、金額、說明
    - 支援均分、比例、金額等分帳方式
    - 消費地點
* 活動紀錄
    - 群組邀請
    - 新增消費通知 

### Key Rewards
* 減輕 ViewController 中 TableView 各 Section 使用不同 cell

建立 `AddExpenseItem` protocol，並其 conform `UITableViewDelegate` `UITableViewDataSource`
```
protocol AddExpenseItem: UITableViewDelegate, UITableViewDataSource {}
```

主要的 `AddExpenseViewController` 中建立四個子 controller，並分別注入 TableView，分別負責該 Section 內容。並建立一個 `items` 陣列將四個 controller 放在其中 
```
class AddExpenseViewController: UIViewController {
        ⋮
    var tableView: UITableView
        
    var amountTypeController = AmountTypeController(tableView: tableView)
    
    var expenseController = ExpenseController(tableView: tableView)
    
    var payerController = PayerController(tableView: tableView)
    
    var splitController = SplitController(tableView: tableView)
    
    var payDateController = PayDateController(tableView: tableView)
    
    var items: [AddExpenseItem] = [amountTypeController,
                                   expenseController,
                                   payerController,
                                   splitController,
                                   payDateController]
        ⋮
}
```

由 conform `AddExpenseItem` 的 controller 負責實作 `numberOfRowsInSection`
```
class AmountTypeController: AddExpenseItem {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectionTableViewCell.identifier, for: indexPath)
      
        return selectionCell
    }
}
```

最後 `AddExpenseViewController` 在實作 TableView 的 cell 的時候即可達到簡化 ViewController 的效果
```
extension AddExpenseViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items[section].tableView(tableView, numberOfRowsInSection: section)
    }
}
```

### Libraries
* SwiftLint
* SwiftIconFont
* IQKeyboardManagerSwift
* Firebase/Auth
* Firebase/Storage
* Firebase/Firestore
* Firebase/Messaging
* FBSDKLoginKit
* GoogleSignIn
* CodableFirebase
* Kingfisher
* JGProgressHUD
* Fabric
* Crashlytics

### Requirements
* iOS 13
* Xcode 11

### Contact
Pony
litlema0404@gmail.com