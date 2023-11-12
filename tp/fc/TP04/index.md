---
type: TP
number: 4
---

# Gestion intelligente d'objets connectés (1) - Base de données

Dans ce projet, vous allez créer en binôme votre propre système d'inventaire 
intelligent, capable de suivre tous les objets qui facilitent votre quotidien,
des gadgets électroniques aux outils de bricolage, le tout à l'aide d'une
application intuitive.
Vous devrez pour cela définir une API REST avec *Spring Boot* en utilisant une
base de données *MongoDB*, permettant de stocker des informations diverses sur
les objets de l'inventaire.
Votre application devra également permettre la génération de QR-codes pour
chaque objet, afin d'accéder instantanément à toutes leurs informations
à travers l'API de votre application.

Plus précisément, votre application doit permettre d'identifier les différents
objets inventoriés, qui sont caractérisés par par leur nom, par leur type
(par exemple, un câble d'alimentation, un câble USB, un appareil, *etc.*), une
description, un propriétaire, une année d'acquisition, un emplacement de
stockage, et d'autres informations variables.
Il faut aussi pouvoir associer des objets entre eux (par exemple, un appareil
et son câble d'alimentation).

Pour réaliser cette application, plusieurs sujets de TP vous seront proposés
afin de vous guider dans les différentes étapes de sa réalisation.
À l'issue de ce sujet, vous devriez être capables de :

- Créer et configurer un projet *Spring* utilisant une base de données
  *MongoDB*.
- Créer des *documents* (classes) pour représenter les données des collections
  à l'aide d'objets *Java*.
- Interroger une base de données *MongDB* depuis le code *Java*.

## Création du projet

Dans un premier temps, nous allons créer un nouveau projet *Spring*, avec les
dépendances appropriées.

1. Créez [un nouveau projet *Spring Boot*](https://start.spring.io).
   Ajoutez la dépendance *Spring Data MongoDB* à ce projet, qui fournit une
   bibliothèque permettant d'utiliser une base de données *MongoDB* dans des
   applications *Spring*.

2. Décompressez le projet créé à la question précédente, et importez-le dans
   votre IDE.

3. Pour indiquer à *Spring* comment accéder à la base de données, il faut
   configurer ces informations dans le fichier `application.properties`.
   Ce fichier doit avoir l'allure suivante, **en adaptant les valeurs inidquées
   à votre cas d'utilisation** :

   ```properties
   spring.data.mongodb.host=localhost
   spring.data.mongodb.port=27017
   spring.data.mongodb.database=databasename
   spring.data.mongodb.username=login
   spring.data.mongodb.password=password
   ```

## Création des documents de l'application

Un *document* est une classe *Java* dont les instances représentent des
documents *MongoDB*.
Dans le cadre de notre application, vous allez devoir définir un certain nombre
de classes (et donc de collections) afin de représenter les différents éléments
de votre application.

4. Déterminez les classes nécessaires au bon fonctionnement de votre
   application.

5. Pour chacune de ces classes, définissez-les dans le code *Java*, en les
   annotant avec `@Document`.
   Définissez également les collections *MongoDB* correspondantes dans votre
   base de données.

6. Ajoutez dans ces classes un attribut sous la forme d'un chaîne de caractères
   représentant l'identifiant de la base pour cet objet.
   Vous devrez l'annoter avec `@Id`.
   Sa valeur sera normalement auto-générée.

7. Ajoutez les attributs appropriés dans vos classes, et définissez des
   *getters* et des *setters* pour ces attributs.
   Si les noms des attributs diffèrent de ceux utilisés dans la base *MongoDB*
   (notamment si vous souhaitez respecter les conventions de nommage à la fois
   dans le code *Java* et dans la base), vous pouvez utiliser l'annotation
   `@Field` pour préciser pour chaque attribut concerné le nom correspondant
   dans la base.
   Comment faire si certains des attributs sont également des documents ?

## Définition d'un *repository*

De la même manière qu'avec JPA, nous allons utiliser un *repository* pour
accéder aux données depuis le code *Java*, grâce à l'interface
`MongoRepository`.

8. Définissez une interface étendant l'interface `MongoRepository`, en suivant
   le même principe que pour les *repository* JPA.

9. Consultez la *javadoc* de `MongoRepository` pour regarder les différentes
   méthodes fournies par cette interface.

10. Définissez les méthodes que vous estimez nécessaires au bon fonctionnement
    de votre application.

## Définition d'un *service*

Tout comment en JPA, vous avez besoin de définir des *services* pour réaliser
les traitements de votre application pour un document donné.

11. Définissez une classe annotée avec `@Service` pour proposer un service
    permettant de manipuler les données de votre application.
    Vous devez répeter cette opération pour chaque document.

12. Complétez ces classe pour fournir les données utiles à votre application.

## Définition du contrôleur

Pour pouvoir tester votre application, nous allons maintenant définir un
contrôleur REST afin de faire quelques requêtes sur votre application.

13. Définissez un contrôleur permettant de gérer les objets de l'inventaire.
    Toutes les routes de ce contrôleurs débuteront par `/api/objects`.

14. Définissez une route permettant d'ajouter des objets dans l'inventaire,
    ainsi qu'une route permettant de lister tous les objets contenus dans
    cet inventaire.

15. Lancez votre application, et essayez de créer des éléments de l'inventaire
    en passant par l'API, puis de les retrouver.

16. Complétez votre application en ajoutant les contrôleurs et routes
    nécessaires au bon fonctionnement de votre application.
