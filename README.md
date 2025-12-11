# TalknLike 📌
게시글을 올리고 댓글을 통해 서로 소통할 수 있는 앱입니다.
팔로우/팔로잉, 게시글 좋아요/댓글 기능과 알림, 프로필 설정 등의 기능을 지원합니다.

## 스킬

- UIKit
- MVC Pattern
- Combine
- Firebase (Authentication, Database) / Supabase(프로필 이미지 저장용)

### 참고 사항
+) '이메일 인증 메일 보내기', '비밀번호 재설정 메일 보내기' 는 이미 제공되어있는 Firebase의 메서드를 사용하였습니다.
+) 테스트 계정: asd@naver.com / tkdtn5584@

## 특징

### 로그인
- 아이디와 비밀번호를 입력하여 로그인합니다.

#### 회원가입
- 이메일 입력을 완료하면, 일정 시간 후에 해당 이메일의 유효성을 평가합니다. (중복 여부, 형식 등)

![Simulator Screen Recording - iPhone 17 Pro - 2025-12-10 at 22 06 54](https://github.com/user-attachments/assets/25972ad1-1ca3-410b-ad4a-64e122783a7b)

- 이메일이 유효하다면, '확인'버튼을 눌러 이메일을 확정합니다.
- 이메일이 확정되면 비밀번호 필드가 활성화됩니다.
- 마찬가지로, 비밀번호가 유효하다면 '가입' 버튼이 활성화됩니다.
- '가입' 버튼을 누르면, 이메일 인증 메시지가 전송됩니다. 확인 버튼을 눌러 메인 화면으로 이동할 수 있으며, 해당 이메일에서 인증하면 로그인이 가능합니다.

![Simulator Screen Recording - iPhone 17 Pro - 2025-12-10 at 22 09 38](https://github.com/user-attachments/assets/f4ce636a-46ab-4b8d-a08e-9410bd747959)

- 이메일 인증을 하지 않은 채로 로그인하면, 다음과 같은 메시지가 출력됩니다.
- 편의를 위해, 이메일을 인증하지 않아도 로그인할 수 있도록 해당 기능을 주석처리한 상태입니다.

<img width="220" height="400" alt="스크린샷 2025-12-10 오후 10 22 41" src="https://github.com/user-attachments/assets/108323c6-6a15-4510-9e6f-8879c9c2bd89" />

```swift
// 해당 부분은 주석 처리된 상태입니다.
if !result.user.isEmailVerified {
  try Auth.auth().signOut()
  showEmailVerificationRequiredAlert()
  return
}
```

#### 비밀번호 찾기
- 이메일을 입력하여 비밀번호 재설정 메일을 보냅니다.
- 
![Simulator Screen Recording - iPhone 17 Pro - 2025-12-10 at 22 24 13](https://github.com/user-attachments/assets/1fd5f587-c5ca-4b07-9cb7-0f9799179813)

## 메인 화면

### 홈
- 자신이 '팔로잉'하는 유저의 게시글들을 시간 순으로 보여줍니다.
- 프로필 사진, 닉네임, 게시 날짜와 게시 내용이 포함됩니다.
- 해당 게시글에 좋아요를 누르고, 댓글을 달 수 있습니다.
<img width="200" height="400" alt="IMG_6568" src="https://github.com/user-attachments/assets/a9a554ca-2435-4648-b290-65a3493e7a1e" />

#### 댓글
- Comment 버튼을 누르면, 댓글 시트가 열립니다.
- 댓글에 답글을 달 수 있고, 누구에게 답글을 다는지 표시됩니다.
- 하단의 텍스트 필드를 통해 댓글/답글을 달 수 있습니다.
- 답글을 달 때는 플레이스홀더가 '@(닉네임) 님에게 회신' 같은 형식으로 바뀝니다.
- 자신이 단 댓글/답글이라면, 삭제와 수정이 가능합니다.
- 최상위 댓글을 삭제하면, 연결된 답글까지 모두 삭제됩니다.

https://github.com/user-attachments/assets/1c97530b-978e-410e-a565-dba706ed8428

## 친구

### 팔로워
- 나를 팔로우하는 사람들을 보여줍니다. 닉네임과 자기 소개, 프로필 사진이 표시됩니다.
- 셀을 클릭하면, 그 유저가 작성한 글들을 보여줍니다.

https://github.com/user-attachments/assets/5743ed0d-7739-4286-bccd-de7d8ff18225


### 팔로잉
- 내가 팔로우하는 사람들을 보여줍니다.
- 셀을 클릭하면, 그 유저가 작성한 글들을 보여줍니다.
- '해제'버튼을 눌러 팔로잉을 해제할 수 있습니다.
- 해당 유저의 글이 홈 화면에서 더 이상 보이지 않습니다.


https://github.com/user-attachments/assets/93f5bfac-9473-4673-83d6-32909814e392

  
### 유저 찾기
- 돋보기 버튼을 눌러 검색 모드로 진입합니다.
- 검색어를 포함하는 닉네임을 가진 유저들을 보여줍니다.
- 셀을 클릭하면, 그 유저가 작성한 글들을 보여줍니다.
- '추가' 버튼을 클릭하여 해당 유저에게 팔로우를 요청합니다.



- 나, 이미 팔로잉하는 친구에게는 버튼이 보이지 않습니다.
- 이미 팔로우 요청을 보낸 유저에게 다시 팔로우 요청을 보내면, 토스트 메시지가 표시됩니다.
<img width="200" height="400" alt="IMG_6548" src="https://github.com/user-attachments/assets/12d98884-28e4-432f-9d37-d467b479bf77" />


## 게시
- 게시 탭을 누르면, 게시 시트가 활성화됩니다.
- 제목과 내용을 작성하고 '게시'버튼을 눌러 게시합니다.
- 제목과 내용이 모두 있어야 글을 게시할 수 있습니다.

![Simulator Screen Recording - iPhone 17 Pro - 2025-12-10 at 22 50 47](https://github.com/user-attachments/assets/568316c0-ef86-430e-a1b0-6b2053a090ed)


## 알림


### 새 팔로우 요청
- 자신에게 팔로우를 요청한 유저들의 목록을 가져옵니다.
- '수락'버튼을 눌러 수락합니다.
<img width="200" height="400" alt="IMG_6566" src="https://github.com/user-attachments/assets/54248a34-4193-4400-8d35-e02ab9fc40e9" />

### 활동
- 자신의 게시글에 좋아요/ 댓글이 추가될 때마다 알림이 추가됩니다.
- 해당 알림 셀을 누르면, 그 게시글로 이동합니다.


https://github.com/user-attachments/assets/0cd600f8-8186-47d6-a3a7-40bd8fb38d6d


- 이미 삭제된 게시글로는 이동할 수 없습니다.


https://github.com/user-attachments/assets/ccfea0c9-18c4-4c52-8ea2-f5f307f311e7


- 왼쪽으로 드래그하여 해당 셀을 제거합니다.


https://github.com/user-attachments/assets/9b6acf9a-a553-40af-9ea6-e99e28f15732


## 프로필
<img width="200" height="400" alt="IMG_6562" src="https://github.com/user-attachments/assets/e5c63e2c-3266-41f6-9cae-21e9741260fc" />

### 내가 쓴 글
- 내 게시글을 볼 수 있습니다.
- 셀을 꾹 누르면, 게시글을 수정하거나 삭제할 수 있습니다.

https://github.com/user-attachments/assets/ddbbc8f9-b482-4a97-9a32-1fe047daadc6

### 편집
- 자신의 프로필 사진과 닉네임, 자기소개를 수정할 수 있습니다.
- 카메라 버튼을 눌러 사진을 가져옵니다.

https://github.com/user-attachments/assets/eac3601a-2300-496d-b9a7-4c618959d05f



- 닉네임 수정시, 현재 필드에 입력한 글자 수가 표시됩니다.
- 최대 글자수를 넘어가면, 숫자 라벨이 빨간 색으로 변하며 닉네임을 저장할 수 없습니다.
<img width="200" height="400" alt="IMG_6559" src="https://github.com/user-attachments/assets/07073d10-446e-4a51-a8ed-2d2e39a2cfd2" />
<img width="200" height="400" alt="IMG_6558" src="https://github.com/user-attachments/assets/8e32831f-73f8-4723-aee0-1edf77a6e2ec" />

- 자기소개 수정시, 현재 필드에 입력한 글자 수가 표시됩니다.
- 2줄 이내로 작성할 수 있습니다.
<img width="200" height="400" alt="IMG_6561" src="https://github.com/user-attachments/assets/f3339463-3356-4ad0-b9b2-81bf2140c46a" />


### 로그아웃
- 로그아웃 버튼을 눌러 로그아웃합니다.

https://github.com/user-attachments/assets/4796a491-202d-45a3-82ab-36a08aedde86


---

## 해결한 문제 / 핵심 기능

### 회원 가입 시 불필요한 API 요청 절감 / UX 개선
```swift
private func observeEmailField() {
  let publisher = NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: signUpView.emailField)
            
  publisher
    .compactMap { ($0.object as? UITextField)?.text }
    .debounce(for: .seconds(1.1), scheduler: RunLoop.main)
    .removeDuplicates()
    .sink { [weak self] email in
      self?.handleEmailInputChange(email: email)
    }
    .store(in: &cancellables)
}
```
debounce 적용 전에는, 사용자가 이메일 필드에 텍스트를 한 글자 한 글자 입력할 때마다 handleEmailInputChange()가 호출되어, 과도한 형식 오류 메시지가 발생했습니다.
debounce(약 1초) 적용으로, 불필요한 이메일 검증 API 호출을 줄이고 입력 도중 과도한 형식 오류 메시지가 뜨지 않도록 UX를 개선했습니다.


### 캐시 기반 프로필 이미지 로딩
```swift
enum ImageLoader {

    private static var cache = NSCache<NSString, UIImage>()

    static func loadImage(from urlString: String?) async -> UIImage? {
        
        if let cached = cache.object(forKey: urlString as NSString) {
            return cached
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            /* ... */
            cache.setObject(image, forKey: urlString as NSString)
            return image
        } catch {
            /* ... */
        }
    }

}
```
비동기 이미지 로딩 시 NSCache 기반 캐싱을 적용하여, 같은 URL의 이미지(동일한 사람의 프로필)를 여러 번 요청하는 상황에서 불필요한 네트워크 요청을 줄였습니다.
