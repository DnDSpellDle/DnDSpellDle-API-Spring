---
type: TP
number: 2
---

# Initiation au *framework* *Spring* et premières applications

*Jakarta EE* (anciennement *Java EE* ou *J2EE* pour *Java 2 Platform, Enterprise
Edition*) définit une spécification permettant de développer des applications
web en *Java*.
Le développement d'applications *Jakarta EE* étant relativement complexe,
différents *frameworks* ont été développés pour simplifier leur création.
Parmi ces *frameworks*, l'un des plus populaires est *Spring*, que nous allons
découvrir dans ce TP, à l'issue duquel vous devriez être capable de :

- Créer un projet *Spring* en utilisant *Spring Initializr*.
- Adapter le projet *Spring* de base aux besoins de votre application.
- Définir des routes pour répondre à des requêtes utilisant différentes méthodes
  HTTP.
- Passer des paramètres *via* l'URL de la requête.

## Création d'un projet avec *Spring Initializr*

Afin de faciliter la création de projets *Spring*, les concepteurs de ce
*frameworks* proposent une [application web](https://start.spring.io) qui
vous permet de créer tous les fichiers de base dont vous avez besoin pour
démarrer votre projet.

1. Complétez le formulaire disponible sur [cette page](https://start.spring.io)
   afin de configurer le projet de la manière suivante :

   - *Project* : `Gradle - Kotlin`
   - *Language* : `Java`
   - *Spring Boot* : `3.1.4`
   - *Metadata* :
     - *Group* : `fr.univartois.butinfo.r5a05`
     - *Artifact* : `demo`
     - *Name* : `demo`
     - *Description* : `My first Spring application!`
     - *Package name *: `fr.univartois.butinfo.r5a05.demo`
     - *Packaging* : `Jar`
     - *Java* : `17`

   Ajoutez également une dépendance en cliquant sur `Add dependencies...`, et
   choisissez `Spring Web` pour avoir accès à la bibliothèque de *Spring*
   vous permettant de développer des applications web.

2. Un fois le formulaire complètement rempli, cliquez sur `Generate` pour
   télécharger l'archive de base de votre projet, décompressez-la et importez
   le projet *Gradle* qu'elle contient dans votre IDE.

3. Complétez ensuite la classe `DemoApplication` générée pour pouvoir tester
   la configuration de votre projet.
   Celle-ci doit ressembler au code ci-dessous.

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

   - L'annotation `RestController` ?
   - L'annotation `SpringBootApplication` ?
   - L'annotation `GetMapping` ?
   - L'annotation `RequestParam` ?
   - Le paramètre `value` ?
   - Le paramètre `defaultValue` ?

5. Pour démarrer votre application, exécutez la commande :

   ```
   ./gradlew bootRun
   ```

6. Consultez dans votre navigateur préféré la page web à l'adresse
   [http://localhost:8080/hello](http://localhost:8080/hello).
   Qu'affiche cette page ?
   Quel est son format (vous pouvez utiliser l'inspecteur de votre navigateur
   pour regarder le contenu de la page) ?
   Que va-til se passer si l'on ajoute `?name=Toto` à la fin de cette URL ?

## Quelques applications de base avec *Spring*

Nous allons maintenant développer quelques applications relativement simples
avec *Spring*, afin de mieux comprendre son fonctionnement.
Pour chacune des questions suivantes, générez un nouveau projet avec *Spring
Initializr* de la même manière que dans la section précédente, en vous assurant
de le nommer de manière appropriée, et importez-le dans votre IDE.
À chaque fois que vous avez terminé une question, lancez l'application et
ouvrez l'URL appropriée dans votre navigateur pour tester votre implémentation.

7. Créez une application vous permettant de récupérer le résultat d'un lancer
   de dé.
   Pour utiliser votre application, il faudra passer par la route `/dice` et
   lui donner en paramètre une valeur `sides` indiquant le nombre de faces du
   dé à lancer.
   Vous devrez donc produire un nombre aléatoire entre $1$ et ce nombre de
   faces.
   Comment faire pour récupérer la valeur donnée sous la forme d'un `int` ?

8. Proposez une application permettant de jouer au jeu du *Juste Prix* en
   suivant les instructions suivantes.

   a. Choisissez une valeur aléatoire dans votre application, que vous
      stockerez dans un attribut.

   b. Répondez aux propositions de l'utilisateur faites au travers de la route
      `/guess`, dont le paramètre `value` permet de préciser la valeur proposée
      par l'utilisateur.
      Votre réponse donnera à l'utilisateur des informations concernant sa
      proposition : la valeur est-elle la bonne ?
      Est-elle trop élevée ?
      Est-elle trop basse ?

   c. Lorsque vous avez trouvé la valeur à deviner, ouvrez un onglet de
      navigation privée dans votre navigateur, **sans relancer votre
      application**.
      Essayez à nouveau de deviner la valeur.
      Que constatez-vous ?
      Que pouvez-vous en conclure ?

   d. Proposez maintenant une route `reset` permettant de réinitialiser la
      valeur à deviner.
      Quelle méthode HTTP devez-vous utiliser pour cela ?
      Comment faire pour indiquer que vous souhaitez utiliser cette méthode ?

9. Proposez une application où l'utilisateur doit deviner un mot en suivant les
   instructions suivantes.

   a. Initialisez votre application avec une liste de mots (fixée à l'avance),
      et choisissez-en un aléatoirement parmi ceux de cette liste.

   b. Répondez aux propositions de l'utilisateur faites au travers de la route
      `/letter`, dont le paramètre `l` permet de préciser la lettre proposée
      par l'utilisateur.
      Votre réponse indiquera à l'utilisateur si la lettre proposée apparaît
      dans le mot à deviner.

   c. Répondez aux propositions de l'utilisateur faites au travers de la route
      `/word`, dont le paramètre `w` permet de préciser le mot proposé par
      l'utilisateur.
      Votre réponse indiquera à l'utilisateur si le mot proposé est le bon.

   d. Proposez maintenant une route `reset` permettant de réinitialiser le mot
      à deviner.
      Quelle méthode HTTP devez-vous utiliser pour cela ?
      Comment faire pour indiquer que vous souhaitez utiliser cette méthode ?

   d. Proposez enfin une route `add` permettant d'ajouter un mot à la liste
      des mots connus de votre application.
      Quelle méthode HTTP devez-vous utiliser pour cela ?
      Comment faire pour indiquer que vous souhaitez utiliser cette méthode ?
