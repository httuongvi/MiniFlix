# Lộ trình học iOS (Swift + SwiftUI) — 15 ngày chi tiết

> **Mục tiêu:** Sau 15 ngày, hiểu và tự tay dựng được một **app iOS native hoàn chỉnh** — UI bằng SwiftUI, gọi API thật, xử lý logic/state, đa ngôn ngữ, push notification, quản lý app lifecycle, và biết **debug + đo hiệu năng** (kỹ năng này học sớm ở Day 4).
>
> **Dự án xuyên suốt:** `MiniFlix` — app duyệt phim dùng **TMDB API** (danh sách phim, tìm kiếm, chi tiết, yêu thích). Mỗi ngày bạn xây thêm 1 mảnh, đến cuối là một app chạy được thật.
>
> **Ngân sách thời gian:** ~4 giờ/ngày (2h học + 2h làm). Nếu ít hơn, ưu tiên phần **Làm**.

---

## Chuẩn bị trước khi bắt đầu (làm 1 lần)

- **Máy Mac** + cài **Xcode** bản mới nhất từ App Store (bắt buộc — không có Windows/Linux thay thế được cho iOS native).
- **Apple ID** miễn phí (đủ để chạy app lên simulator và device thật trong 7 ngày).
- **TMDB API key** — đăng ký tại themoviedb.org → Settings → API. **Lấy trước Day 6.**
- **(Tùy chọn, cho push thật) Apple Developer Program** ($99/năm) — cần trước **Day 11** nếu muốn test remote push trên device thật. Local notification và push giả lập trên simulator thì **không cần** tài khoản trả phí.
- Tạo sẵn một repo Git (GitHub) để commit mỗi ngày.

**Quy ước cả lộ trình:**
- Target **iOS 17+**, dùng **Swift 6 / Swift Concurrency (async/await)**, **@Observable** macro (không dùng `ObservableObject` kiểu cũ), **NavigationStack** (không dùng `NavigationView`).
- **KHÔNG** sửa tay file `.pbxproj`. Thêm file qua Xcode.

---

## Mẫu báo cáo hằng ngày (copy dùng mỗi tối)

```
📅 Day X — [Chủ đề]
⏱️ Thời gian thực học: ___h

✅ Đã học được (3 ý chính):
1.
2.
3.

🛠️ Đã làm trên app MiniFlix:
- Tính năng/màn hình:
- Commit: [link hoặc hash]

❓ Chỗ chưa hiểu / bị kẹt:
-

🔁 Cần ôn lại:
-

Tự chấm hôm nay (1-5): __
```

---

# TUẦN 1 — Nền tảng ngôn ngữ + UI + Debug + API

## Day 1 — Môi trường & Swift cơ bản (phần 1)

**Mục tiêu:** làm quen Xcode, chạy được project đầu tiên, nắm cú pháp Swift nền tảng.

**Học (~2h)**
- Giao diện Xcode: navigator, editor, canvas, simulator, cách chạy (⌘R).
- Playground để thử code nhanh.
- Biến/hằng (`var`/`let`), kiểu dữ liệu, string interpolation.
- Toán tử, `if`/`switch`, vòng lặp `for`/`while`.
- Mảng (`Array`), từ điển (`Dictionary`), set, tuple.
- Hàm: tham số, giá trị trả về, argument label.

**Làm**
- Tạo project SwiftUI mới tên `MiniFlix` (Interface: SwiftUI, Language: Swift). Chạy lên simulator.
- **Bài tập trong Playground:**
  1. Viết hàm `fizzBuzz(_ n: Int)` in 1→n theo luật FizzBuzz.
  2. Cho mảng số, viết hàm trả về (min, max, trung bình) dạng tuple.
  3. Đếm số lần xuất hiện mỗi từ trong một câu (dùng Dictionary).

**Tự kiểm tra:** giải thích được khác nhau `var` vs `let`, và khi nào dùng `switch` thay `if`.

---

## Day 2 — Swift cơ bản (phần 2): Optionals, Struct/Class, Protocol, Closure

**Mục tiêu:** nắm các khái niệm đặc trưng của Swift — nền tảng cho mọi thứ sau này.

