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
- Passer des paramètres *via* l'URL de la requête, ou dans le corps de celle-ci
  en utilisant le format JSON.

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

## Un annuaire avec *Spring*

Nous allons maintenant développer une application permettant de gérer un
annuaire regroupant des informations sur différentes personnes.

### Application de base

Pour commencer, nous allons développer une application sur le même principe
que celles produites dans la section précédente.
En particulier, les paramètres seront passés via l'URL de la requête (donc
en tant que `RequestParam`).

10. Créez un nouveau projet *Spring* de la même manière que vous l'avez fait
    précédemment, en veillant à le nommer correctement.

11. Définissez une classe `Personne` permettant de stocker les informations
    relatives à une personne de l'annuaire, à savoir :

    - son identifiant (un entier) ;
    - son prénom ;
    - son nom ;
    - sa date de naissance ;
    - son numéro de rue ;
    - sa rue ;
    - sa ville ;
    - son numéro de téléphone ; et
    - son adresse e-mail.

    Vous veillerez à définir pour cette classe un constructeur, ainsi que les
    accesseurs appropriés.
    Redéfinissez également la méthode `toString()` pour afficher toutes
    les informations relatives à cette personne.

12. Définissez maintenant une classe `Annuaire` permettant de stocker une liste
    de `Personne`.
    Dans cette classe, définissez une méthode permettant d'ajouter une personne
    dans l'annuaire, ainsi qu'une méthode permettant d'accéder à une personne
    donnée par son identifiant (qui n'est pas nécessairement son indice dans la
    liste).
    Redéfinissez également la méthode `toString()` pour afficher tout
    l'annuaire.

13. Complétez la classe principale de votre application pour que celle-ci
    définisse en attribut un annuaire, que vous pré-remplirez avec plusieurs
    instances de la classe `Personne`.

14. Ajoutez une route permettant d'afficher une personne donnée par son
    identifiant.
    Si aucun identifiant n'est donné, toutes les personnes de l'annuaire
    doivent être affichées.

15. Complétez les classes appropriées afin de proposer des routes permettant
    de réaliser les tâches suivantes.
    Vous veillerez à ce que les méthodes HTTP utilisées correspondent à la
    tâche à réaliser.
    Faites également attention à ce qu'un minimum de traitement soit réalisé
    dans la classe de l'application : cette classe doit uniquement traiter les
    paramètres de la requête et produire un résultat (le cas échéant).

    - Ajouter une nouvelle personne dans l'annuaire.
    - Mettre à jour les informations d'une personne donnée par son identifiant.
    - Rechercher *une* personne donnée par son numéro de téléphone.
    - Rechercher *une* personne donnée par son adresse e-mail.
    - Rechercher *toutes* les personnes ayant un prénom donné.
    - Rechercher *toutes* les personnes ayant un nom donné.
    - Rechercher *toutes* les personnes habitant dans une ville donnée.
    - Supprimer une personne donnée par son identifiant.

16. Dans cette application, quelles classes constituent le modèle ?
    La vue ?
    Le contrôleur ?

### Des annotations pour utiliser du JSON

Envoyer les paramètres de la requête *via* son URL est loin d'être idéal.
Le plus souvent, on préfère utiliser le format JSON pour envoyer ces paramètres
dans le *corps* de la requête.
Pour cela, *Spring* fournit un système d'annotations permettant d'utiliser ce
format de manière transparente.

17. L'annotation `@RequestBody` fournie par *Spring* vous permet de récupérer
    des paramètres depuis le corps de la requête lorsque celui-ci est au format
    JSON, de la même manière que `@RequestParam` vous permettait de récupérer
    les paramètres depuis son URL.

    a. Modifiez votre méthode permettant de mettre à jour une personne en
       utilisant `@RequestBody`.
       Comme vous ne savez pas quels seront les éventuels paramètres de cette
       requête, utilisez une `Map<String, Object>` come paramètre de la méthode
       pour pouvoir les récupérer de manière « brute ».
       Assurez-vous ensuite que votre application fonctionne toujours comme
       prévu.
    
    b. Modifiez votre méthode permettant de créer une nouvelle personne.
       Cette fois, vous avez besoin de tous les attributs de la personne pour
       la créer : vous pouvez donc directement utiliser une `Personne` comme
       paramètre de la méthode.
       *Spring* fera automatiquement le *mapping* entre les clefs du JSON et
       les attributs de la classe `Personne`.
       Assurez-vous ensuite que votre application fonctionne toujours comme
       prévu.

18. L'annotation `@ResponseBody` permet de réaliser le processus inverse.
    Plutôt que d'envoyer vos réponses sous la forme de chaînes de caractères,
    vous pouvez directement renvoyer des objets *Java* au format JSON.
    Cette conversion est réalisée automatiquement par *Spring*.
    Modifiez vos différentes méthodes pour retourner des instances de `Personne`
    ou des listes de `Personne` plutôt que des chaînes de caractères, en
    utilisant cette annotation.
    Complétez également l'annotation `@*Mapping` en ajoutant le paramètre
    `produces = MediaType.APPLICATION_JSON_VALUE` pour indiquer que votre
    application produit du JSON (cela correspond au `Content-Type` envoyé dans
    l'en-tête de la réponse HTTP).
    Assurez-vous ensuite que votre application fonctionne toujours comme
    prévu.

### Pour aller plus loin

Nous allons maintenant voir comment améliorer notre application pour qu'elles
respectent les bonnes pratiques du protocole HTTP et des API REST.

19. Il est souvent possible d'avoir plusieurs applications qui tournent sur
    un même serveur : ce sont les routes qui permettent de les différencier.
    Pour donner un préfixe commun aux différentes routes de votre application,
    annotez la classe avec `@RequestMapping`, en lui donnant ce préfixe (par
    exemple, `/annuaire`).
    Assurez-vous ensuite que votre application fonctionne toujours comme
    prévu.

20. Lorsque vous renvoyez une réponse, vous devez normalement aussi retourner
    un code de retour HTTP.
    Par défaut, c'est le code `200 OK` qui est retourné, mais ce n'est pas
    toujours le plus adapté.
    Pour préciser le code de retour de vos différentes méthodes, annotez les
    avec `@ResponseStatus`.
    Par exemple, pour la méthode permettant de créer une personne, utilisez
    `@ResponseStatus(HttpStatus.CREATED)`.
    Assurez-vous ensuite que votre application fonctionne toujours comme
    prévu.

21. Les codes de retour précisés à la question précédente sont ceux
    correspondants aux cas où la requête s'est bien passée.
    Lorsque ce n'est pas le cas (par exemple, lorsqu'une personne n'est pas
    retrouvée), il faut jeter une exception `ResponseStatusException`, en lui
    donnant le code d'erreur approprié (par exemple, `HttpStatus.NOT_FOUND`).
    Assurez-vous ensuite que votre application fonctionne toujours comme
    prévu.
