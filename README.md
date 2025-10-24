# 🌲 T-Track – Timber Operation Tracking System

![Framework](https://img.shields.io/badge/framework-Flutter-blue)
![Database](https://img.shields.io/badge/database-Firebase-orange)
![Authentication](https://img.shields.io/badge/auth-Firebase%20Auth-yellow)
![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS-green)

A **cross-platform Flutter application** designed for the **State Timber Corporation of Sri Lanka** to digitally manage and track all tree-cutting and procurement operations.

## Table of Contents
- [Overview](#-overview)
- [User Roles](#-user-roles)
- [Key Features](#-key-features)
- [Workflow](#-workflow)
- [Emergency Handling](#-emergency-handling)
- [Security](#-security)
- [Tech Stack](#️-tech-stack)
- [Project Setup](#️-project-setup)
- [Demo & Resources](#-demo--resources)
- [Achievements](#-achievements)
- [Author](#-author)

---

## 🌳 Overview
The **State Timber Corporation** faced challenges in tracking tree-cutting requests and managing approvals across multiple divisions.  
**T-Track** solves this by enabling **digital request tracking**, **role-based workflows**, and **real-time status visibility** throughout the process — from request submission to tree removal.

> Developed to improve efficiency, transparency, and accountability in Sri Lanka’s timber operations.

---

## 👥 User Roles
1. **RM (Regional Manager)** – Initiates digital requests from paper letters received by Regional Secretaries.  
2. **ARM (Assistant Regional Manager)** – Reviews requests, manages procurement estimates, manage CO, and get selection decisions.  
3. **CO (Coupe Officer)** – Visits tree sites, collects data, uploads photos, and reports back.  
4. **AGM (Assistant General Manager)** – Reviews and approves/rejects high-value requests beyond RM’s authority.  
   
---

## 💡 Key Features
- **Digital Request Tracking:** Converts manual request letters into a live digital workflow.  
- **Role-Based Access:** Separate dashboards for RM, ARM, CO, AGM, and DGM.  
- **Tree Data Collection:** COs upload field data, measurements, and photos.  
- **Procurement Estimation:** ARMs calculate estimated values and choose between corporation or private sector removal.  
- **Approval Chain:** Smooth RM → ARM → CO → ARM → RM → AGM → ARM process flow.  
- **Private Sector Integration:** ARMs can initiate tenders and select private contractors.  
- **Live Status Tracking:** Every role can see the current stage of any request.  
- **Emergency Tree Handling:** Special module for identifying and fast-tracking dangerous trees for removal.

---

## 🔄 Workflow
### Step-by-Step Process
1. **RM** receives request from Regional Secretary → enters it into system.  
2. **ARM** receives request → assigns to nearest **CO**.  
3. **CO** visits site → records tree details & uploads photos.  
4. **ARM** prepares cost estimate → decides procurement method.  
5. **RM** reviews → approves if within authority or forwards to **AGM**.  
6. **AGM** approves/rejects → feedback sent back through RM → ARM.  
7. Once approved → **ARM** proceeds with removal process (corporate or private).  

---

## 🚨 Emergency Handling
- Flag dangerous trees for immediate attention.  
- Fast approval & removal workflow for emergencies.  
- Notifications sent automatically to RM and ARM.

---

## 🔐 Security
- **Firebase Authentication** for secure login & role-based access.  
- **Firebase Realtime Database** with structured read/write rules.  
- **Firebase Storage** for encrypted image uploads.  
- Real-time synchronization ensures up-to-date status across all devices.

---

## 🧰 Tech Stack
**Frontend:** Flutter (Dart)  
**Backend / Database:** Firebase Realtime Database  
**Authentication:** Firebase Auth  
**Storage:** Firebase Cloud Storage  
**Hosting:** Firebase  
**Platforms:** Android & iOS

---

## ⚙️ Project Setup
### Clone the repository
```bash
git clone https://github.com/yourusername/T-Track.git
cd T-Track

```
### Install dependencies
```bash
flutter pub get

```
### Configure Firebase
- Add your Firebase configuration files:
  - `google-services.json` → inside `android/app/`
  - `GoogleService-Info.plist` → inside `ios/Runner/`
- Enable **Authentication**, **Realtime Database**, and **Storage** in the Firebase Console.
- Update Firebase rules for secure role-based access.
```bash
flutter run
```
---


## 🎥 Demo & Resources
- **Demo Video:** https://youtu.be/UD8NB5iaGkk 

---

## 🏆 Achievements
- Built a **cross-platform government workflow system** with Flutter & Firebase.  
- Fully digitized the **tree-cutting request & approval process**.  
- Implemented **role-based dashboards** and **real-time updates**.  
- Integrated **secure image uploads** and **emergency handling**.  
- Improved **accountability and operational transparency** in timber management.

---

## 👨‍💻 Author
**[Induwara Dilhara](www.linkedin.com/in/induwara-dilhara-6128671a9)**  
Flutter Developer | Mobile App Developer  

📧 Email: s.h.induwara.dil@gmail.com