**Học (~2.5h)**
- **Optional** (`?`, `!`), `if let`, `guard let`, `nil-coalescing (??)`, optional chaining. (Đây là thứ dễ gây crash nhất — học kỹ.)
- **Struct vs Class**: value type vs reference type, khi nào dùng cái nào (SwiftUI ưu tiên struct).
- `enum` + associated values + `switch` khớp mẫu.
- **Protocol** + protocol extension; `Codable`, `Identifiable`, `Hashable` (sẽ dùng nhiều).
- **Closure**: cú pháp, trailing closure, `map`/`filter`/`reduce`.
- Giới thiệu **async/await** (chỉ khái niệm, chưa dùng sâu).

**Làm**
- Tạo file `Movie.swift`: định nghĩa `struct Movie: Identifiable, Codable` với các field cơ bản (`id`, `title`, `overview`, `posterPath`, `voteAverage`).
- **Bài tập:**
  1. Có mảng `Movie`, dùng `filter` lấy phim `voteAverage > 7`, `map` lấy danh sách tên, `sorted` theo điểm giảm dần.
  2. Viết `enum LoadState { case idle, loading, loaded([Movie]), failed(String) }` và hàm nhận state in mô tả (luyện `switch` + associated value).

**Tự kiểm tra:** vì sao `Movie` nên là `struct` chứ không phải `class`?

---

## Day 3 — SwiftUI nền tảng: View, Layout, State

**Mục tiêu:** dựng được màn hình tĩnh + hiểu cơ chế state/binding.

**Học (~2h)**
- `View` protocol, `body`, cách SwiftUI "declarative" (mô tả UI theo state).
- Layout: `VStack`, `HStack`, `ZStack`, `Spacer`, `padding`, `frame`, `background`.
- `Text`, `Image`, `SF Symbols`, `Button`.
- Modifier và thứ tự modifier (quan trọng!).
- **`@State`** và **`@Binding`** — luồng dữ liệu 1 chiều của SwiftUI.
- `#Preview` để xem UI không cần chạy simulator.

**Làm**
- Dựng **`MovieCardView`**: 1 card hiển thị poster (tạm dùng `Image(systemName:)` hoặc màu placeholder), tên phim, điểm số. Dùng `#Preview` với dữ liệu mẫu.
- **Bài tập:**
  1. Làm màn hình đếm số: 1 `Text` + 2 nút `+`/`-` dùng `@State`.
  2. Tách nút thành subview riêng, truyền state xuống bằng `@Binding`.

**Tự kiểm tra:** khi bấm nút, tại sao UI tự cập nhật? (Giải thích được vai trò `@State`.)

---

## Day 4 — ⭐ Debug & Performance (học sớm — dùng cả 11 ngày còn lại)

> Đặt ở đây vì bạn muốn học sớm nhất có thể: tới lúc này bạn đã có Swift code + 1 màn hình để thực hành. Nắm sớm giúp mọi ngày sau tự gỡ lỗi thay vì đoán mò.

**Mục tiêu:** dùng thành thạo debugger của Xcode và biết đo hiệu năng cơ bản.

**Học (~3h)**
- **Breakpoint:** đặt/tắt, step over/into/out, continue; **conditional breakpoint**; breakpoint theo dòng vs theo symbol.
- **LLDB console:** lệnh `po` (print object), `p`, `expr` để đánh giá biểu thức khi đang dừng.
- **Đọc crash & stack trace:** tìm đúng dòng gây crash; hiểu lỗi thường gặp: force-unwrap `nil`, index out of range, main-thread issues.
- **Console / `print` có kỷ luật** vs debugger (khi nào dùng cái nào).
- **View debugging của SwiftUI:** dùng `Self._printChanges()` trong `body` để xem view **bị vẽ lại (redraw) vì lý do gì**.
- **Debug View Hierarchy** (nút 3D trong Xcode) để soi layout bị lệch/đè.
- **Instruments (giới thiệu):** mở template **Time Profiler** và **Allocations/Leaks**, chạy app, đọc cột thời gian CPU cơ bản. Chưa cần tối ưu sâu — chỉ cần biết mở và đọc.
- Vì sao SwiftUI **vẽ lại thừa** xảy ra và vai trò của việc giữ view nhỏ, chia subview hợp lý.

