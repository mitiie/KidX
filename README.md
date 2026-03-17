# [KidX] - iOS AI Educational App for Kids 🚀

## 📖 Overview
**[KidX]** is a native iOS application designed to create an interactive learning environment for children. By leveraging Apple's **Core ML** and **Vision Framework**, the app brings physical objects and hand-drawn digits into the digital learning experience, entirely offline.

This project was built focusing on clean architecture (MVVM), high-performance UIKit rendering, and kids-friendly UI/UX.

## ✨ Key Features
* **📸 Smart Vocabulary:** Real-time object recognition via Camera using the `MobileNetV2` model to help kids learn bilingual vocabulary.
* **✍️ Digital Math Canvas:** A custom drawing board that recognizes handwritten digits using the `MNIST` model, helping kids practice numbers and basic math.
* **🗂 Offline First:** Uses `Realm` database for saving learning progress, flashcards, and local statistics without requiring an internet connection.
* **🔒 Parental Gate:** Built-in security flow for parents to manage accounts and sync data to `Firebase`.

## 🛠 Tech Stack
* **Platform:** iOS 18.0+
* **Language:** Swift 5
* **Architecture:** MVVM (Model-View-ViewModel)
* **UI Framework:** UIKit, Core Graphics
* **Machine Learning:** Core ML, Vision Framework (MobileNetV2, MNIST)
* **Database & BaaS:** Realm (Local), Firebase (Auth & Cloud Sync)
