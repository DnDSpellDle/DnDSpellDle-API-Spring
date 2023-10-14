---
type: TP
number: 3
---

# API des personnages d'une bande dessinée

Dans ce sujet de TP, on se propose d'implanter une API REST en *Spring*
permettant de récupérer des informations sur les personnages d'une bande
dessinée.
Il peut par exemple s'agir d'*Astérix et Obélix*, dont vous pouvez retrouver la
liste des personnages sur [cette page](https://asterix.com/les-personnages/).
Vous pouvez également choisir une autre bande dessinée si vous le souhaitez, du
moment que vos objets sont relativement similaires à ceux proposés ici (en
termes de diversité des attributs).
À l'issue de ce TP, vous devriez être capable de :

- Créer et configurer un projet *Spring* utilisant une base de données SQLite.
- Créer des *entités* (classes) pour représenter les données des tables à l'aide
  d'objets *Java*.
- Interroger une base de données depuis le code *Java*.
- Définir et utiliser un *service* pour traiter les données*.

## Création du projet

Dans un premier temps, nous allons créer un nouveau projet *Spring*, en suivant
la même approche que celle utilisée dans le sujet de TP précédent, en ajoutant
les dépendances nécessaires à la connexion avec une base de données.

1. Créez [un nouveau projet *Spring Boot*](https://start.spring.io).
   Ajoutez la dépendance *Spring Data JPA* à ce projet, qui fournit une
   bibliothèque de persistence pour les applications *Spring*.

2. Décompressez le projet créé à la question précédente, et importez-le dans
   votre IDE.
   Assurez-vous que les dépendances suivantes sont bien présentes dans votre
   fichier `build.gradle.kts` (complétez ce fichier si ce n'est pas le cas).

   ```kotlin
   dependencies {
       implementation("org.springframework.boot:spring-boot-starter-data-jpa")
       implementation("org.springframework.boot:spring-boot-starter-web")
       
       runtimeOnly("org.xerial:sqlite-jdbc")
       runtimeOnly("org.hibernate.orm:hibernate-community-dialects")

       testImplementation("org.springframework.boot:spring-boot-starter-test")
   }
   ```

3. Pour indiquer à *Spring* comment accéder à la base de données, il faut
   configurer ces informations dans le fichier `application.properties`, que
   vous devez placer dans le dossier `src/main/resources` (ou éventuellement
   `src/main/resources/config`).
   Le contenu de ce fichier doit avoir l'allure suivante :

   ```properties
   # Le driver pour la base de données (ici, SQLite).
   spring.datasource.driverClassName = org.sqlite.JDBC

   # Le chemin vers la base de données SQLite.
   spring.datasource.url = jdbc:sqlite:/chemin/vers/votre/base.db

   # Le dialecte à utiliser pour communiquer avec la base de données.
   spring.jpa.database-platform = org.hibernate.community.dialect.SQLiteDialect

   # L'action à réaliser par Spring pour maintenir la cohérence entre les
   # objets Java et les tables de la base ("create" et "validate" sont d'autres 
   # valeurs possibles).
   spring.jpa.hibernate.ddl-auto = update
   ```

## Création des entités de l'application

Une *entité* est une classe *Java* qui représente une table de la base de
données.
Plus précisément, chacun des attributs de cette classe va représenter une
colonne de la base.
Dans notre cas, nous allons représenter un personnage de la bande dessinée.

4. Définissez une classe `Character`, que vous annoterez à l'aide de
   `@Entity` et `@Table`.
   Cette dernière annotation prend un paramètre `name` spécifiant le nom de
   la table associée à l'entité dans la base de données.
   Vous pouvez lui donner le nom que vous souhaitez (*Spring* la créera pour
   vous).

5. Ajoutez dans cette classe un attribut numérique représentant l'identifiant
   du personnage dans la base.
   Vous devrez l'annoter avec `@Id` (pour indiquer qu'il s'agit d'une clef
   primaire) et `@GeneratedValue(strategy = GenerationType.IDENTITY)` pour
   que cette valeur soit automatiquement générée.

6. Ajoutez les attributs caractérisant un personnage, en particulier son nom,
   son genre, sa nationalité, le nombre d'albums dans lequel il apparaît,
   l'année où le personnage a été créé, ainsi qu'un lien vers une image
   représentant le personnage (vous pouvez utiliser un lien vers une image
   hébergée sur le site web mentionné plus haut).

7. Définissez des *getters* et des *setters* pour ces attributs.

## Définition d'un *repository*

En *Spring*, un *repository* fournit une partie du code permettant l'accès aux
données depuis le code *Java*, grâce à l'interface `JpaRepository`.
Pour accéder aux personnages de notre application, nous allons devoir en
définir un.

8. Définissez une interface étendant l'interface `JpaRepository`.
   Cette interface définit deux paramètres de type : le premier est le nom
   de l'entité (ici, `Character`), et le second le type de l'identifiant de
   l'objet (celui choisi à la question 5).
   **ATTENTION : Vous devez bien définir une *interface* ici, vous ne devez pas
   implémenter `JpaRepository`.**

9. Consultez la *javadoc* de `JpaRepository` pour regarder les différentes
   méthodes fournies par cette interface.

10. Définissez une méthode permettant de rechercher un personnage par son nom.
    Cette méthode doit impérativement retourner un objet de type `Character`,
    et s'appeler `findByName()` si l'attribut correspondant au nom s'appelle
    `name` (ou `findByNom()` s'il s'appelle `nom`, par exemple).
    **Cette méthode sera automatiquement implémentée par *Spring*, vous devez
    donc faire attention à bien respecter les conventions de nommage.**

## Définition d'un *service*

En *Spring*, un service implante la logique métier de l'application.
Un service doit réaliser les traitements fournit par l'application pour une
entité donnée.
Il peut s'agir par exemple de la validation des données fournies par
l'utilisateur, de leur transformation, de l'accès à la base de données *via* un
*repository*, *etc*.

11. Définissez une classe annotée avec `@Service` pour proposer un service
    permettant de manipuler les données relatives aux personnages de
    l'application.
    Cette classe doit définir un attribut dont le type est le *repository*
    défini à la section précédente, ainsi qu'un constructeur permettant de
    l'initialiser.
    Ce constructeur doit être annoté avec `@Autowired` pour indiquer à *Spring*
    qu'il devra se charger de l'instantiation de ce service.

12. Définissez une méthode permettant de créer un utilisateur dans la base de
    données.
    Une telle méthode pourrait avoir l'allure suivante :

    ```java
    public Character createCharacter(Character character) {
        return characterRepository.save(character);
    }
    ```

## Définition du contrôleur

Pour exposer le service *via* une API REST, vous devez définir un contrôleur,
de la même manière que vous l'avez fait dans le TP précédent.
Le contrôleur doit se charger de déléguer les opérations au service approprié.
Il ne doit pas y avoir de traitement dans le contrôleur, à moins que ce ne soit
pour extraire des informations de la requête reçue.

13. Définissez une classe annotée avec `@RestController`.
    Cette classe doit définir un attribut dont le type est le service défini à
    la section précédente, ainsi qu'un constructeur permettant de l'initialiser.
    Ce constructeur doit être annoté avec `@Autowired` pour indiquer à *Spring*
    qu'il devra se charger de l'instantiation de ce contrôleur.

14. Définissez une méthode annotée avec `@PostMapping` pour créer un personnage.
    Vous pouvez pour cela vous inspirer de ce que vous avez fait dans le TP
    précédent.
    Vous devrez passer par la méthode du service définie à la question 12 pour
    créer l'utilisateur dans la base.

15. Lancez votre application, et essayez de créer un personnage en passant par
    l'API (vous devrez faire une requête utilisant la méthode (HTTP) POST et
    envoyer les informations du personnage au format JSON).

## Complétion de votre application

Pour l'instant, il est uniquement possible de créer des personnages *via*
l'API REST que vous avez définie.
Complétez maintenant votre application pour pouvoir faire les requêtes de
recherche, de mise à jour et de suppression habituelles.
Pour cela, vous devrez, pour chacune des requêtes :

16. Définir une méthode dans le *service* qui utilise la méthode appropriée du
   *repository* pour réaliser les opérations sur la base (si besoin, vous devrez
   ajouter cette méthode **en respectant les conventions de nommage de *Spring*).

17. Définir une méthode dans le *contrôleur* utilisant la méthode définie dans
    le *service* pour réaliser l'opération demandée.

18. Tester si votre application fonctionne comme prévu.

## Pour aller plus loin

Si vous avez terminé, vous pouvez considérer les points suivants pour compléter
et améliorer votre application.
Notez que *Spring* fournit toutes le nécessaire pour implanter les
fonctionnalités décrites ci-dessous : à vous de les retrouver !

19. Pour l'instant, les données envoyées par l'utilisateur sont toujours
    considérées comme correctes.
    Cependant, les données fournies pourraient ne pas respecter les règles de
    l'application (par exemple, l'URL de l'image en est-elle vraiment une ?).
    Comment pourriez-vous faire pour valider les données saisies ?

20. Pour l'instant, il n'y a qu'une seule table dans notre application, et
    aucune relation.
    Comment pourrions nous faire pour :

    - Indiquer, pour chaque personnage, son éventuel·le conjoint·e (qui est
      également un objet de type `Character`) ?

    - Indiquer la ville où vit un personnage, sachant qu'une ville est un objet
      caractérisé par son nom et son pays, et que plusieurs personnages peuvent
      vivre dans cette même ville ?

    Pour ces différents points, vous devez à la fois compléter les entités de
    l'application, mais également ajouter les requêtes permettant d'exploiter
    ces informations (par exemple, retrouver tous les personnages vivant dans 
    une ville donnée).

20. Au fur et à mesure que votre application va s'étoffer, il va y avoir de plus
    en plus de personnages à afficher.
    Comment pourriez-vous faire pour proposer un découpage en pages ?
