# Fonev – Real Estate Management Application

Fonev is a Flutter-based mobile real estate management application developed as a technical case study.

The application allows real estate businesses to manage customers and properties, upload property images, search properties using multiple filters, and export property details as PDF files.

## Features

### Authentication
- User registration with email and password
- User login
- Firebase Authentication integration

### Business Management
- Create and ma# Fonev – Real Estate Management Application

Fonev is a Flutter-based mobile real estate management application developed as a technical case study.

The application allows real estate businesses to manage business information, customers and properties, upload multiple property images, search properties using multiple filters, and export and share property details as PDF files.

## Features

### Authentication
- User registration with email and password
- User login
- Firebase Authentication integration

### Business Management
- Create and manage real estate business information
- Store business name, authorized person, address, and phone information
- Persist business information in Cloud Firestore

### Customer Management
- Add customers
- Edit customer information
- Delete customers
- Define customer type as Owner or Tenant
- Use Owner customers as property owners
- Select Tenant customers during property search
- Prevent deletion of an Owner customer while a property is associated with that customer

### Property Management
- Add properties
- Edit properties
- Delete properties
- Associate properties with Owner customers
- Select and upload multiple property images
- Store property images using Firebase Storage
- Remove associated Storage images when properties are deleted
- Manage property image updates

Property information includes:
- Title
- Address
- Listing type (For Rent / For Sale)
- Property type
- Price
- Square meters
- Room count
- Floor
- Building floors
- Heating type
- Property owner
- Property images

### Property Search
Tenant customers can be selected during the property search process.

Properties can be filtered by:
- Listing type
- Minimum price
- Maximum price
- Room count
- Minimum square meters

Matching properties are displayed dynamically according to the selected filters.

### Property Details
Users can open a selected property and view its detailed information.

The detail screen includes:
- Property title
- Property images
- Address
- Listing type
- Property type
- Price
- Square meters
- Room count
- Floor
- Building floors
- Heating type

Multiple property images can be viewed in a horizontally scrollable gallery.

### PDF Export & Sharing
Property information can be converted into a PDF document and shared using the device's native sharing functionality.

## Technologies

- Flutter
- Dart
- Firebase Authentication
- Cloud Firestore
- Firebase Storage
- Provider
- Image Picker
- PDF
- Printing

## Architecture and State Management

The application uses a simple and maintainable project structure with separation between application screens and state management.

Provider is used for state management.

`PropertyProvider` is responsible for loading and managing property data and notifying listening widgets when the application state changes.

Provider was selected because it provides a lightweight and understandable state management solution suitable for the scope of the application while keeping state logic separated from the UI.

The project is organized mainly into:

```text
lib/
├── pages/
│   ├── business_page.dart
│   ├── customer_page.dart
│   ├── property_page.dart
│   ├── search_page.dart
│   └── property_detail_page.dart
│
├── providers/
│   └── property_provider.dart
│
├── firebase_options.dart
└── main.dart
```

## Firebase

The application uses Firebase as its backend infrastructure.

The following Firebase services are used:

- Firebase Authentication
- Cloud Firestore
- Firebase Storage

### Firebase Authentication

Email/password authentication is used for user registration and login.

Only authenticated users are allowed to access application data according to the configured Firestore and Storage security rules.

### Cloud Firestore

Application data is stored using a NoSQL collection-based structure.

The main collections are:

```text
businesses
customers
properties
```

### Businesses Collection

Structure:

```text
businesses/{userId}

name
authorizedPerson
address
phone
userId
```

The authenticated user's UID is used as the business document ID.

### Customers Collection

Structure:

```text
customers/{customerId}

firstName
lastName
name
phone
email
customerType
```

`customerType` can have one of the following values:

```text
Owner
Tenant
```

Owner customers can be associated with properties.

Tenant customers can be selected on the property search screen.

### Properties Collection

Structure:

```text
properties/{propertyId}

title
address
price
propertyType
squareMeters
roomCount
floor
buildingFloors
heatingType
type
ownerId
imageUrls
```

The `ownerId` field stores the Firestore document ID of the Owner customer associated with the property.

This creates a relationship between documents in the `properties` and `customers` collections.

The `imageUrls` field stores a list of Firebase Storage download URLs for the property's images.

## Firebase Storage

Property images are stored in Firebase Storage under:

```text
property_images/
```

Users can select and upload multiple images for a property.

After the images are uploaded, their download URLs are stored as a list in the corresponding Firestore property document using the `imageUrls` field.

When property images are replaced or a property is deleted, the related Firebase Storage files are also managed by the application.

## Security

Firestore and Firebase Storage access is restricted to authenticated users.

The project includes:

```text
firestore.rules
storage.rules
```

The main access rule used by the project is:

```text
allow read, write: if request.auth != null;
```

This ensures that unauthenticated users cannot directly read or modify application data or property images.

## Firebase Configuration Security

Firebase platform configuration files are intentionally excluded from the public repository.

The following files are excluded using `.gitignore`:

```text
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
```

These files must be configured locally when the project is run with another Firebase project.

## Firebase Setup

To run the project with Firebase:

1. Create a Firebase project.
2. Enable Email/Password authentication.
3. Create a Cloud Firestore database.
4. Enable Firebase Storage.
5. Register an Android application in the Firebase project.
6. Configure the project using FlutterFire.
7. Add the required Firebase configuration file to the local Android project.
8. Apply the Firestore and Storage security rules included in the repository.

