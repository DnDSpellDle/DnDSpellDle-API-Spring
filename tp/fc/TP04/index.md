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

## Validation des données de l'utilisateur

Jusqu'à maintenant, les objets transmis dans les requêtes ou les réponses sont
directement les objets « persistés » dans la base de données (des entités ou des
documents, suivant le type de la base utilisée).
Bien que cela fonctionne, cela peut poser des problèmes.
Par exemple, si les données saisies par l'utilisateur sont incorrectes, des
identifiants peuvent être consommés par des objets qui ne seront pas stockés
dans la base, comme ces objets eux-mêmes sont incorrects.
Un autre problème est qu'envoyer à l'utilisateur les objets directement
récupérés depuis la base peut exposer des données relatives à ces objets que
l'on ne souhaiterait pas rendre disponible.
C'est pour cela que l'on préfère souvent utiliser une autre classe pour les
objets échangés dans les requêtes.
Ces classes sont appelés *DTO* (pour *Data Tranfer Objects*), en opposition aux
*DO* (pour *Domain Objects*) constitués par les entités/documents.

17. Pour chacun de vos DO (donc chacune de vos classes correspondant à un
    document), écrivez une classe représentant son équivalent DTO, que vous
    nommerez comme vos DO en ajoutant le suffixe `DTO`.
    Ces classes devront contenir les attributs du document que vous souhaitez
    transmettre dans vos requêtes.
    Ajoutez les *getters* et *setters* que vous jugerez utiles.

18. Pour pouvoir envoyer un DTO dans vos requêtes, vous allez avoir besoin de
    *mapper* vos DO en DTO, et inversement.
    Ce *mapping* devra se faire dans le service.

    a. Modifiez vos méthodes dans chacun de vos services pour qu'elles
       retournent maintenant des DTO et prennent en paramètres des DTO à la
       place des DO utilisés actuellement.

    b. Pour transformer un DO en DTO et inversement, il faut copier chacun des
       attribut de l'un dans l'attribut de l'autre.
       Plutôt que de le faire manuellement, nous allons utiliser un
       `ModelMapper`, qui effectue cette copie automatiquement.
       Pour cela, vous devez ajouter à votre projet *Gradle* la dépendance
       `org.modelmapper:modelmapper:3.2.0`.

    c. Complétez votre service pour qu'un `ModelMapper` y soit *injecté*
       (définissez un attribut de ce type initialisé dans un constructeur
       annoté avec `@Autowired`).
       Complétez ensuite les méthodes du service pour utiliser ce *mapper*
       afin d'effectuer les conversions appropriées grâce à la méthode `map()`
       du *mapper*.

    d. Adaptez votre contrôleur pour tenir compte des changements apportés au
       service.

    e. Testez votre application afin de vous assurer que tout fonctionne.

19. L'avantage d'utiliser des DTO est que l'on peut facilement vérifier que les
    informations saisies par l'utilisateur pour chacun des attributs sont
    correctes, en utilisant des annotations.

    a. Ajoutez les annotations appropriées sur les attributs de vos DTO afin
       de préciser les contraintes qui doivent être respectées sur ces
       attributs, en précisant un éventuel message d'erreur qui sera retourné à
       l'utiliateur dans le cas d'une donnée incorrecte.
       Vous pouvez pour cela retrouver la liste des contraintes disponibles sur
       [la javadoc](https://jakarta.ee/specifications/bean-validation/3.0/apidocs/jakarta/validation/constraints/package-summary).
       Notez que vous pouvez ajouter plusieurs annotations différentes sur un
       même attribut.

    b. Afin de vous assurer que les données reçues de l'utilisateur respectent
       les contraintes définies à la question précédente, vous devez demander
       à *Spring* de *valider* les objets reçus comme `@RequestBody`.
       Pour cela, vous devez ajoutez l'annotation `@Valid` sur les paramètres
       de méthodes concernés.
       Grâce à elle, vous avez la certitude que les objets donnés satisfont
       toutes les contraintes quand vous les utilisez dans la méthode.

    c. Testez votre application, en essayant de fournir des données correctes
       ainsi que des données incorrectes.
       Que se passe-t-il dans ce dernier cas ?
