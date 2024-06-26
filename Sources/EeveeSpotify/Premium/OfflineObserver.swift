import Foundation
import UIKit

class OfflineObserver: NSObject, NSFilePresenter {
    
    var presentedItemURL: URL?
    var presentedItemOperationQueue: OperationQueue

    override init() {
        presentedItemURL = OfflineHelper.offlineBnkPath
        presentedItemOperationQueue = .main
    }
    
    func presentedItemDidChange() {

        let productState = HookedInstances.productState!

        if productState.stringForKey("type") == "premium" {

//            if productState.stringForKey("shuffle") == "0" {
//                return
//            }

            do {
                try OfflineHelper.backupToEeveeBnk()
                NSLog("[EeveeSpotify] Settings has changed, updated eevee.bnk")
            }
            catch {
                NSLog("[EeveeSpotify] Unable to update eevee.bnk: \(error)")
            }

            return
        }

        PopUpHelper.showPopUp(
            message: "Spotify has just reloaded user data, and you've been switched to the Free plan. It's fine; simply restart the app, and the tweak will patch the data again. If this doesn't work, there might be a problem with the cached data. You can reset it and restart the app. Note: after resetting, you need to restart the app twice. You can also manage the Premium patching method in the EeveeSpotify settings.",
            buttonText: "Restart App",
            secondButtonText: "Reset Data and Restart App",
            onPrimaryClick: {
                exitApplication() 
            },
            onSecondaryClick: {
                try! OfflineHelper.resetPersistentCache()
                exitApplication()
            }
        )
    }
}