For Android, place the Firebase configuration file at:

```text
android/app/google-services.json
```

For iOS, if iOS configuration is required, place:

```text
ios/Runner/GoogleService-Info.plist
```

Firebase configuration files excluded by `.gitignore` are not committed to the public repository.

## Installation

Make sure Flutter and the required Android development tools are installed.

Clone the repository:

```bash
git clone <repository-url>
```

Open the project directory:

```bash
cd fonev
```

Install Flutter dependencies:

```bash
flutter pub get
```

Configure Firebase for your own Firebase project.

Then run the application:

```bash
flutter run
```

## Application Flow

A typical application flow is:

1. Register a new user or log in using an existing account.
2. Create or update real estate business information.
3. Create an Owner customer.
4. Add a property and associate it with the Owner customer.
5. Select and upload one or more property images.
6. Create a Tenant customer.
7. Select the Tenant and search for matching properties using listing type, price, room count, and square meter filters.
8. Open a matching property's detail screen.
9. Export and share the property information as a PDF document.
10. Restart the application and retrieve persisted data from Firebase.

## Data Persistence

Business, customer, and property information is stored in Cloud Firestore.

Property images are stored in Firebase Storage.

Because application data is persisted using Firebase services, previously created records can be retrieved again after the application is restarted.

## Screenshots

Application screenshots are provided in the `screenshots/` directory.

The screenshots demonstrate the main application screens and functionality, including authentication, business management, customer management, property management, property search, property details, and PDF sharing.

## Platform

The application has been developed and tested on Android using an Android emulator.

Android is the primary platform targeted for this technical case study.

## Developer

Developed by Melis Tokat as a Flutter mobile application technical case study.nage real estate business information
- Store business name and authorized person information

### Customer Management
- Add customers
- Edit customer information
- Delete customers
- Define customer type
- Use customers as property owners

### Property Management
- Add properties
- Edit properties
- Delete properties
- Associate properties with customers
- Upload property images
- Store property images using Firebase Storage

Property information includes:
- Title
- Address
- Listing type (For Rent / For Sale)
- Property type
- Price
- Square meters
- Room count
- Floor
- Building floors
- Heating type
- Property owner
- Property image

### Property Search
Properties can be filtered by:
- Listing type
- Minimum price
- Maximum price
- Room count
- Minimum square meters

### Property Details
Users can view detailed information about a selected property.

### PDF Export & Sharing
Property information can be converted into a PDF document and shared using the device's native sharing functionality.

## Technologies

- Flutter
- Dart
- Firebase Authentication
- Cloud Firestore
- Firebase Storage
- Provider
- Image Picker
- PDF
- Printing

## Architecture and State Management

Provider is used for state management.

`PropertyProvider` is responsible for managing property data and notifying listening widgets when the application state changes.

This approach was selected because it provides a simple separation between UI and state management while keeping the project maintainable and easy to understand.

The project is organized mainly into:

```text
lib/
├── pages/
│   ├── business_page.dart
│   ├── customer_page.dart
│   ├── property_page.dart
│   ├── search_page.dart
│   └── property_detail_page.dart
│
├── providers/
│   └── property_provider.dart
│
├── firebase_options.dart
└── main.dart
```

## Firebase

The application uses the following Firebase services:

### Firebase Authentication

Email/password authentication is used for user registration and login.

### Cloud Firestore

Application data is stored using a NoSQL collection-based structure.

Main collections:

```text
businesses
customers
properties
```

Example property document:

```text
properties/{propertyId}

title
address
price
type
ownerId
propertyType
squareMeters
roomCount
floor
buildingFloors
heatingType
imageUrl
```

The `ownerId` field creates a relationship between a property and a customer document.

### Firebase Storage

Property images are stored under:

```text
property_images/
```

After an image is uploaded, its download URL is stored in the corresponding Firestore property document using the `imageUrl` field.

## Security

Firestore and Firebase Storage access is restricted to authenticated users.

Firebase configuration files are intentionally excluded from the public repository:

```text
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
```

## Firebase Setup

To run the project with Firebase:

1. Create a Firebase project.
2. Enable Email/Password authentication.
3. Create a Cloud Firestore database.
4. Enable Firebase Storage.
5. Register the Android application with Firebase.
6. Add the required Firebase configuration for the local environment.
7. Configure the project using FlutterFire.

Firebase configuration files containing project-specific configuration are not included in the public repository.

## Installation

Make sure Flutter is installed.

Clone the repository:

```bash
git clone <repository-url>
```

Open the project directory:

```bash
cd fonev
```

Install dependencies:

```bash
flutter pub get
```

Configure Firebase for your own Firebase project and then run:

```bash
flutter run
```

## Application Flow

A typical application flow is:

1. Register or login.
2. Create business information.
3. Create an owner customer.
4. Add a property associated with the owner.
5. Select and upload a property image.
6. Create additional customers when required.
7. Search properties using filters.
8. Open the property detail screen.
9. Export and share the property information as PDF.
10. Reload the application and retrieve persisted data from Firebase.

## Screenshots

Application screenshots will be available in the `screenshots/` directory.

## Platform

The application has been developed and tested on Android using an Android emulator.

## Developer

Developed by Melis Tokat as a Flutter mobile application technical case study.