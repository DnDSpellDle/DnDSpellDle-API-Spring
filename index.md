---
type: TP
number: 1
---

# API des personnages d'une œuvre fictive

Dans ce sujet de TP, on se propose d'implanter une API REST en *Spring*
permettant de récupérer des informations sur les personnages d'une œuvre
fictive (par exemple, une bande dessinée, une série, un jeu vidéo, *etc.*).
Vous êtes libres de choisir l'œuvre qui vous intéresse.
À l'issue de ce TP, vous devriez être capable de :

- Créer et configurer un projet *Spring*.
- Définir des routes pour fournir une API REST.
- Interroger une base de données depuis le code de l'application.
- Échanger les données appropriées avec l'utilisateur.
- Valider les données fournies par l'utilisateur.

## Description de l'application

Dans ce TP, vous allez développer une API REST qui permettra de gérer les
informations sur les personnages de l'œuvre fictive choisie.
Votre objectif est de créer une application capable de répondre aux requêtes
CRUD classiques pour gérer ces personnages, tout en stockant les données dans
une base de données *SQLite*.
Assurez-vous de stocker un maximum d'informations sur vos personnages
(caractéristiques, relations avec d'autres personnages, *etc.*).
En effet, en plus des fonctionnalités classiques, vous devrez implanter des
routes permettant de créer un mini-jeu inspiré par exemple du concept de
[Loldle](https://loldle.net) ou [Pokedle](https://pokedle.net).
Ce jeu consistera à deviner un de vos personnages à partir de différents
indices, issus des données que vous avez stockées dans votre base.
Vous devrez donc développer des routes permettant de choisir un nouveau
personnage à deviner (sans le dévoiler, bien évidemment), de récupérer des
indices et de vérifier les réponses soumises par les utilisateurs.

## Création du projet

Dans un premier temps, nous allons créer un nouveau projet *Spring*.
Afin de faciliter la création de tels projets, les concepteurs de ce
*frameworks* proposent une [application web](https://start.spring.io) qui
vous permet de créer tous les fichiers de base dont vous avez besoin pour
démarrer votre projet.

1. Complétez le formulaire disponible sur [cette page](https://start.spring.io)
   afin de configurer le projet, en suivant les indications ci-dessous :

   - *Project* : `Gradle - Kotlin`
   - *Language* : `Java`
   - *Spring Boot* : `3.3.4`
   - *Metadata* :
     - *Group* : `fr.univartois.butinfo.r5a05`
     - *Artifact* : `votresujet`
     - *Name* : `Votre-Sujet`
     - *Description* : `Une super API pour votre sujet !`
     - *Package name* : `fr.univartois.butinfo.r5a05.demo`
     - *Packaging* : `Jar`
     - *Java* : `21`

   Ajoutez également les dépendances en cliquant sur `Add dependencies...`, et
   choisissez `Spring Web` pour avoir accès à la bibliothèque de *Spring*
   vous permettant de développer des applications web, et `Spring Data JPA`
   pour pouvoir accéder à la base de données.
   Ajoutez également la dépendance `Validation` pour pouvoir valider les
   données de l'utilisateur.
   Nous verrons dans ce TP comment l'utiliser.

2. Un fois le formulaire complètement rempli, cliquez sur `Generate` pour
   télécharger l'archive de base de votre projet, décompressez-la et importez
   le projet *Gradle* qu'elle contient dans votre IDE.

3. En reprenant les exemples fournis dans le TD n°3, complétez le fichier
   `build.gradle.kts` avec les dépendances nécessaires à l'utilisation de
   *SQLite*.
   Complétez également le fichier `application.properties` pour configurer
   l'accès à la base de données.

## Modèle de l'application

La première étape dans la réalisation de votre application est l'implantation
des classes du modèle, qui vont représenter les données qui seront manipulées
par votre application.

4. Définissez les classes nécessaires pour représenter les entités de votre
   application, en ajoutant les annotations appropriées et en implantant les
   *getters* et *setters* pour les différents attributs.
   Comme indiqué plus haut, renseignez autant d'informations que possible sur
   les personnages.

5. Définissez les *repositories* associés à ces classes, en spécifiant les
   signatures des méthodes dont vous avez besoin.

6. Définissez les services utilisant ces *repositories*.

## La validation

Jusqu'à maintenant, les données envoyées par l'utilisateur ont été considérées
comme correctes.
Par exemple, on ne vérifiait pas si les valeurs renseignées respectaient des
contraintes métiers (valeurs non nulles, chaînes non vides, respect de formats
spécifiques, *etc.*).
*Spring* fournit un certain nombre de mécanismes permettant de faire cette
validation automatiquement sur les données.

Pour plus de détails sur les étapes ci-dessous, n'hésitez pas à consulter le
[cours](https://gitlab.univ-artois.fr/enseignements-rwa/modules/but-3/r5-a-05/cours/-/blob/main/cours/03-echange-donnees.md).

7. Pour chacune de vos entités, définissez un DTO associé, en veillant à ne
   fournir que les informations nécessaires.
   Vous devez conserver les mêmes noms pour vos attributs chaque fois que ce
   sera possible.
   Si vous avez des entités « imbriquées », vous les remplacerez par leur
   identifiant dans le DTO.

8. Annotez les différents attributs de vos DTO avec les annotations de
   validation qui vous semblent appropriées.

## Échange de données avec le contrôleur 

Pour permettre à l'utilisateur d'accéder aux données de l'application, vous
allez maintenant définir un contrôleur pour votre application.

9. Complétez votre fichier `build.gradle.kts` pour ajouter la dépendance
   suivante, qui vous permettra de convertir automatiquement vos DTO :

   ```kotlin
   implementation("org.modelmapper:modelmapper:3.2.1")
   ```

10. Définissez les contrôleurs dont votre application a besoin, en fournissant
    les requêtes CRUD classiques (et uniquement celles-ci pour le moment).
    Les méthodes de ce contrôleur doivent systématiquement utiliser les DTO
    définis à la section précédente en paramètres et en valeurs de retour.
    Pour les convertir en entités, vous utiliserez `ModelMapper`, que vous avez
    ajouté à la question précédente.
    N'oubliez pas de convertir vos entités retournées par le service avant
    de les renvoyer à l'utilisateur.
    N'oubliez pas l'annotation `@Valid` sur les paramètres pour indiquer à
    *Spring* que vous souhaitez valider les données.

11. Testez votre application pour vérifier son bon fonctionnement, et notamment
    la validation des données fournies par l'utilisateur.

## Le jeu

Vous allez maintenant ajouter le code nécessaire à la gestion du jeu.

12. Définissez un nouveau contrôleur dédié au jeu.
    Celui-ci devra fournir entre autres des routes pour :

    - demander le choix d'un nouveau personnage ;
    - demander un indice ;
    - proposer une réponse et la vérifier.

13. Essayez d'utiliser votre application dans différentes fenêtres de navigation
    privée.
    Que constatez-vous sur le choix du personnage entre les fenêtres ?
    Comment pourriez-vous changer cela ?
