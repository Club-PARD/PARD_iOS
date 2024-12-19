import UIKit
import GoogleSignIn

extension MainLoginViewController {
    @objc func handleGoogleLogin() {
        let clientID = "215579567587-3qckigpku02urbubjtq4qd9oonpltkt3.apps.googleusercontent.com"
        _ = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(
            withPresenting: self,
            hint: nil,
            additionalScopes: []
        ) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Google Sign In Error: \(error.localizedDescription)")
                return
            }
            
            guard let result = result else {
                print("No result found")
                return
            }
            
            // user는 이미 옵셔널이 아닌 값이므로 옵셔널 바인딩 제거
            let user = result.user
            guard let profile = user.profile else {
                print("No profile found")
                return
            }
            
            // 사용자 정보 가져오기
            let emailAddress = profile.email
            print("email Address = \(emailAddress)")
            let fullName = profile.name
            print("fullName = \(fullName)")
            let givenName = profile.givenName
            print("givenName = \(givenName ?? "")")
            let familyName = profile.familyName
            print("familyName = \(familyName ?? "")")
            let profilePicUrl = profile.imageURL(withDimension: 320)
            print("profilePicUrl = \(String(describing: profilePicUrl))")
            
            // UserDefaults에 이메일 저장
            UserDefaults.standard.set(emailAddress, forKey: "userEmail")
            
            // 로그인 처리
            self.postLogin(with: emailAddress)
            
            // 화면 이동
            let userInfoViewController = UserInfoPolicyViewController()
            self.navigationController?.pushViewController(userInfoViewController, animated: true)
        }
    }
    
    private func postLogin(with email: String) {
        // 로그인 관련 API 호출 등 처리
    }
}
