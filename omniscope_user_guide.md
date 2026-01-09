# Omniscope User Guide

## Description

Le fichier omniscope présente plusieurs pipelines : 

- La pipeline de data preparation : 
    - Fusion du dataset GBD avec le mapping des pays
    - Dépivotage des données EDGAR
    - Fusion des données EDGAR et GBD
    - Agrégation des données par pays et par année

- La pipeline de modélisation :
    - Split des données en train et test
    - Modèle de régression
    - Concaténation des prédictions avec les données test

- La pipeline de prédiction :
    - Création d'un dataset de prédiction
    - Prédiction des maladies respiratoires avec un modèle de régression

## Utilisation

**ATTENTION** : si vous souhaitez exécuter les pipelines, vous devez avoir uploadé les datasets EDGAR, GBD et le mapping des pays dans omniscope.

Utilisez le bouton en haut à droite qui permet de tout exécuter, évitez d'exécuter les blocs un par un.