**Làm trên app**
- Cố tình tạo 1 bug: force-unwrap một optional `nil` → chạy → đọc crash → sửa bằng `guard let`.
- Đặt conditional breakpoint trong vòng lặp xử lý mảng `Movie` (dừng khi `voteAverage > 8`), dùng `po` in giá trị.
- Thêm `let _ = Self._printChanges()` vào `MovieCardView.body`, tương tác và xem log ai trigger redraw.
- Mở **Time Profiler** chạy app 30 giây, chụp lại màn hình kết quả để so sánh về sau.

**Tự kiểm tra:** dừng ở 1 breakpoint và in ra được giá trị 1 biến bằng `po` mà không cần thêm `print`.

---

## Day 5 — SwiftUI nâng cao: List, Navigation, Sheet, Form

**Mục tiêu:** dựng UI nhiều màn hình có điều hướng.

**Học (~2h)**
- `List` + `ForEach` (cần `Identifiable`), `.listStyle`, swipe actions.
- **`NavigationStack`** + `NavigationLink` + `.navigationTitle`; điều hướng theo giá trị (`navigationDestination`).
- `.sheet`, `.alert`, `.confirmationDialog`.
- `TabView` (thanh tab dưới).
- `ScrollView`, `LazyVStack`/`LazyVGrid` (và vì sao "Lazy" quan trọng cho hiệu năng — nối lại Day 4).

**Làm**
- Dựng **danh sách phim** (dữ liệu mẫu hard-code trước) bằng `List` + `MovieCardView`.
- Bấm 1 phim → `NavigationStack` mở **màn hình chi tiết** (poster lớn, mô tả, điểm).
- Thêm `TabView` 2 tab: "Phim" và "Yêu thích" (tab yêu thích để trống, làm sau).

**Bài tập:** thêm nút tìm kiếm mở `.sheet` chứa `TextField` lọc danh sách theo tên (dùng `@State` cho query).

---

## Day 6 — Networking & API (URLSession + Codable + async/await)

> **Cần TMDB API key trước ngày này.**

**Mục tiêu:** thay dữ liệu mẫu bằng dữ liệu thật từ mạng.

**Học (~2.5h)**
- `URL`, `URLRequest`, **`URLSession`** với `async/await`.
- **`Codable`** giải mã JSON → struct; `CodingKeys` khi tên JSON khác tên property (`poster_path` → `posterPath`).
- Xử lý lỗi mạng: `do/catch`, `throws`, các loại lỗi (không mạng, 4xx/5xx, decode fail).
- Chạy việc mạng **off main thread**, cập nhật UI **trên main thread** (`@MainActor`).
- Tải và hiển thị ảnh: **`AsyncImage`**.

**Làm**
- Tạo `TMDBService` với hàm `func fetchPopular() async throws -> [Movie]` gọi endpoint `/movie/popular`.
- Định nghĩa struct response khớp JSON của TMDB (dùng `CodingKeys`).
- Danh sách phim giờ lấy từ API thật; poster hiển thị bằng `AsyncImage`.
- **Dùng Day 4:** nếu request lỗi, đặt breakpoint trong `catch` và `po` cái error.

**Bài tập:** thêm hàm `searchMovies(query:)` gọi endpoint `/search/movie`, nối vào ô tìm kiếm ở Day 5.

**Tự kiểm tra:** giải thích vì sao phải `@MainActor` khi gán kết quả vào state.

---

## Day 7 — Kiến trúc & Logic: MVVM + @Observable + trạng thái loading/error

**Mục tiêu:** tách UI khỏi logic, quản lý state gọn gàng, xử lý mọi trạng thái.

**Học (~2h)**
- Vì sao không nhét logic mạng thẳng vào View.
- **MVVM** trong SwiftUI: View — ViewModel — Service/Model.
- Macro **`@Observable`** cho ViewModel; `@State` giữ ViewModel trong View; `@Bindable` khi cần binding.
- Mô hình **state rõ ràng:** `idle / loading / loaded / empty / error` (dùng lại `enum LoadState` từ Day 2).
- Hiển thị `ProgressView` khi loading, view lỗi + nút "Thử lại".

