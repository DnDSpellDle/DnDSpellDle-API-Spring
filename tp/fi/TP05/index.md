---
type: TP
number: 5
---

# Gestion intelligente d'objets connectés - Authentification (2)

Pour l'instant, n'importe qui ayant accès à votre serveur web peut consulter
et modifier le contenu de l'inventaire.
Cela n'est pas très sécurisé...

Dans ce sujet de TP, nous allons voir comment protéger des routes, afin de
limiter l'accès aux fonctionnalités de l'inventaire aux personnes autorisées.
Pour cela, nous allons utiliser une authentification fondée sur les *JSON
Web Tokens* (*JWT*), des jetons d'authentification échangés entre le serveur et
le client.
À l'issue de ce sujet, vous devriez donc être capables de :

- Authentifier un utilisateur à partir de son identifiant et de son mot de
  passe.
- Générer un jeton *JWT* permettant à l'utilisateur de rester authentifié.
- Protéger des routes pour limiter l'accès aux utilisateurs authentifiés.

> **Remarque**
>
> Ce sujet de TP se base sur l'implémentation proposée
> [ici](https://github.com/ali-bouali/spring-boot-3-jwt-security).

## Ajout des dépendances

Dans un premier temps, vous devez compléter les dépendances de votre projet afin
de pouvoir utiliser *Spring Security*.

1. Complétez votre fichier `build.gradle.kts` pour ajouter les dépendances
   suivantes :

   ```kotlin
   dependencies {
       implementation("org.springframework.boot:spring-boot-starter-actuator")
       implementation("org.springframework.boot:spring-boot-starter-security")
       implementation("io.jsonwebtoken:jjwt-api:0.12.3")
       implementation("io.jsonwebtoken:jjwt-impl:0.12.3")
       implementation("io.jsonwebtoken:jjwt-jackson:0.12.3")
   }
   ```

2. Mettez à jour votre projet pour tenir compte des dépendances ajoutées.

3. Essayez de relancer votre application.
   Que se passe-t-il lorsque vous essayez de faire une requête ?

## Gestion des utilisateurs

Afin de mettre en place *Spring Security*, il faut commencer par définir des
classes permettant de manipuler les utilisateurs authentifiés de l'application.

### Définition d'un *UserDetails*

Pour pouvoir connecter un utilisateur, vous devez définir une classe
implémentant l'interface `UserDetails`.
Cette classe doit contenir toutes les informations relatives à un utilisateur
de l'application.

4. Définissez une telle classe.
   Vous pouvez considérer qu'un utilisateur est un propriétaire d'objet, ou pas.
   Libre à vous de choisir.
   Il doit forcément choisir d'une classe représentant un document *MongoDB*.

5. Implémentez les méthodes requises par l'interface.
   Pour l'instant, laissez l'implémentation par défaut de la méthode
   `getAuthorities()`.
   Nous reviendrons dessus plus tard.

6. Définissez une énumération permettant de représenter les différents rôles
   possibles pour un utilisateur connecté, et une autre énumération permettant
   de représenter les permissions associées.
   Par exemple, un simple utilisateur pourra consulter les objets stockés dans
   l'inventaire, tandis qu'un administrateur pourra en plus ajouter, modifier
   et supprimer les éléments qui s'y trouvent.
   Vous devrez faire en sorte que chaque rôle « connaissent » ses permissions.

7. Définissez dans votre énumération représentant les rôles une méthode
   retournant une `List<GrantedAuthority>`, contenant des instances de
   `SimpleGrantedAuthority` initialisées avec le nom des permissions associées
   au rôle courant, ainsi que le nom de ce rôle (préfixé par `ROLE_`).

8. Ajoutez dans la classe représentant un utilisateur un attribut représentant
   son rôle, et complétez la méthode `getAuthorities()` en appelant la
   méthode définie à la question précédente.

### Définition d'un service pour les utilisateurs

Pour permettre à *Spring* de retrouver l'utilisateur au moment de
l'authentifier, vous avez besoin de lui fournir un `UserDetailsService`.

9. Complétez (ou écrivez) le service associé au document représentant un
   utilisateur afin qu'il implémente l'interface `UserDetailsService`.

10. Implémentez la méthode `loadUserByUsername()`, en utilisant la méthode
    appropriée du *repository*.
    Assurez-vous de bien jeter une `UsernameNotFoundException` dans le cas où
    l'utilisateur n'existe pas.

### Définition d'un contrôleur pour les utilisateurs

Afin de pouvoir gérer vos utilisateurs, vous devez fournir un contrôleur
permettant de fournir un certain nombre de fonctionnalités via l'API.

11. Définissez un tel contrôleur, avec les différentes routes permettant de
    gérer un utilisateur (par exemple, pour changer de mot de passe).
    Notez que vous pouvez ajouter un paramètre de type `Principal` à vos
    méthodes, afin d'accéder à l'utilisateur courant à l'aide de l'extrait de
    code suivant :

    ```java
    ((UsernamePasswordAuthenticationToken) principal).getPrincipal();
    ```

## Configuration de l'application

Afin de configurer l'application, vous allez devoir définir une classe dédiée
à cela, annotée avec `@Configuration`.
Cette classe doit définir différentes méthodes, permettant de fournir des
composants (*beans*) utilisés soit directement par *Spring*, soit par vos
autres classes.

12. Complétez votre fichier `application.properties` pour ajouter les
    configurations nécessaires à la gestion des tokens *JWT* (veillez à changer
    la `secret-key` pour qu'elle vous soit propre) :

    ```properties
    application.security.jwt.secret-key=1chainealphanumeriquealeatoirede64caracteresalabaseduchiffrement
    application.security.jwt.expiration=86400000
    application.security.jwt.refresh-token.expiration=604800000
    ```

13. Importez dans votre projet les classes fournies dans le dossier `src`.
    Elles se chargent de la génération des tokens *JWT* et de l'extraction
    des données qu'elles contiennent.
    Vous devriez normalement pouvoir les utiliser telles quelles, en ajoutant
    simplement le bon chemin pour l'authentification dans la constante
    `AUTH_PATH`.

14. Définissez une classe annotée avec `@Configuration` pour définir la
    configuration de votre application.

    a. Définissez dans cette classe une méthode annotée par `@Bean` et retournant
       un `PasswordEncoder`.
       Cette méthode permet de préciser comment les mots de passe doivent être
       chiffrés dans la base de données.
       Généralement, vous pouvez retourner un `BCryptPasswordEncoder` dans cette
       méthode.

    b. Définissez une autre méthode `@Bean` retournant un
       `AuthenticationProvider`.
       Comme nous allons identifier nos utilisateurs à partir de la base de
       données, vous devrez ici retourné un `DaoAuthenticationProvider`,
       sur lequel vous appelerez les *setters* appropriés pour lui associé le
       `PasswordEncoder` défini à la question précédente, et le
       `UserDetailsService` défini plus haut (vous pourrez l'injecter comme
       d'habitude).

    c. Définissez une méthode `@Bean` retournant une `SecurityFilterChain`.
       Cette méthode doit prendre en paramètre un objet `HttpSecurity`, noté
       `http` ci-après.
       À partir de cet objet, vous devez :

       - désactiver les CSRF : `http.csrf(AbstractHttpConfigurer::disable)`

       - configurer les sessions pour qu'elles ne conservent pas d'état :
         `http.sessionManagement(s -> s.sessionCreationPolicy(STATELESS))`

       - configurer l'`AuthenticationProvider` défini à la question précédente
         via la méthode `http.authenticationProvider(...)`

       - préciser les autorisations pour les différentes URL de votre
         application (notez que vous pouvez aussi préciser les méthodes
         HTTP concernées dans les `requestMatchers`):
         
       ```java
       http.authorizeHttpRequests(req ->
           req.requestMatchers("/pas/besoin/d/autorisation/ici").permitAll()
              .requestMatchers("/reserve/aux/admins").hasAnyRole(ADMIN.name())
              .anyRequest().authenticated()); // Il faut être authentifié pour tout le reste.
       ```
      
       - ajouter le filtre vérifiant les tokens *JWT* et importé ci-avant :
         `http.addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class)`
         (vous pouvez l'injecter comme d'habitude)
      
       À l'issue de la méthode, vous devez construire l'objet, en utilisant
       `http.build()`. 

## Protection des routes par rôles et permissions

La configuration précédente permet d'indiquer si vous avez ou non besoin d'être
authentifié pour accéder à une route.
Pour protéger une route en fonction d'un rôle ou d'une permission, vous devez
ajouter des annotations aux endroits appropriés.

XX. Ajoutez l'annotation `@PreAuthorize("hasRole('NOMROLE')")` sur les méthodes
    ou contrôleur pour lesquels vous pensez cela nécessaire.

XX. Ajoutez l'annotation `@PreAuthorize("hasAuthority('NOMPERMISSION')")` sur
    les méthodes ou contrôleur pour lesquels vous pensez cela nécessaire.
