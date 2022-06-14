# 1,タイトルと概要

## アプリ名:フォトタグ(PhotoTag)

<p>
  <img src="https://user-images.githubusercontent.com/65322807/173543137-91391a1c-9b91-41bd-9d61-305f541b54e1.png" width="30%">
  <img src="https://user-images.githubusercontent.com/65322807/173543580-6f992457-37e6-46aa-bca1-e5a9be96e101.png" width="30%">
</p>

- ### なぜつくるのか

  ios の｢写真｣アプリで不便な点があるので、そこの部分を改良したいから。

- ### ユーザーはこのアプリで何ができるのか？

  タグをつけることによって、写真の管理がしやすくなる。

- ### アピールポイント

  タグ同士で AND 検索を出来るようにした所。

  <img src="https://user-images.githubusercontent.com/65322807/173569182-ade4b92f-f495-49ce-a414-08d553ad9a9c.gif" width="20%">

  <!-- ![and](https://user-images.githubusercontent.com/65322807/173569182-ade4b92f-f495-49ce-a414-08d553ad9a9c.gif) -->

- ### プライバシーポリシー
  https://kurumi-ikeda.github.io/PhotoTagPrivacyPolicy/

# 2, 使用技術

- ## Flutter 2.5.2

### 使用したライブラリ

- photo_manager: ^1.3.7

- hive: ^2.0.4
- hive_flutter: ^1.1.0
- hive_generator: ^1.1.2
- video_player: ^2.2.16
- uuid: ^3.0.5
- provider: ^6.0.2
- chewie: ^1.3.1
- flutter_launcher_icons: ^0.9.2

# 3, 機能、非機能一覧

- 端末の写真を表示する機能
- 端末の写真を Tag に追加する機能
- Tag を削除する機能
- Tag を検索する機能
