//
//  MainViewController.swift
//  My news
//
//  Created by Stanislav Slipchenko on 07.10.2020.
//

import UIKit

protocol MainViewProtocol: class {
    func reloadData()
    func show(news: News, images: [String : UIImage?]?)
}

class MainViewController: UIViewController {
    
    @IBOutlet weak var newsTableView: UITableView!
    
    var presenter: MainPresenterProtocol!
    var configurator: MainConfiguratorProtocol = MainConfigurator()
    var news: News? 
    var images: [String : UIImage?]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        presenter.configureView()
        newsTableView.dataSource = self
        newsTableView.delegate = self
    }
    
    @IBAction func infoButtonPressed(_ sender: Any) {
        presenter.infoButtonClicked()
    }
}

extension MainViewController: MainViewProtocol {
    func show(news: News, images: [String : UIImage?]?) {
        self.news = news
        self.images = images
    }
    
    func reloadData() {
        newsTableView.reloadData()
    }
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.isSelected = false
        guard let urlString = news?.articles[indexPath.row].url else {return}
        presenter.goToSite(with: urlString)
    }
}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        news?.totalResults ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "news table cell", for: indexPath) as! MainTableViewCell
        
        var date: String
        
        if let dateNotNill = news?.articles[indexPath.row].publishedAt {
            date = dateNotNill
            date = date.replacingOccurrences(of: "T", with: "  ")
            date = date.replacingOccurrences(of: "Z", with: "")
            cell.dateLabel.text = date
        }
        
        cell.titleLabel.text = news?.articles[indexPath.row].title
        cell.descriptionLabel.text = news?.articles[indexPath.row].articleDescription
        cell.imageOfNews.image = news?.articles[indexPath.row].imageNews ?? UIImage(named: "loading")
        
        return cell
    }
}