**Làm**
- Tạo `MovieListViewModel` (`@Observable`) giữ `LoadState`, gọi `TMDBService`.
- View hiển thị đúng theo state: loading → spinner, error → thông báo + retry, loaded → list, empty → "Không có phim".
- Refactor màn hình danh sách + tìm kiếm để dùng ViewModel.

**Bài tập:** thêm **pull-to-refresh** (`.refreshable`) gọi lại API.

**Tự kiểm tra:** vẽ được sơ đồ View → ViewModel → Service cho MiniFlix.

---

# TUẦN 2 — Dữ liệu, đa ngôn ngữ, lifecycle, push, test, tối ưu, hoàn thiện

## Day 8 — Lưu trữ dữ liệu: UserDefaults + SwiftData (Yêu thích)

**Mục tiêu:** dữ liệu tồn tại sau khi tắt app.

**Học (~2h)**
- **`UserDefaults`**: lưu cài đặt nhỏ (ví dụ: chế độ sáng/tối, ngôn ngữ đã chọn).
- **`SwiftData`** (iOS 17+): `@Model`, `ModelContainer`, `@Query`, insert/delete. (Nếu thấy nặng, có thể lưu danh sách id yêu thích bằng UserDefaults trước, SwiftData sau.)
- Vòng đời dữ liệu: khi nào đọc/ghi.

**Làm**
- Cho phép **đánh dấu yêu thích** 1 phim (nút trái tim ở màn chi tiết).
- Lưu phim yêu thích bằng SwiftData (hoặc UserDefaults).
- Tab "Yêu thích" (từ Day 5) hiển thị danh sách đã lưu, còn nguyên sau khi tắt/mở lại app.

**Bài tập:** thêm nút xóa khỏi yêu thích + swipe-to-delete trong tab Yêu thích.

**Tự kiểm tra:** đóng app hoàn toàn, mở lại → danh sách yêu thích vẫn còn.

---

## Day 9 — Localization (đa ngôn ngữ: Tiếng Việt + English)

**Mục tiêu:** app hiển thị đúng theo ngôn ngữ, ngày/số đúng định dạng vùng.

**Học (~2h)**
- **String Catalog (`.xcstrings`)** — cách làm localization hiện đại của Apple.
- `Text("key")` tự dịch; `String(localized:)`; chuỗi có tham số.
- Thêm ngôn ngữ trong project settings; đổi ngôn ngữ app khi test (scheme / device settings).
- **Định dạng theo vùng:** `Date.FormatStyle`, `Measurement`, format số/tiền tệ theo `Locale`.
- Pluralization (số ít/số nhiều) trong String Catalog.

**Làm**
- Tạo `Localizable.xcstrings`, đưa toàn bộ text tĩnh trong app vào (tiêu đề, nút, thông báo lỗi...).
- Dịch sang **Tiếng Việt + English**.
- Ngày phát hành phim hiển thị theo `Locale` hiện tại.
- Test: đổi ngôn ngữ simulator → app đổi theo.

**Bài tập:** thêm dòng "Đã lưu N phim yêu thích" dùng đúng plural rule cho cả 2 ngôn ngữ.

**Tự kiểm tra:** không còn chuỗi tiếng nào bị hard-code trong View.

---

## Day 10 — App Lifecycle & scenePhase

**Mục tiêu:** hiểu app chạy/nền/tắt thế nào và phản ứng đúng.

**Học (~2h)**
- Cấu trúc `@main` `App`, `Scene`, `WindowGroup`.
- **`@Environment(\.scenePhase)`**: `active` / `inactive` / `background` — làm gì ở mỗi trạng thái.
- Vòng đời: launch → foreground → background → terminate; điều gì hệ thống cho/không cho làm ở background.
- `onAppear`/`onDisappear`/`task` ở cấp View vs scenePhase ở cấp App.
- (Khái niệm) background task ngắn, vì sao không nên làm việc nặng ở background.

**Làm**
- Lắng nghe `scenePhase`: khi vào `background` thì **lưu state** (ví dụ tab đang mở, query tìm kiếm); khi `active` lại thì khôi phục.
- Khi quay lại `active` sau X phút thì **tự refresh** danh sách phim.
- Dùng `print`/breakpoint (Day 4) để xác nhận thứ tự các sự kiện lifecycle.

