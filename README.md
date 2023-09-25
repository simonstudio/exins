# exins

A new Flutter project.

## cài thư viện
```
flutter pub get
```

- Thay đổi địa chỉ api
lib/Views/Mobile/mobile_get_started.dart:63
```javascript
    const baseUrl =
        'https://api.metafanpagesupport.pro/v1/users/create'; // Replace with your API base URL
```

- Build và đổi tên thư mục web thành domain mong muốn
```
flutter build web
mv build/web/* build/web/<domain> -r  
```
