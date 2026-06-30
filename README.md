# KidX - iOS AI Early-Learning App for Kids 🚀

## 📖 Overview
**KidX** is a native iOS early-education application designed to create an interactive learning environment for children under 8 years old. The application blends **bilingual vocabulary learning (English - Vietnamese)** and **intuitive mathematical thinking** by leveraging Apple's native **Core ML** and **Vision Framework**. 

By running artificial intelligence models completely on-device, KidX provides children with real-time interactive feedback without requiring a persistent internet connection for core features, ensuring maximum privacy and data security.

The codebase is built on **UIKit**, structured with the clean **MVVM (Model-View-ViewModel)** architectural pattern, and features a polished, kid-friendly design.

---

## ✨ Key Features
* **📸 Smart Vocabulary & Camera AI**: 
  - Real-time object recognition using a Core ML image classifier model (`MobileNet`) via the **Vision Framework**.
  - Children capture photos of physical objects around them, and the AI identifies the objects to teach bilingual vocabulary.
  - Successfully discovered objects are saved along with timestamps and images in **"Baby's Collection" (Bộ sưu tập của bé)**.
* **✍️ Digital Math Canvas**:
  - A custom digital drawing canvas that tracks finger gestures using `UIBezierPath` and `Core Graphics`.
  - Integrates an on-device Core ML digit classifier (`mnistCNN`) to recognize handwritten digits.
  - Children practice number tracing and solve basic arithmetic calculations (addition & subtraction) by drawing answers directly on the blackboard.
* **🗣 Interactive Audio & Bilingual TTS**:
  - Text-to-speech song ngữ (English & Vietnamese) powered by Apple's **AVFoundation** (`AVSpeechSynthesizer`).
  - Supports standard pronunciation helpers for flashcards and recognized object names.
* **📊 Learning Statistics & Achievements**:
  - A dedicated progress screen displaying stars collected, vocabulary mastered, and completed challenges.
  - Powered by **DGCharts** to visualize weekly study time and milestones.

---

## 🛠 Tech Stack & Architecture

### 🏗 Architecture: MVVM (Model-View-ViewModel)
The app adheres strictly to the MVVM architectural design pattern to ensure clean separation of concerns, maintainability, and ease of testing:
* **Model**: Representing domain objects like `BasicFlashCardCategory`, `SavedObjectItem`, and `DailyAchievementStats`.
* **View**: Built with **UIKit**, custom components, auto layout, and **XIBs** for reuse.
* **ViewModel**: Managing UI state and coordinating with data services, keeping the view controllers thin and declarative.

### 🧰 Key Technologies
* **Platform & Language**: iOS 18.0+ / Swift 5.
* **Machine Learning**: `Core ML` and `Vision Framework` (utilizing on-device classification models for objects and digits).
* **BaaS (Backend as a Service)**: 
  - **Firebase Auth**: User registration, login, and Google Sign-in integration.
  - **Firebase Realtime Database**: Stores categories, flashcard assets, vocabulary structures, and study log syncing.
* **Local Storage**: 
  - **UserDefaults**: Lightweight local storage for caching statistics, completed challenges, and preferences.
  - **FileManager**: Secure local storage of captured child's photos and media.
* **Graphics & Rendering**: Core Graphics & `UIBezierPath` for rendering handwritten inputs on the math canvas.
* **Bilingual Voice**: `AVFoundation` for synthetic speech.
* **Data Visualization**: `DGCharts` for rendering interactive statistics.