**Tự kiểm tra:** mô tả được điều gì xảy ra khi người dùng vuốt lên đa nhiệm rồi quay lại app.

---

## Day 11 — Push Notification (Local + Remote/APNs)

> Muốn test **remote push trên device thật** cần **Apple Developer Program** (chuẩn bị trước). Local notification thì không cần.

**Mục tiêu:** xin quyền, gửi được thông báo, xử lý khi người dùng bấm vào.

**Học (~2.5h)**
- Framework **`UserNotifications`**: xin quyền (`requestAuthorization`), kiểm tra trạng thái quyền.
- **Local notification:** tạo nội dung, trigger theo thời gian/lịch, lên lịch.
- **Remote push (APNs) — khái niệm + luồng:** device token, đăng ký với APNs, vai trò server, payload JSON.
- `UNUserNotificationCenterDelegate`: hiển thị noti khi app đang mở (foreground), xử lý khi người dùng **bấm vào** noti (deep link tới màn hình).
- Test remote push **giả lập trên simulator** bằng file `.apns` (kéo thả vào simulator hoặc `xcrun simctl push`).

**Làm**
- Xin quyền notification lúc mở app lần đầu (xử lý cả trường hợp bị từ chối).
- **Local notification:** "Nhắc bạn xem phim đã lưu" sau 10 giây / vào giờ đặt trước.
- Xử lý bấm noti → mở thẳng màn hình chi tiết của 1 phim (deep link cơ bản).
- Test push giả lập bằng file `.apns` trên simulator.

**Bài tập:** đặt cờ để không xin quyền lại nếu người dùng đã từ chối, thay vào đó hiện hướng dẫn mở Settings.

**Tự kiểm tra:** phân biệt được local vs remote notification và khi nào dùng cái nào.

---

## Day 12 — Testing (Unit test + UI test)

**Mục tiêu:** viết test tự động, tự tin sửa code không sợ hỏng.

**Học (~2h)**
- **Unit test** với framework Testing mới (`import Testing`, `@Test`, `#expect`) hoặc XCTest.
- Test logic thuần: mapper JSON→Model, filter/sort, LoadState.
- **Mock `TMDBService`** (dựa trên protocol) để test ViewModel không gọi mạng thật.
- **UI test** cơ bản: khởi động app, chạm phần tử, kiểm tra text xuất hiện.
- Chạy test (⌘U), đọc kết quả pass/fail.

**Làm**
- Viết unit test cho hàm decode JSON `Movie` (dùng JSON mẫu).
- Test `MovieListViewModel` với service giả trả về (a) dữ liệu, (b) lỗi → kiểm tra state chuyển đúng.
- 1 UI test: mở app → thấy danh sách → chạm phim đầu tiên → thấy màn chi tiết.

**Tự kiểm tra:** giải thích vì sao mock service giúp test nhanh và ổn định hơn gọi API thật.

---

## Day 13 — Tối ưu hiệu năng (Instruments sâu) + Accessibility

> Nối tiếp Day 4: giờ app đã đủ phức tạp để đo có ý nghĩa.

**Mục tiêu:** tìm và sửa vấn đề hiệu năng thật; app dùng được cho mọi người.

**Học (~2.5h)**
- **Time Profiler** sâu: tìm hàm ngốn CPU, cuộn (scroll) bị giật.
- **Allocations / Leaks:** phát hiện rò rỉ bộ nhớ, **retain cycle** trong closure (`[weak self]`).
- **SwiftUI hiệu năng:** giảm redraw thừa (dùng `Self._printChanges()` từ Day 4), tách view nhỏ, dùng `LazyVStack`/`LazyVGrid`, cache/`AsyncImage` hợp lý.
- **Accessibility:** `accessibilityLabel`, Dynamic Type (chữ co giãn), VoiceOver cơ bản, độ tương phản màu.

