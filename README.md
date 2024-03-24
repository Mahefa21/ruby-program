**Voici quelques guides pour exécuter en bash le programme et voir le résultat**

---

## Version de ruby et lien des outils

La version utilisée est 2.7.4.

1. Voici le lien d'installation sous Windows : https://www.ruby-lang.org/en/downloads/releases/ 
2. Vérification de la version de ruby installée : **ruby -v** 
3. Git : https://git-scm.com/ 
3. vsCode : https://code.visualstudio.com/

---

## Exécution

Voici les étapes pour exécuter la programment.

1. Créer un document dans votre ordinateur, ouvrir un terminal et exécuter ceci *git clone https://Charly_@bitbucket.org/top-test-tech/test-conge.git*.
2. Enter dans le document **test-congé**.
3. Ouvrir un nouveau terminal dans ce fichier et exécuter cette commande **ruby main.rb**.

---

## Modification des valeurs d'entrée

Voici les étapes pour modifier les entrées.

1. Ouvrir le fichier **test-congé** dans un éditeur de code.
2. Cliquer sur le dossier **main.rb**.
3. Changer les variable de l'instance de contract, exemple : **contract = Contract.new(Date.new(2023, 9, 11), Date.new(2025, 7, 25), 1000, PaymentMethod.new())**.
4. Ouvrir un nouveau terminal dans ce fichier ou dans l'éditeur et exécuter cette commande  **ruby main.rb**.

---

## Structure des dossiers et fichiers

Voici la représentation des dossiers:
```
--classes
  |________Contract.rb
  |________List.rb
  |________PaymentMethod.rb
  |________Period.rb
--utility
  |________Utility.rb
--main.rb
--README.md
```
---

