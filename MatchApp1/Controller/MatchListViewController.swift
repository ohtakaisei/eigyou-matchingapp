//
//  MatchListViewController.swift
//  MatchApp1
//
//  Created by 大田海聖 on 2021/07/13.
//

import UIKit
import Firebase

class MatchListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,GetWhoisMatchListProtocol {
    
    
    var tableView = UITableView()
    var matchingArray = [UserDataModel]()
    var userData = [String:Any]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.frame = view.bounds
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MatchPersonCell.nib(), forCellReuseIdentifier: MatchPersonCell.identifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //マッチングしている人のデータを取得
        let loadDBModel = LoadDBModel()
        loadDBModel.getWhoisMatchListProtocol = self
        loadDBModel.loadMatchingPersonData()
        userData = KeyChainConfig.getKeyArrayData(key: "userData")
        print(userData)
        print("################################")
        print(Auth.auth().currentUser!.uid)
        print("################################")
       
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return matchingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MatchPersonCell.identifier, for: indexPath) as! MatchPersonCell
        cell.configure(nameLabelString: matchingArray[indexPath.row].name!, ageLabelString: matchingArray[indexPath.row].age!, industryLabelString: matchingArray[indexPath.row].industry!, profileImageViewString: matchingArray[indexPath.row].profileImageString!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let chatVC = self.storyboard?.instantiateViewController(identifier: "chatVC") as! ChatViewController
        chatVC.userDataModel = matchingArray[indexPath.row]
        chatVC.userData = userData
        
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    
    
    func getWhoisMatchListProtocol(userDataModelArray: [UserDataModel]) {
        
        matchingArray = userDataModelArray
        tableView.reloadData()
    }

}