**Làm**
- Profile màn danh sách khi cuộn nhanh, tìm điểm giật, sửa (thường do view quá nặng hoặc load ảnh sai cách).
- Kiểm tra 1 closure có `self` xem có retain cycle không; sửa bằng `[weak self]` nếu cần.
- Thêm `accessibilityLabel` cho card phim và nút yêu thích; bật VoiceOver test thử.
- Bật Dynamic Type cỡ lớn nhất → kiểm tra layout không vỡ.

**Tự kiểm tra:** so sánh ảnh Time Profiler hôm nay với ảnh chụp ở Day 4 — bạn hiểu được các cột hơn hẳn.

---

## Day 14 — Hoàn thiện + Build + Archive + chuẩn bị TestFlight

**Mục tiêu:** biến project thành app "trông như thật" và biết cách phát hành.

**Học (~2h)**
- App icon + launch screen; đặt tên hiển thị, version/build number.
- Dark mode: kiểm tra app ở cả sáng/tối.
- **Build cho device thật** (ký bằng Apple ID), chạy trên iPhone của bạn.
- **Archive** (Product → Archive) và khái niệm phát hành qua **TestFlight** / App Store Connect (chỉ nắm quy trình nếu chưa có tài khoản trả phí).
- Dọn dẹp: xóa `print` thừa, cảnh báo (warnings), tách file gọn gàng.

**Làm**
- Thêm app icon + màn hình khởi động.
- Chạy app lên iPhone thật của bạn (nếu có).
- Rà soát toàn app: sửa hết warning, kiểm tra dark mode + cả 2 ngôn ngữ.
- Tạo 1 Archive thành công.

**Tự kiểm tra:** app cài được trên máy thật và dùng mượt ở cả 2 ngôn ngữ.

---

## Day 15 — Tổng ôn + Mini capstone + Review

**Mục tiêu:** củng cố, lấp lỗ hổng, và tự chứng minh đã hiểu.

**Học/Ôn (~1h)**
- Xem lại toàn bộ báo cáo 14 ngày, liệt kê 5 chỗ còn mơ hồ nhất → ôn lại.
- Vẽ lại sơ đồ kiến trúc MiniFlix từ đầu bằng trí nhớ.

**Capstone (~3h) — chọn 1 tính năng mới và tự làm trọn vẹn không chép hướng dẫn:**
- Ví dụ: màn "Phim theo thể loại" — gọi API mới, có loading/error state, có localization, cache yêu thích, viết 1 unit test, và profile 1 lần.
- Đây là bài kiểm tra thật: bạn phải tự dùng lại UI + API + logic + state + test + debug cùng lúc.

**Chốt lại:** viết 1 đoạn tổng kết "app native iOS gồm những mảnh gì và chúng ghép với nhau ra sao" — nếu viết trôi chảy nghĩa là đã đạt mục tiêu.

---

## Bản đồ nhanh: mỗi mục tiêu học ở đâu

| Yêu cầu của bạn | Ngày chính | Củng cố thêm |
|---|---|---|
| Xây dựng UI | Day 3, 5 | Day 13 (accessibility), 14 |
| Kết nối API | Day 6 | Day 7 (bọc trong ViewModel) |
| Xử lý logic code | Day 2, 7 | Day 12 (test logic) |
| Localization | Day 9 | — |
| Push notification | Day 11 | — |
| App lifecycle | Day 10 | Day 8 (lưu state) |
| **Debug & performance** | **Day 4 (sớm)** | Day 13 (Instruments sâu) |

## Nếu bị đuối giữa chừng — thứ tự ưu tiên
Ưu tiên hiểu chắc **Day 2 (Swift core) → Day 3 (SwiftUI state) → Day 4 (debug) → Day 6-7 (API + MVVM)**. Đây là bộ xương của mọi app iOS. Localization / push / test có thể làm nông hơn nếu thiếu thời gian, miễn là bạn *hiểu khái niệm* và biết tra khi cần.

---

# 📚 Kênh tài liệu tham khảo

> Mẹo: đọc chính thống của Apple để **đúng**, xem blog/YouTube để **hiểu nhanh và có ví dụ**. Khi bí một API, luôn tra Apple Documentation trước.

