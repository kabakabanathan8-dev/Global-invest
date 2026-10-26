# GLOBAL INVEST AFRICA — Prototype V1

Prototype web en français pour démontrer un concept de commerce et de participation au financement de stocks. Interface bleu marine, blanc et or.

## Important — démonstration uniquement

- Aucun argent réel n'est accepté.
- Aucun dépôt, retrait, portefeuille financier ou paiement n'est actif.
- Les budgets, recettes, frais et résultats affichés sont fictifs.
- Le taux de 30 % n'est pas un rendement garanti et ne doit pas être présenté comme une promesse.
- Le mode local stocke des données dans le navigateur et ne convient pas à des comptes réels.
- Le menu Administration est une interface de démonstration, pas un système d'administration sécurisé.

## Fichiers

- `index.html` : structure des pages et formulaires.
- `style.css` : interface responsive pour téléphone et ordinateur.
- `app.js` : navigation, catalogue, simulateur, journal, export CSV et comptes de test locaux.
- `supabase-schema.sql` : tables de test et politiques de sécurité de base pour un backend Supabase.
- `vercel.json` : configuration de déploiement statique.

## Tester localement

Ouvrir `index.html` dans un navigateur. Pour un comportement plus fiable, servir le dossier avec un serveur web statique ou déployer sur Vercel.

## Publier avec GitHub et Vercel depuis Android

1. Crée un dépôt GitHub, par exemple `global-invest-africa`.
2. Téléverse les fichiers du projet à la racine du dépôt.
3. Dans Vercel, importe le dépôt GitHub.
4. Pour cette version statique, laisse le framework sur `Other` ou `Other/Static` selon les choix disponibles, sans commande de build et sans dossier de sortie spécifique.
5. Déploie. Vérifie que le site s'ouvre sur téléphone.

## Activer une authentification backend de test avec Supabase

1. Crée un projet Supabase dans une région appropriée et disponible.
2. Dans SQL Editor, exécute `supabase-schema.sql`.
3. Dans `app.js`, renseigne `SUPABASE_URL` et la clé publique `SUPABASE_ANON_KEY` (ou publishable key selon le format fourni).
4. Ne place jamais de clé `service_role` dans le navigateur ou dans GitHub.
5. Dans Supabase Auth, configure les URL autorisées pour le domaine Vercel et l'URL locale de test.
6. Teste l'inscription et la connexion. Les autres données d'interface restent des données de démonstration locales dans cette V1.

**Attention :** le schéma SQL fournit une base de départ et non une certification de sécurité. Les opérations sensibles, le registre comptable, les droits administrateur, les vérifications d'identité et toute gestion de fonds exigent un backend sécurisé, une revue indépendante et une validation juridique avant un éventuel lancement réel.

## À faire avant une version de production

- Séparer strictement les rôles membre, gestionnaire et administrateur côté serveur.
- Créer des fonctions backend validant chaque changement et journalisant les événements.
- Ajouter tests unitaires, sauvegardes, surveillance et politique de confidentialité.
- Faire vérifier les obligations légales dans chaque pays cible, y compris celles liées aux placements, au financement participatif, à la monnaie électronique et à la protection des consommateurs.
- Ne pas intégrer les paiements réels avant autorisations, contrats et contrôles appropriés.
