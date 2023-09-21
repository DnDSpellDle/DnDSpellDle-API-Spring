---
type: TP
number: 2
---

# Initiation au *framework* *Spring* et premières applications

*Jakarta EE* (anciennement *Java EE* ou *J2EE*) définit une spécification
permettant de développer des applications web en *Java*.
Cette spécification est à la base de différents *frameworks*, visant à
simplifier le développement de telles applications.
Parmi ces *frameworks*, l'un des plus important est *Spring*, que nous allons
découvrir dans ce TP, à l'issue duquel vous devriez être capable de :

- Créer un projet *Spring* en utilisant *Spring Initializr*.
- Adapter le projet *Spring* de base suivant les besoins de l'application.

## *Spring Initializr*

Afin de faciliter la création de projets *Spring*, les concepteurs de ce
*frameworks* proposent une [application web](https://start.spring.io) qui
vous permet de créer tous les fichiers de base dont vous avez besoin pour
démarrer votre projet.

1. Complétez le formulaire disponible sur [cette page](https://start.spring.io)
   afin de configurer le projet de la manière suivante :

   - Project : `Gradle - Kotlin`
   - Language : `Java`
   - Spring Boot : `3.1.4`
   - Metadata :
        - Group : `fr.univartois.butinfo.r5a05`
        - Artifact : `demo`
        - Name : `demo`
        - Description : `My first Spring application!`
        - Package name : `fr.univartois.butinfo.r5a05.demo`
        - Packaging : `Jar`
        - Java : `17`

   Ajoutez également une dépendance en cliquant sur `Add dependencies...` et
   Choisissez `Spring Web`.

2. Un fois le formulaire complètement rempli, cliquez sur `Generate` pour
   télécharger la base du projet, décompressez l'archive obtenue et importez
   le projet *Gradle* qu'il contient dans votre IDE.

3. Complétez ensuite la classe `DemoApplication` générée pour pouvoir tester
   la configuration de votre projet.

   ```java
   package fr.univartois.butinfo.r5a05.demo;

   import org.springframework.boot.SpringApplication;
   import org.springframework.boot.autoconfigure.SpringBootApplication;
   import org.springframework.web.bind.annotation.GetMapping;
   import org.springframework.web.bind.annotation.RequestParam;
   import org.springframework.web.bind.annotation.RestController;

   @RestController
   @SpringBootApplication
   public class DemoApplication {

       @GetMapping("/hello")
       public String hello(@RequestParam(value = "name", defaultValue = "World") String name) {
           return String.format("Hello %s!", name);
       }

       public static void main(String[] args) {
           SpringApplication.run(DemoApplication.class, args);
       }
   }
   ```

4. D'après vous, à quoi servent :

   - `GetMapping` ?
   - `RequestParam` ?
   - `value` ?
   - `defaultValue` ?

5. Pour démarrer votre application, exécutez la commande :

   ```
   ./gradlew bootRun
   ```

6. Consulter dans votre navigateur préféré la page web à l'adresse
   [http://localhost:8080/hello](http://localhost:8080/hello).
   Qu'affiche cette page ?
   Quel est son format (utilisez l'inspecteur de votre navigateur) ?
   Que va-til se passer si l'on ajoute `?name=Toto` à a fin de cette URL.

## Quelques applications de base avec *Spring*

Nous allons maintenant développer quelques applications relativement simples
avec *Spring* pour mieux comprendre son fonctionnement.
Pour chacune des questions suivantes, repartez du projet de base que vous
avez téléchargé dans la section précédente, et créez un nouveau projet dans
votre IDE à partir de celui-ci.
À chaque fois que vous avez terminé une question, lancez l'application et
ouvrez l'URL appropriée dans votre navigateur pour tester votre application.

7. Créez une application vous permettant de récupérer le résultat d'un lancer
   de dé.
   Pour utiliser votre application, il faudra passer par la route `/dice` et
   lui donner en paramètre une valeur `sides` indiquant le nombre de faces du
   dé à lancer.
   Vous devrez donc produire un nombre aléatoire entre $1$ et ce nombre de
   faces.

8. Proposez une application permettant de jouer au jeu du *Juste Prix*.
   Pour cela, vous devrez dans un premier temps choisir une valeur aléatoire
   dans votre application, et répondre aux propositions de l'utilisateur faites
   au travers de la route `/guess`, dont le paramètre `value` permet de
   préciser la valeur proposée par l'utilisateur.
   Vous devrez ensuite retourner à l'utilisateur des informations concernant
   sa proposition : la valeur est-elle la bonne ?
   Est-elle trop élevée ?
   Est-elle trop basse ?

9. Proposez une application où l'utilisateur doit deviner un mot.
   Vous initialiserez votre application avec une liste de mots (fixée à
   l'avance), et vous en choisirez un parmi ceux de cette liste.
   L'utilisateur pourra d'une part proposer des lettres via la route `/letter`
   et un paramètre `l`, et d'autre part proposer des mots via la route `/word`
   et un paramètre `w`.
   Dans les deux cas, vous devrez indiquez à l'utilisateur si sa proposition
   est correcte, à savoir si la lettre appartient au mot à deviner, ou si le
   mot est celui à deviner.

## Un annuaire avec *Spring*

Nous allons maintenant développer une application permettant de consulter
un annuaire regroupant des informations sur différentes personnes.
Nous ne gérerons que la consultation dans cet exercice, et non la modification.

10. Créez un nouveau projet *Spring* de la même manière que vous l'avez fait
    précédemment.

11. Définissez une classe `Personne` permettant de stocker les informations
    relatives à une personne, à savoir :

    - son identifiant (un entier) ;
    - son prénom ;
    - son nom ;
    - sa date de naissance ;
    - son numéro de rue ;
    - sa rue ;
    - sa ville ;
    - son numéro de téléphone ; et
    - son adresse e-mail.

    Vous veillerez à définir les accesseurs appropriés, et à redéfinir la
    méthode `toString()` pour afficher toutes les informations relatives à cette
    personne.

12. Définissez une classe `Annuaire` permettant de stocker une liste de
    `Personne`.
    Définissez une méthode pour accéder à une personne par son identifiant
    (qui n'est pas nécessairement son indice dans la liste).
    Définissez une méthode `toString()` pour afficher tout l'annuaire.

13. Complétez la classe correspondant à votre application pour que celle-ci
    définisse en attribut un annuaire pré-rempli.

14. Ajoutez une route permettant d'afficher une personne donnée par son
    identifiant.
    Si aucun identifiant n'est donnée, toutes les personnes de l'annuaire
    doivent être affichées.

15. Complétez les classes appropriées afin de proposer des routes permettant
    de réaliser les tâches suivantes.
    Faites bien attention à ce qu'un minimum de traitement soit réalisés
    dans la classe de l'application : cette classe doit uniquement produire
    l'affichage.

    - Rechercher une personne donnée par son adresse e-mail.
    - Rechercher une personne donnée par son numéro de téléphone.
    - Rechercher toutes les personnes ayant un nom donné.
    - Rechercher toutes les personnes ayant un prénom donné.
    - Rechercher toutes les personnes ayant un nom donné.
    - Rechercher toutes les personnes dans une ville donnée.

16. Dans cette application, quelles classes constituent le modèle ?
    La vue ?
    Le contrôleur ?
