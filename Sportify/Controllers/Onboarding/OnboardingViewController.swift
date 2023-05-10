import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var onboardingCollectionView: UICollectionView!
    @IBOutlet weak var onboardingPageControl: UIPageControl!
    @IBOutlet weak var onboardingButton: UIButton!
    
    private(set) var slides: [OnboardingSlide] = [
        OnboardingSlide(title: "Football", description: "Experience the passion and excitement of the beautiful game.", image: UIImage(named: "onboarding_football")!),
        OnboardingSlide(title: "Tennis", description: "Experience the thrill of victory with every swing.", image: UIImage(named: "onboarding_tennis")!),
        OnboardingSlide(title: "Cricket", description: "Experience the excitement of cricket with our app.", image: UIImage(named: "onboarding_cricket")!),
        OnboardingSlide(title: "Basketball", description: "Experience the energy and intensity of the game.", image: UIImage(named: "onboarding_basketball")!)
    ]
    
    var currentPage = 0 {
        didSet {
            onboardingPageControl.currentPage = currentPage
            onboardingButton.setTitle(currentPage == slides.count - 1 ? "Get Started" : "Next", for: .normal)
        }
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        if currentPage == slides.count - 1 {
            performSegue(withIdentifier: "TabBarController", sender: nil)
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            onboardingCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TabBarController" {
            (segue.destination as! UITabBarController).modalPresentationStyle = .fullScreen
        }
    }
    
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
        cell.setUp(slides[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
    
}