## Nguồn chính thống (Apple / Swift) — nên dùng làm chuẩn
- **Apple Developer Documentation** — https://developer.apple.com/documentation — tra API chính xác, đầy đủ nhất.
- **Swift.org** — https://www.swift.org/documentation/ — bản chất ngôn ngữ; có sách *The Swift Programming Language* miễn phí.
- **Develop in Swift Tutorials (Apple)** — https://developer.apple.com/tutorials/develop-in-swift — học Swift + SwiftUI từ đầu, chính chủ.
- **SwiftUI Tutorials (Apple)** — https://developer.apple.com/tutorials/swiftui — dựng UI theo từng bước có sẵn project mẫu.
- **WWDC Videos** — https://developer.apple.com/videos — kho video theo chủ đề; tìm đúng năm để lấy API mới nhất.

## Học nền tảng miễn phí (rất hợp cho lộ trình này)
- **Hacking with Swift — 100 Days of SwiftUI (Paul Hudson)** — https://www.hackingwithswift.com/100/swiftui — miễn phí, có bài tập mỗi ngày, khớp gần như 1-1 với lộ trình của bạn. **Nguồn nên bám sát nhất.**
- **Kodeco** (trước là Ray Wenderlich) — https://www.kodeco.com — tutorial iOS chất lượng, nhiều bài miễn phí.
- **CodeWithChris (YouTube)** — cho người mới hoàn toàn, giải thích chậm rãi.
- **Sean Allen (YouTube)** — video ngắn gọn, thực chiến, hay cập nhật tính năng mới.
- **Swiftful Thinking / Nick Sarno (YouTube)** — series SwiftUI + Concurrency dễ hiểu, có playlist theo chủ đề.

## Blog chuyên sâu (best practices, cập nhật nhanh theo iOS mới)
- **Swift by Sundell (John Sundell)** — https://www.swiftbysundell.com — bài viết chất về async/await, kiến trúc, testing.
- **SwiftLee (Antoine van der Lee)** — https://www.avanderlee.com — nhiều bài về concurrency, debug, performance.
- **Donny Wals** — https://www.donnywals.com — SwiftData, Concurrency, networking rất kỹ.
- **Point-Free** — https://www.pointfree.co — nâng cao (architecture, concurrency); trả phí nhưng nhiều video mở miễn phí.

## Tài liệu theo từng chủ đề khó trong lộ trình

| Chủ đề (Day) | Nguồn gợi ý |
|---|---|
| Swift core, Optional, Protocol (Day 1-2) | *The Swift Programming Language* (swift.org); 100 Days of SwiftUI phần đầu |
| SwiftUI, state/binding (Day 3, 5) | Apple SwiftUI Tutorials; Swiftful Thinking playlist "SwiftUI Bootcamp" |
| **Debug & Instruments (Day 4, 13)** | Apple: "Debugging" trong Xcode docs; WWDC — tìm "Demystify SwiftUI performance", "Explore the Instruments 26"; SwiftLee các bài "debugging" |
| Networking + async/await (Day 6) | Apple *Concurrency* docs; Swift by Sundell "async/await"; Donny Wals networking |
| MVVM + @Observable (Day 7) | Apple: "Managing model data" + macro `Observable`; Swiftful Thinking "@Observable" |
| SwiftData / lưu trữ (Day 8) | Apple SwiftData docs; **Fatbobman** — https://fatbobman.com (chuyên SwiftData); Donny Wals |
| Localization / String Catalog (Day 9) | Apple docs "String Catalog"; WWDC "Discover String Catalogs" |
| App lifecycle / scenePhase (Day 10) | Apple docs `scenePhase`, `App`/`Scene` |
| Push Notification (Day 11) | Apple *User Notifications* docs + "Setting up a remote notification server"; Kodeco tutorial push notification |
| Testing (Day 12) | Apple **Swift Testing** docs (`import Testing`); Swift by Sundell "unit testing" |
| Accessibility (Day 13) | Apple "Accessibility" docs; WWDC "Accessibility" sessions |

> Lưu ý về phiên bản: SwiftUI/Swift đổi API khá nhanh giữa các bản iOS. Khi một bài blog/video cũ dùng API lạ (`NavigationView`, `ObservableObject`...), hãy đối chiếu lại với Apple Documentation bản mới để dùng đúng chuẩn hiện tại (`NavigationStack`, `@Observable`).
