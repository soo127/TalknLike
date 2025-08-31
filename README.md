본 프로젝트는 아직 완성되지 않은 프로젝트입니다.
### 테스트 계정: asd@naver.com / tkdtn5584@

# TalknLike 📌
할 일을 추가하고 마감일 저장, 푸시 알림을 설정할 수 있는 서비스입니다.


## 스킬

- UIKit
- MVC Pattern
- Combine
- Firebase (Authentication, Database) / Supabase(프로필 이미지 저장용)

## 특징

### 로그인
- 아이디와 비밀번호를 입력하여 로그인합니다.

#### 회원가입
- 이메일 입력을 완료하면, 일정 시간 후에 해당 이메일의 유효성을 평가합니다. (중복 여부, 형식 등)
- 이메일이 유효하다면, '확인'버튼을 눌러 이메일을 확정합니다.

- 이메일이 확정되면 비밀번호 필드가 활성화됩니다.
- 마찬가지로, 비밀번호가 유효하다면 '가입' 버튼이 활성화됩니다.


https://github.com/user-attachments/assets/858343ba-68be-456a-9279-5d2869bf1b02

(현재 비밀번호 필드는 녹화 시 자동으로 가려지는 현상이 발생해서, 추후 프로젝트가 완성될 때 README 전체를 수정하여 재업로드할 예정입니다.)

#### 아이디 찾기
- 해당 기능은 준비 중입니다.
#### 비밀번호 찾기
- 해당 기능은 준비 중입니다.

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

https://github.com/user-attachments/assets/446317a9-5930-48bf-99dc-ffa2bc851f99

## 친구

### 팔로워
- 나를 팔로우하는 사람들을 보여줍니다. 닉네임과 자기 소개, 프로필 사진이 표시됩니다.
- 셀을 클릭하면, 그 유저가 작성한 글들을 보여줍니다.

https://github.com/user-attachments/assets/2565ab92-a795-4fb1-8071-ab9a8935343f

### 팔로잉
- 내가 팔로우하는 사람들을 보여줍니다.
- 셀을 클릭하면, 그 유저가 작성한 글들을 보여줍니다.
- '해제'버튼을 눌러 팔로잉을 해제할 수 있습니다.


https://github.com/user-attachments/assets/603ccc03-63a1-4adb-bb02-afcbe9fdad5f


  
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

https://github.com/user-attachments/assets/74dc5e68-abd4-423c-b805-47d58aeefff6

## 알림




### 새 팔로우 요청
- 자신에게 팔로우를 요청한 유저들의 목록을 가져옵니다.
- '수락'버튼을 눌러 수락합니다.
<img width="200" height="400" alt="IMG_6566" src="https://github.com/user-attachments/assets/54248a34-4193-4400-8d35-e02ab9fc40e9" />

### 활동
- 자신의 게시글에 좋아요/ 댓글이 추가될 때마다 알림이 추가됩니다.
- 해당 알림 셀을 누르면, 그 게시글로 이동합니다.

https://github.com/user-attachments/assets/22bda060-69f5-44fc-8707-7835aa782a87


- 이미 삭제된 게시글로는 이동할 수 없습니다.

https://github.com/user-attachments/assets/ba8ae7d8-5a59-45db-8c24-9f6156a536c5

- 왼쪽으로 드래그하여 해당 셀을 제거합니다.

https://github.com/user-attachments/assets/5ba352cf-f506-47e1-9db0-579972fece14


## 프로필
<img width="200" height="400" alt="IMG_6562" src="https://github.com/user-attachments/assets/e5c63e2c-3266-41f6-9cae-21e9741260fc" />

### 내가 쓴 글
- 내 게시글을 볼 수 있습니다.
- 셀을 꾹 누르면, 게시글을 수정하거나 삭제할 수 있습니다.

https://github.com/user-attachments/assets/949c5c76-466a-4350-a49f-929a28f36eff

### 편집
- 자신의 프로필 사진과 닉네임, 자기소개를 수정할 수 있습니다.
- 카메라 버튼을 눌러 사진을 가져옵니다.
  

https://github.com/user-attachments/assets/de5023da-7c3c-4966-a7ab-8eb02dffdaee


- 닉네임 수정시, 현재 필드에 입력한 글자 수가 표시됩니다.
- 최대 글자수를 넘어가면, 숫자 라벨이 빨간 색으로 변하며 닉네임을 저장할 수 없습니다.
<img width="200" height="400" alt="IMG_6559" src="https://github.com/user-attachments/assets/07073d10-446e-4a51-a8ed-2d2e39a2cfd2" />
<img width="200" height="400" alt="IMG_6558" src="https://github.com/user-attachments/assets/8e32831f-73f8-4723-aee0-1edf77a6e2ec" />

- 자기소개 수정시, 현재 필드에 입력한 글자 수가 표시됩니다.
- 2줄 이내로 작성할 수 있습니다.
<img width="200" height="400" alt="IMG_6561" src="https://github.com/user-attachments/assets/f3339463-3356-4ad0-b9b2-81bf2140c46a" />


### 로그아웃
- 로그아웃 버튼을 눌러 로그아웃합니다.

https://github.com/user-attachments/assets/434c3e6b-8fef-496a-8f70-071ed8240704
