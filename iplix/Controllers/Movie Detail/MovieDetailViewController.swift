//
//  MovieDetailViewController.swift
//  iplix
//
//  Created by TEMP on 4/7/20.
//  Copyright © 2020 aldovernando. All rights reserved.
//

import UIKit
import SDWebImage
import RealmSwift

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var foregroundPoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieReleasedDate: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var releasedDate: UILabel!
    @IBOutlet weak var rating: UILabel!
    
    @IBOutlet weak var aboutBarBtn: UIBarButtonItem!
    @IBOutlet weak var infoBarBtn: UIBarButtonItem!
    @IBOutlet weak var reviewBarBtn: UIBarButtonItem!
    @IBOutlet weak var favBtn: UIBarButtonItem!
    
    let network = ViewController.network
    var movie: Movie?
    let realm = RealmManager()
    var isFavorite = false
    var tempFav: FavoriteMovie?
    var parentView: FavoriteViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
    }
    
    
    @IBAction func backBtn(_ sender: UIBarButtonItem) {
        
        if let parent = parentView {
            parent.getFavorite()
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func favBtn(_ sender: UIBarButtonItem) {
        
        changeFav()
        
    }
    

    @IBAction func aboutBarBtn(_ sender: UIBarButtonItem) {
        
        changeColor(sender: sender)
        let vc = showViewController(controller: "MovieAboutViewController") as! MovieAboutViewController
        vc.movie = movie
        changeContentView(view: vc.view)
        
    }
    
    
    @IBAction func infoBarBtn(_ sender: UIBarButtonItem) {
        
        changeColor(sender: sender)
        let vc = showViewController(controller: "MovieInformationViewController") as! MovieInformationViewController
        
        if let mov = movie {
            network.getMovieDetail(movieId: String(mov.id!)) { response in
                vc.movieDetail = response
                DispatchQueue.main.async {
                    self.changeContentView(view: vc.view)
                }
            }
        }
        
    }
    
    
    @IBAction func reviewBarBtn(_ sender: UIBarButtonItem) {
        
        changeColor(sender: sender)
        let vc = showViewController(controller: "MovieReviewViewController") as! MovieReviewViewController
        
        if let mov = movie {
            vc.movie = mov
            network.getMovieReview(movieId: String(mov.id!)) { response in
                vc.reviews = response
                DispatchQueue.main.async {
                    self.addChild(vc)
                    self.changeContentView(view: vc.view)
                }
            }
        }
        
    }
    
}


// MARK: Functions
extension MovieDetailViewController {
    
    
    // set up view controller
    func setUp() {
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        checkFavorite()
        poster.addBlurEffect()
        foregroundPoster.addBorderWhiteLine()
        foregroundPoster.setCornerRadius(radius: 10)
        
        if let mov = movie {
            if let backdrop = mov.backdrop_path {
                poster.sd_setImage(with: URL(string: network.posterURL + backdrop))
            }
            if let poster = mov.poster_path {
                foregroundPoster.sd_setImage(with: URL(string: network.posterURL + poster))
            }
            movieTitle.text = mov.title
            releasedDate.text = mov.release_date
            rating.text = String(mov.vote_average!)
        }
        
        aboutBarBtn(aboutBarBtn)
    }
    
    
    // change selected bar color
    func changeColor(sender: UIBarButtonItem) {
        
        aboutBarBtn.tintColor = #colorLiteral(red: 0.2093600929, green: 0.3236650825, blue: 0.4488521814, alpha: 1)
        infoBarBtn.tintColor = #colorLiteral(red: 0.2093600929, green: 0.3236650825, blue: 0.4488521814, alpha: 1)
        reviewBarBtn.tintColor = #colorLiteral(red: 0.2093600929, green: 0.3236650825, blue: 0.4488521814, alpha: 1)
        sender.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    
    // show selected view controller
    func showViewController(controller: String) -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: controller)
        
        return viewController
    }
    
    
    // change favorite icon
    func changeFav() {
        var image = "bookmark"
        
        if UserDefaults.standard.string(forKey: "userId") == nil {
            showAlert(message: "You must login to add movie to favorite")
        }
        else {
            // add to fav
            if isFavorite == false {
                image = "bookmark.fill"
                
                if let mov = movie {
                    
                    let favMovie = FavoriteMovie()
                    favMovie.id = mov.id!
                    favMovie.title = mov.title!
                    favMovie.poster_path = mov.poster_path!
                    
                    if let genreId = mov.genre_ids?.first {
                        let genre = network.genres.filter({ $0.id == genreId })
                        favMovie.genre = genre[0].name
                    } else {
                        favMovie.genre = " "
                    }
                    
                    realm.saveFavMovie(fav: favMovie)
                }
                
            }
            // remove from fav
            else {
                if let data = tempFav {
                    realm.deleteFavMovie(fav: data)
                }
            }
            
            favBtn.image = UIImage(systemName: image)
            
            isFavorite = !isFavorite
        }
    }
    
    
    // check Favorite
    func checkFavorite() {
        let favs = realm.realmInit.objects(FavoriteMovie.self)
        
        if favs.count > 0 {
            if let mov = movie {
                
                for fav in favs {
                    if fav.id == mov.id {
                        isFavorite = true
                        tempFav = fav
                    }
                }
            }
        }
        
        if isFavorite {
            favBtn.image = UIImage(systemName: "bookmark.fill")
        }
        
    }
    
    
    // change content view
    func changeContentView(view: UIView) {
        
        UIView.transition(with: self.view, duration: 0.25, options: .transitionCrossDissolve,
        animations: {
            self.contentView.addSubview(view)
        }, completion: nil)
    }
    
    
    // show alert
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Information", message:
            message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

        self.present(alertController, animated: true, completion: nil)
    }
    
}
