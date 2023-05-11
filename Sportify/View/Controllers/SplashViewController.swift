import UIKit
import Lottie

class SplashViewController: UIViewController {

    @IBOutlet weak var splashView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animationView = LottieAnimationView(name: "splash")
        
        // Add the animation view as a subview of the splashView
        splashView.addSubview(animationView)
        
        // Constrain the animationView to every edge of the splashView
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.leadingAnchor.constraint(equalTo: splashView.leadingAnchor).isActive = true
        animationView.trailingAnchor.constraint(equalTo: splashView.trailingAnchor).isActive = true
        animationView.topAnchor.constraint(equalTo: splashView.topAnchor).isActive = true
        animationView.bottomAnchor.constraint(equalTo: splashView.bottomAnchor).isActive = true
        
        // Set the content mode to fit the animation inside the view
        animationView.contentMode = .scaleAspectFit
        
        // Set the loop mode
        animationView.loopMode = .loop
        
        // Play the animation
        animationView.play()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.performSegue(withIdentifier: "onboarding", sender: nil)
        }
    }

}
