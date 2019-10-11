# TP 1 : CI/CD

## Instructions
Les réponses aux questions posées dans cet énoncé doivent être soumises sous forme d'issue GitHub au sein de votre copie de repository. 
Chaque réponse fera l'objet d'une nouvelle issue dans votre repo. 
> Les questions requérant une réponse sous forme d'issue seront taggées par l'icone suivante: ⚠️ 

Le TP doit être rendu individuellement et se basera sur les réponses présentes dans les issues, ainsi que sur le code présent dans vos repositories personnels.

## Rappels
### Git
* Repository
* Clone
* Add
* Commit
* Push
* Pull 
* Branch
* Merge
* Fork
* Pull request
* [Git Documentation](https://git-scm.com/docs)

### Gitflow
![Gitflow diagram](https://stxnext.com/media/filer_public_thumbnails/filer_public/d4/41/d4414c91-483b-4904-9c1b-fc92c899678c/gitflow.png__1011x520_q85_crop_subsampling-2_upscale.png "Gitflow diagram")

### Github
* Classroom
* Issue

### Jenkins
* CI/CD
* Pipeline: Configuration as code

## 1 : Git 

### 1.0 : Création de compte Github
Allez sur [Github](https://github.com/) et se créer un compte si ce n'est pas déjà la cas.

### 1.1 : Forker le repo du lab
Suivre le lien présent au tableau ou dans le slack pour forker ce repository dans votre repository personnel GitHub Classroom.

### 1.2 : Cloner le repository
Clonez le repo nouvellement copié sur votre ordinateur 
> A partir de maintenant, **vous ne travaillerez plus que dans votre copie**. Vous n'avez plus à revenir sur [le projet parent](https://github.com/cours-ece/lab-git-jenkins).
 
### 1.3 : Faire un commit 
Dans votre repo, éditez le fichier identity.md et remplissez le avec vos données personnelles (nom, prénom, id)

Committez et pushez les changements apportés au fichier
> Les commits ne sont pas facultatifs. **Commitez au minimum dès que l'énoncé vous le demande**.

> ⚠️  **WARNING**: Créez une issue s'intitulant `1.3` ayant pour contenu les commandes que vous avez effectué pour réaliser le commit et le push de vos changements.

### 1.4 : Naviguer dans les logs
Affichez les logs des commits précédents.

Faites attention au fait que tout est loggué depuis le début du projet. Vous pouvez trouver les messages, les dates mais aussi les auteurs des commits passés.

> ⚠️  **WARNING**: Créez une issue s'intitulant `1.4` ayant pour contenu la commande que vous avez effectué pour visualiser les logs.

### 1.5 : Ils nous l'ont volé, Mon Précieux !
A l'aide de la commande utilisée dans la question précédente, retrouvez votre mot de passe **personnel**.

> **Indice**: Votre mot de passe n'est pas le seul à avoir été perdu. Vérifiez bien que c'est le votre !

> ⚠️  **WARNING**: Créez une issue s'intitulant `1.5` ayant pour contenu **uniquement la commande** que vous avez effectué pour retrouver votre mot de passe perdu.

> Gardez bien votre mot de passe avec vous. On ne sait jamais, on pourrait vous le demander à tout moment...

### 1.6 : Listez les branches
Listez **toutes** les branches présentes dans le repository.

Est-ce que toutes les branches vous paraissents normales ? Y a t-il une branche qui retient votre attention ? 
Si oui, déplacez vous dessus (checkout).

> ⚠️  **WARNING**: Créez une issue s'intitulant `1.6` ayant pour contenu la commande que vous avez effectué pour afficher les branches présentes dans votre repo et le nom de la branche qui a retenu votre attention.

### 1.7 : Créez une branche
Créez une branche à partir de la branche trouvée dans la question précédente. La branche à créer doit s'appeler `feature/` suivi de la première lettre de votre prénom puis du nom de famille en minuscule (pas d'espace ni d'accent dans le nom).

> Ex Arthur Sappé Comjaja --> feature/asappecomjaja

Puis, placez vous sur votre branche `feature/{nom}` nouvellement créée.

> ⚠️  **WARNING**: Créez une issue s'intitulant `1.7` ayant pour contenu les commandes que vous avez effectué pour créer et vous déplacez sur la nouvelle branche.

### 1.8 : Ah, c'est la que tu aurais aimé suivre le dernier cours ...
Répondez aux questions contenues dans le fichier questions.md, puis committez les changements sur la branche `feature/{nom}`.
Enfin, pushez tous vos changements présents réalisés sur toutes les branches sur votre repository GitHub.

> ⚠️  **WARNING**: Créez une issue s'intitulant `1.8` ayant pour contenu les commande que vous avez effectué pour pusher toutes les branches sur votre repo GitHub.

### 1.9 : Pull request time !!
Dans l'interface web GitHub, ouvrez une pull request partant de votre branche `feature/{nom}` pointant sur la branche develop de votre repository.

> **Warning**: Pensez bien à m'ajouter en tant que reviewer de votre pull request afin que je puisse vous corriger.

Pour plus d'aide sur les pull requests voir la [documentation officielle](https://help.github.com/articles/about-pull-requests/)

### 1.10 : Gitflow
Lister les branches présentes dans le repo. Au sens Gitflow, à quoi servent ces chacunes de ces branches ?

> ⚠️  **WARNING**: Créez une issue s'intitulant `1.10` ayant pour contenu la description des branches existantes dans la méthodologie Gitflow qui sont présentes dans votre repository. (ex: la branche master sert à ...)

## 2 : CI/CD
Dans cette seconde partie, vous devez utiliser le même repo que celui obtenu à la fin de la partie 1.

> ⚠️  **WARNING**: Chacunes des questions demandant une modification de code nécessite au minimum un commit et un push dans votre repository. 

### 2.1 : Création du Jenkinsfile
Créez un fichier de pipeline as code appelé **Jenkinsfile** à la racine de votre projet.
Collez y le code suivant:
```groovy
// Configuration des images docker utilisées pour les différentes étapes CI/CD
pipeline {
  agent {
    kubernetes {
      label 'mypod'
      defaultContainer 'jnlp'
      yaml """
        apiVersion: v1
        kind: Pod
        metadata:
          labels:
            some-label: some-label-value
        spec:
          containers:
          - name: maven
            image: maven:alpine
            command:
            - cat
            tty: true
          - name: docker
            image: docker
            command:
            - cat
            tty: true
            volumeMounts:
            - name: dockersock
              mountPath: /var/run/docker.sock
          volumes:
          - name: dockersock
            hostPath:
              path: /var/run/docker.sock
        """
    }
  }

// Configuration à modifier
  stages {
    stage('Build') {
      steps {
        container('maven') {
          sh 'mvn -B -DskipTests clean package'
        }
      }
    }
  }
}
```

Le code ci-dessus permet à Jenkins d'exécuter les étapes définies dans entre les balises **stages** à chaque activation d'un trigger (cela peut être un commit, un cron, une pull request...)

### 2.2 : Connexion à Jenkins
Se connecter à Jenkins disponible à l'adresse suivante : http://40.87.155.176:8080

Les identifiants respectent les règles suivantes:
* login : première lettre du prénom + nom de famille en minuscule (pas d'espaces ni d'accent dans les noms)
* password : `Ne serait-ce pas votre précieux que vous avez retrouvé plus tôt ?`

### 2.3 : Point sur les outils
Jenkins permet la définition des tâches à effectuer à travers l'intermédiaire de fichiers descripteur de pipelines d'exécution appelés Jenkinsfile.

Pour avoir un aperçu du fonctionement des Pipelines Jenkins, [voir l'introduction](https://jenkins.io/doc/book/pipeline/).
Pour plus de documentation sur la syntaxe des Jenkinsfile, voir [la documentation officielle](https://jenkins.io/doc/book/pipeline/syntax/).

> **Important**: La documentation ci-dessus sera indispensable pour pouvoir mener à bien le tp.

### 2.4 : Création d'un Multibranch Pipeline
Jenkins propose un type d'objet appelé `Multibranch Pipeline`. Cet objet permet à Jenkins de **scanner les différentes branches** d'un repository, d'y **détecter les changements** et d'**exécuter des actions** différentes en fonction des branches scannées.

De cette façon, il est possible de décorréler les actions à réaliser en intégration d'autres actions à réaliser lors d'un cycle de release vers la production.

Afin d'illustrer le point ci-dessus, sur la [page d'accueil de Jenkins](http://40.87.155.176:8080), cliquez sur **New Item**.

Dans la fenêtre suivante, entrez un nom pour le pipeline (en l'occurence, entrez votre login en tant que nom - première lettre du prénom+nom de famille en minuscule) et choisissez le type **Multibranch Pipeline**.

Dans la fenêtre de configuration du Pipeline, dans la section **Branch Sources**, cliquez sur **Add source >> Git** et entrez l'url (https) de votre repository git.

> Utilisez l'URL https de votre repository pour plus de simplicité

Dans la section **Scan Multibranch Pipeline Triggers**, cochez **Periodically if not otherwise run** et sélectionner un interval de **1 minute**, puis cliquer sur **Save** en bas de page.

Le pipeline devrait se lancer au bout de quelques minutes et compiler l'application puis afficher un build success.

> Votre Multibranch pipeline est maintenant configuré pour scanner les changements qui pourraient arriver dans votre repository git toutes les minutes.

### 2.5 : Ajout des tests
Pour l'instant, le build ne fait que compiler le code Java présent dans les sources. Ajouter un stage de test après le build.

**Help**: La commande à ajouter au Jenkinsfile est la suivante:
```bash
mvn test
```

Pour ajouter des étapes de build à Jenkins, il suffit d'éditer votre Jenkinsfile, de le commiter, puis de le pusher. Jenkins va scanner automatiquement les changements apportés au code source toutes les minutes et exécuter son pipeline en conséquence.

### 2.6 : Création de l'image Docker
Jusqu'ici le pipeline build et test l'applicatif mais aucun package n'est ŕealisé ou persisté. Vous allez créer une image Docker afin de persister notre applicatif à la fin du build.

Pour cela, créer un fichier Dockerfile à la racine de votre projet contenant le code suivant:
```dockerfile
FROM maven:3.3.9-jdk-8-alpine

COPY target/my-app-1.0-SNAPSHOT.jar /root/my-app-1.0-SNAPSHOT.jar

CMD ["java", "-jar", "/root/my-app-1.0-SNAPSHOT.jar"]
```

Ajouter un stage de création de l'image Docker au Jenkinsfile

**Warning**: Le container à utiliser pour lancer l'étape de build de l'image Docker n'est pas un container maven comme dans les étapes précédentes. Chercher dans le Jenkinsfile peut vous donner des idées :)

**Help**: La commande à lancer dans Jenkins est la suivante:
```bash
docker build -t my-app:$BUILD_NUMBER .
```

> $BUILD_NUMBER est une variable auto incrémentée par Jenkins à chaque build. Elle permet de s'assurer de l'unicité des livrables en cas de rejeux des builds.


### 2.7 : Lancement du container Docker
Après avoir créé l'image Docker, Jenkins peut lancer un container à partir de cette image pour valider le livrable.

Ajoutez un stage de run du container Docker capable de lancer l'image précédemment créée.

**Help**: La commande à lancer dans Jenkins est la suivante:
```bash
docker run my-app:$BUILD_NUMBER
```

### 2.8 : Affichage des résultats des tests
Ajoutez le code suivant après la fermeture de la balise stages dans le jenkinsfile pour activer l'affichage des résultats de tests par rapport aux exécutions précédentes.

```groovy
stages {
	...
  }

  post {
    always {
      junit 'target/surefire-reports/*.xml'
    }
  }
```

Après l'ajout de cette balise post, à la fin de la prochaine exécution du pipeline, un graphe apparaitra en haut à droite de l'écran de visualisation des pipelines (ou sous la forme d'un lien `Latest Test Result`). Ce graphe permettant de visualiser facilement l'évolution du passage des tests au fur et à mesure des builds.

### 2.9 : Création d'une nouvelle branche
Le Jenkinsfile est maintenant prêt à exécuter les stages définis en son sein quelles que soient les branches qui soient créées. 

Créez une branche `feature/test-build` à partir de la branch develop et constatez que le build est automatiquement appliqué sur cette branche.

### 2.10 : Limitation par type de branche
Bien que Jenkins soit capable d'appliquer le même pipeline quelles que soient les branches, il est possible d'affiner les actions qu'on souhaite réaliser en fonction des branches.

Ainsi, une branche représentant la production n'aura pas les mêmes actions CI/CD qu'une branche représentant une nouvelle feature demandant d'avoir des retours rapides et réguliers.

Pour réaliser cet affinage, il faut ajouter des conditions aux différents stages:
```groovy
// Pour s'exécuter uniquement sur la branche master
stage('Stage name') {
      when {
        branch 'master';
      }
      steps {
        ...
      }
    }

// Pour s'exécuter sur les branches master et develop
stage('Stage name') {
      when {
        anyOf {
          branch 'master';
          branch 'develop'
        }
      }
      steps {
        ...
      }
    }
```

Modifier votre Jenkinsfile pour builder l'image Docker uniquement sur les branches master et develop, et pour lancer les container Docker uniquement sur la branche master.

### 2.11 : Conclusion
Vous pouvez maintenant créer plusieurs branches features et vous apercevoir que ces branches ne se verront appliquées que les étapes de build et test.

Toute cette configuration permet d'avoir un système de validation au plus près sans perdre de temps sur les feedback rapides attendus notamment dans le dev.
This is simple
