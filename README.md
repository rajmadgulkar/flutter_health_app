# 🏋️‍♀️ Flutter Health & Fitness App  

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)](https://flutter.dev)  
[![Firebase](https://img.shields.io/badge/Firebase-Firestore%20%7C%20Auth-yellow?logo=firebase)](https://firebase.google.com/)  
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)  

A **responsive, production-ready** mobile application built with **Flutter**, following **MVVM + Clean Architecture**, and powered by **Firebase Authentication & Firestore**.  

This app is designed as per the given [Figma Design](https://www.figma.com/design/PI0W5LodE1yWi5GY0ZCP1p/Flutter-task/Flutter-task) 🎨 and implements authentication, assessments, appointments, challenges, and workout modules.  

---

## ✨ Features  

✅ Firebase Authentication (Login, Logout, Auto-check with simple animation)  
✅ Firestore Integration with **pagination & offline caching**  
✅ Assessment Module with detail view, **Hero animation**, and favorites (stored locally)  
✅ Appointment Module with booking and **calendar integration**  
✅ Tab-based navigation with smooth transitions  
✅ **Responsive design** across small phones, large phones, and tablets  
✅ Theming for consistent typography, spacing, and colors  

---

## 🏗️ Architecture Decisions  

We adopted the **MVVM (Model-View-ViewModel)** pattern with **Clean Architecture** principles:  

- **Model Layer**  
  Data models mapped from Firestore → converted to domain entities.  

- **Repository Layer**  
  Handles data retrieval/storage from Firestore, SharedPreferences, and cache.  

- **ViewModel Layer**  
  Contains business logic and state management. Exposes reactive states to UI.  

- **View Layer (UI)**  
  Flutter widgets strictly following the Figma design. Widgets are dumb and reactive only.  

**Benefits:**  
- 📈 Scalable for new modules (Nutrition, Mental Health, etc.)  
- 🧪 Testable (business logic independent of UI)  
- 🛠️ Maintainable (clear separation of concerns)  

---

## 🔄 State Management & Responsiveness  

We used **Provider + ChangeNotifier** for state management:  

- **Provider** → dependency injection and reactive state propagation  
- **ChangeNotifier** → lightweight observable ViewModels  

Why Provider?  
- Simple yet powerful for medium-scale apps  
- Easy migration to Riverpod/Bloc in future if scaling is needed  

**Responsiveness** ensured using:  
- `LayoutBuilder` & `MediaQuery` for adaptive layouts  
- Flex widgets (`Row`, `Column`, `Expanded`) to avoid overflows  
- Custom themes for typography, spacing, and colors  
- Dynamic image sizing with `BoxFit`  

---

## 🚧 Challenges Faced  

1. **Firestore Architecture**  
   - Balancing normalized vs denormalized data (`assessments`, `appointments`, `users/{userId}/bookings`).  
   - Solved via modular collections with subcollections for user-specific data.  

2. **State Management Choice**  
   - Bloc was considered, but Provider was chosen for its simplicity & speed of implementation.  

3. **UI Compactness & Responsiveness**  
   - Figma design had dense layouts requiring careful padding, scrolling, and constraints.  
   - Solved by modularizing widgets and adaptive layouts.  

4. **Ambiguity in Data Requirements**  
   - The task didn’t specify what exactly to persist in Firestore (favorites, challenge progress).  
   - Resolved by storing only essential attributes and keeping schema extensible.  


---

## ▶️ How to Run the App  

### 1️⃣ Clone the Repository  
```bash
git clone https://github.com/your-username/flutter-health-app.git
cd flutter-health-app

2️⃣ Install Dependencies
flutter pub get

3️⃣ Setup Firebase

Create a project in Firebase Console
.

Enable Authentication (Email/Password).

Enable Cloud Firestore.

Download and place Firebase config files:

google-services.json → android/app/

GoogleService-Info.plist → ios/Runner/

4️⃣ Run the App
flutter run

5️⃣ Test Responsiveness

Run on different emulators/simulators:

📱 Small phone

📱 Large phone

💻 Tablet

Experience Note:-

Working on this project was a rewarding journey. The late-night coding sessions (often at 3–4 AM) were both challenging and motivating. They pushed me beyond my comfort zone, teaching me how to stay disciplined and focused under time pressure. This experience not only strengthened my technical skills in Flutter and Firebase but also improved my resilience, problem-solving mindset, and ability to see a project through to completion.


