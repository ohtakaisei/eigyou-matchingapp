//
//  LikeListViewController.swift
//  MatchApp1
//
//  Created by 大田海聖 on 2021/07/12.
//

import UIKit

class LikeListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,GetLikeDataProtocol {
    

    
    
    @IBOutlet weak var tableView: UITableView!
    var userDataModelArray = [UserDataModel]()
    var userData = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LikeProfileCell.nib(), forCellReuseIdentifier: LikeProfileCell.identifier)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        let loadDBModel = LoadDBModel()
        loadDBModel.getLikeDataProtocol = self
        //likeに入っている人たちの情報を取得しセル表示
        loadDBModel.loadLikeList()
        print(loadDBModel.loadLikeList())
        userData = KeyChainConfig.getKeyArrayData(key: "userData")
        tableView.reloadData()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userDataModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: LikeProfileCell.identifier, for: indexPath) as! LikeProfileCell
        
        cell.configure(nameLabelString: userDataModelArray[indexPath.row].name!, ageLabelString: userDataModelArray[indexPath.row].age!, industryLabelString: userDataModelArray[indexPath.row].industry!, priceLabelString: userDataModelArray[indexPath.row].price!, positionLabelString: userDataModelArray[indexPath.row].position!, needLabelString: userDataModelArray[indexPath.row].need!, hobbyLabelString: userDataModelArray[indexPath.row].hobby!, quickWordLabelString: userDataModelArray[indexPath.row].quickWord!, profileImageViewString: userDataModelArray[indexPath.row].profileImageString!, uid: userDataModelArray[indexPath.row].uid!, userData: userData)
        
        print(cell)
        return cell
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
    
    func getLikeDataProtocol(userDataModelArray: [UserDataModel]) {
        self.userDataModelArray = []
        self.userDataModelArray = userDataModelArray
        tableView.reloadData()
    }
    
    
}
