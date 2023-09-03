---
type: TP
number: 1
---

# Rappels de Java et de programmation orientée objet

Le but de ce TP est de vous faire retrouver les principes de la programmation
orientée objet en *Java*, en programmant une application dont les dépendances
sont gérées par *Gradle*.
Pour cela, vous allez programmer une petite application simulant l'affichage
de feux tricolores sur un carrefour.
À la fin de ce TP, vous devriez être capable de :

- Créer un projet *Gradle* permettant de concevoir une application *Java*.
- Importer et utiliser des dépendances externes dans votre code *Java*.
- Tester votre application en utilisant *Gradle*.

## Installation et configuration de *Gradle*

*Gradle* est un moteur de production libre permettant de construire des projets
dans différents langages de programmation, et notamment en *Java*.
Nous allons l'utiliser pour pouvoir facilement récupérer les dépendances de
nos projets, les compiler et les exécuter.
Pour cela, si vous n'avez pas déjà *Gradle* d'installé sur votre machine, nous
allons dans un premier temps l'installer et le configurer.
Si vous disposez déjà de *Gradle*, vous pouvez directement passer à la section
suivante.

1. Récupérez et installez *Gradle* en suivant les instructions données sur
   [la page officielle de l'outil](https://gradle.org/install/#manually).

2. Assurez-vous que l'exécutable `gradle` est bien dans votre `PATH`, en
   essayant d'exécuter la commande suivante :

   ```bash
   gradle -version
   ```

3. Si vous êtes sur le réseau de l'université, vous devez également configurer
   le proxy pour permettre à *Gradle* d'accéder à internet.
   Pour cela, dans votre *home directory*, et ajoutez les lignes suivantes dans
   le fichier `.gradle/gradle.properties` (s'il n'existe pas, vous devez le
   créer) :

   ```
   systemProp.http.proxyHost=cache-iutl.univ-artois.fr
   systemProp.http.proxyPort=3128
   systemProp.https.proxyHost=cache-iutl.univ-artois.fr
   systemProp.https.proxyPort=3128
   ```

## Création d'un projet *Gradle*

Nous allons maintenant créer un projet *Gradle*.
Pour cela, le programme `gradle` fournit une tâche `init` permettant de créer
tous les fichiers nécessaires à votre projet.

4. Créez un répertoire `feux-tricolores` qui contiendra votre projet.
   Vous pouvez le placer où bon vous semble.

5. Ouvrez ce répertoire dans un terminal, et exécutez la commande `gradle init`.
   Plusieurs questions vous seront posées, répondez-y comme indiqué ci-dessous :

   - type de projet : `application` (`2`)
   - langage : `Java` (`3`)
   - projets multiples : `no`
   - langage des scripts : `Kotlin` (`1`)
   - *framework* pour les tests : `JUnit Jupiter` (`4`)
   - nom du projet : vous pouvez laisser la proposition par défaut
   - nom du paquetage : `fr.univartois.butinfo.r5a05.feuxtricolores`
   - version du langage *Java* : `17`
   - utilisation de la nouvelle API : `no`

6. Listez le contenu du répertoire à l'issue de l'exécution de la commande
   précédente.
   Quels fichiers ont été créés ?
   Pouvez-vous déterminer leurs rôles ?

7. Pour vous assurer que votre projet est correctement configuré, essayez
   d'exécuter votre application en faisant `gradle run`.

8. Importez le projet dans votre IDE.
   N'oubliez pas de configurer également le proxy pour ce dernier.

## Création du carrefour et de ses feux tricolores

Nous allons maintenant créer notre simulation de carrefour avec ses feux
tricolores.

9. À partir du texte ci-dessous, identifier les classes dont vous avez besoin
   pour représenter le carrefour.

> Un carrefour est composée de quatre routes, provenant chacune des quatre
> points cardinaux (Nord, Sud, Est et Ouest).
> Sur chacune de ses routes se trouve un feu tricolore, tel que le feu
> de la route Nord est synchronisé avec le feu de la route Sud, et le feu
> de la route Est est synchronisé avec le feu de la route Ouest.
> Bien sûr, il n'est pas possible que tous les feux soient verts au même moment.
>
> Un feu tricolore possède une couleur courante, qui peut initialement être
> verte ou rouge.
> Au bout d'un certain temps, la couleur du feu change, en suivant l'ordre
> suivant :
>
> 1. un feu reste au vert pendant 20 secondes, puis
> 2. il passe à l'orange pendant 5 secondes, avant de
> 3. passer au rouge pendant 25 secondes.
>
> Ces étapes se répètent indéfiniment.
>
> À chaque unité de temps, il est possible de vérifier si la couleur des feux
> du carrefour doit changer, et d'appliquer le changement en conséquence.
>
> Enfin, un carrefour peut passer en mode priorité, auquel cas les feux passent
> de manière permanente à l'orange, jusqu'à ce que le carrefour repasse en mode
> normal.

10. Implémentez les classes identifiées à la question précédente.
    Pour le moment, vous pouvez considérer qu'une méthode sera appelée
    chaque seconde sur le carrefour ou les feux pour simuler une unité de
    temps.
    Vous veillerez à proposer une implémentation de `toString()` dans les
    classes appropriées pour permettre d'afficher dans la console l'état courant
    du carrefour.

## Simulation du fonctionnement des feux

Nous allons maintenant écrire un programme principal pour permettre d'afficher
l'évolution du carrefour au cours de son exécution.

11. Pour simuler le temps qui passe, consultez la Javadoc de la classe
    [`java.util.Timer`](https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/util/Timer.html)
    et identifiez les méthodes utiles pour exécuter une tâche à intervalle
    régulier.

12. Complétez la méthode `main` de la classe `App` générée par *Gradle*
    pour que celle-ci crée une instance de votre classe `Carrefour`
    et appelle chaque seconde la méthode permettant de mettre à jour (ou pas)
    la couleur des feux.
    Vous pouvez affichez la chaîne de caractères `"\033[H\033[2J"` pour
    effacer l'écran avant d'afficher la nouvelle version du carrefour.

13. Essayez à nouveau d'exécuter votre application en utilisant `gradle run`.
    Est-ce que tout fonctionne comme prévu ?
    Si ce n'est pas le cas, corrigez les erreurs identifiées.

## Affichage coloré

Pour rendre l'affichage plus agréable, nous allons maintenant utiliser des
couleurs pour les feux tricolores.
Pour cela, nous allons utiliser la bibliothèque externe
[`chalk`](https://github.com/tomas-langer/chalk), qui permet d'afficher des
chaînes de caractères en utlisant des couleurs.

14. Consultez le fichier `build.gradle.kts` et la documentation de la
    bibliothèque pour identifier comment l'ajouter en dépendance.
    (indice : la chaîne de caractères à utiliser est de la forme
    `group:artifactId:version`).
    Mettez ensuite à jour votre projet pour tenir compte de ce changement.

15. Modifiez les classes appropriées pour utiliser l'affichage en couleurs.
    La couleur orange n'étant pas disponible dans la console, on utilisera à la
    place la couleur jaune.

16. Essayez d'exécuter à nouveau votre application.

## Pour aller plus loin : Écriture des tests

17. Lors de la création du projet avec `gradle init`, *Gradle* vous a créé
    des fichiers de test.
    Complétez-les afin de :

    - Vérifier que les couleurs sont ordonnées dans l'état attendu par un feu
      tricolore.
    - Vérifier que les durée attendues pour chaque couleur sont bien celles
      appliquées.
    - Vérifier que l'on ne peut créer que des feux rouges ou des feux verts.
    - Vérifier qu'à la création d'un carrefour, les feux sont rouge à l'est et
      à l'ouest et vert sinon (ou l'inverse suivant comment vous l'avez créé).
    - Vérifier qu'après 21 unités de temps, les feux verts sont passés à
      l'orange.
    - Vérifier qu'après 26 unités de temps, tous les feux verts sont rouges.
    - Vérifier qu'après 26 unités de temps, les feux sont rouge au nord et au
      sud et vert sinon (ou l'inverse suivant comment vous l'avez créé).
    - Vérifier sur 100 unités de temps que les feux ne passent jamais tous au
      vert.

18. Exécutez vos tests en utilisant la commande `gradle test`.
