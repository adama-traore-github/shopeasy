# ShopEase 🛍️

ShopEase est une application e-commerce moderne et performante développée avec Flutter. Elle offre une expérience utilisateur fluide et esthétique pour naviguer, rechercher et acheter des produits.

## ✨ Fonctionnalités

*   **Localisation Française** 🇫🇷 : Interface entièrement traduite et devises formatées en XOF (FCFA).
*   **Design Premium** 🎨 : Thème clair et sombre (Dark Mode) avec une charte graphique soignée.
*   **Navigation Intuitive** 📱 : Barre de navigation personnalisée et transitions fluides.
*   **Recherche de Produits** 🔍 : Barre de recherche dynamique sur l'écran d'accueil.
*   **Assets Locaux** 📂 : Images de haute qualité intégrées pour un fonctionnement 100% hors ligne.
*   **Panier & Paiement** 🛒 : Simulation de gestion de panier et flux de paiement complet.

## 🛠️ Stack Technique

*   **Framework** : [Flutter](https://flutter.dev/)
*   **Langage** : Dart
*   **Gestion d'état** : [Provider](https://pub.dev/packages/provider)
*   **Persistance** : SharedPreferences
*   **Icônes** : Lucide Icons

## 📂 Structure du Projet

```
lib/
├── constants/       # Couleurs, thèmes et styles
├── models/          # Modèles de données (Product, Category, Order)
├── providers/       # Logique métier et gestion d'état
├── screens/         # Écrans de l'application (Home, Cart, Profile...)
├── utils/           # Utilitaires (Formatage devise...)
├── widgets/         # Widgets réutilisables (BottomBar, Cards...)
└── main.dart        # Point d'entrée de l'application
```

## 🚀 Installation et Lancement

1.  **Cloner le projet**
    ```bash
    git clone https://github.com/votre-username/shopease.git
    cd shopease
    ```

2.  **Installer les dépendances**
    ```bash
    flutter pub get
    ```

3.  **Lancer l'application**
    ```bash
    flutter run
    ```

## 📸 Aperçu

L'application inclut des images générées par IA pour les catégories (Électronique, Mode, Maison, Beauté) et les produits, garantissant une cohérence visuelle parfaite.
