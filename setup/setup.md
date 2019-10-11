# Git-Jenkins Lab Setup

## Prerequisites
* AKS cluster available
* kubectl cli installed
* helm cli installed
* Kube config file configured to call AKS cluster

## Setup Helm
> Follow [documentation from AKS](https://docs.microsoft.com/en-us/azure/aks/kubernetes-helm)
* Setup rbac
```bash
kubectl apply -f jenkins/helm-rbac.yaml
```
* Configure helm
```bash
helm init --history-max 200 --service-account tiller --node-selectors "beta.kubernetes.io/os=linux"
```

## Install Jenkins 

* Deploy Jenkins with helm chart help
```bash
helm install --name jenkins-lab stable/jenkins
```
* Wait for end of deployment and get admin password
```bash
printf $(kubectl get secret --namespace default jenkins-lab -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode);echo
```
* Connect to Jenkins instance and test a multibranch pipeline using kubernetes plugin.

## Setup Git repository

Prerequisites:
* Create a file named logins.list into setup folder with the following form
```
<username1>
<username2>
...
```
* Generate jenkins credentials for all logins
```bash
./setup/jenkins/generate-jenkins-user-groovy.sh
```

* Reinitialize repository
```bash
# In the root folder of the repository
rm -rf .git
git init
git add Readme.md identity.md pom.xml src setup
git commit -m "Reinit lab"
```
* Create dummy commits
```bash
./setup/git/setup-commit-password.sh
```

* Create branches
```bash
git checkout -b develop
git checkout -b bizarre

cat <<EOT >> questions.md
# Questions

## Question 1: Donnez moi votre définition du DevOps ?

## Question 2: Qu'est-ce que le continuous delivery ?

## Question 3: Donnez le nom d'un serveur d'intégration continue (nom de la solution) ?

## Question 4: Pourquoi tester automatiquement ?

## Question 5: Pouvez-vous me citer des méthodologies d'amélioration du niveau technique interne de l'équipe agile ?

## Question 6: Quel est le but d'une démo de fin de sprint ?

## Question 7: J'essaye d'accéder au site suivant : https://www.google.com/. Cependant, je n'arrive pas à y accéder depuis mon poste. Quelles sont les commandes que je peux lancer pour identifier ce qui m'empêche d'accéder à ce site ?

EOT

git add questions.md
git commit -m "Add some easy questions"
git checkout master 
git rm -r setup
git commit -m "Remove setup files"
git remote add origin URL
git push -u origin --all --force
```




