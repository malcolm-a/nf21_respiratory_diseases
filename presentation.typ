#import "@preview/typslides:1.3.0": *

// Project configuration
#show: typslides.with(
  ratio: "16-9",
  theme: rgb("#7578d1"),
  font: "Helvetica Neue",
  font-size: 21pt,
  link-style: "color",
  show-progress: true,
)

// The front slide is the first slide of your presentation
#front-slide(
  title: "Respiratory Risk Analytics",
  subtitle: [NF21 Project — Pollution Atmosphérique et Maladies Respiratoires],
  authors: "Yves APEAPEA-MIGUE\nMalcolm ARIDORY\nHélèna CHEVALIER\nYesmine FATHALLAH\nGwendal RODRIGUES",
  info: [UTT — ISI1 — #link("https://github.com/malcolm-a/nf21_respiratory_diseases")[GitHub]],
)

// Custom outline
#table-of-contents(title: "Table des matières")

// =====================================================================
// INTRODUCTION
// =====================================================================

#focus-slide[
  #text(
    size: 40pt,
    weight: "bold",
  )[Quelle est la relation entre la pollution atmosphérique et l'incidence des maladies respiratoires à l'échelle mondiale ?]
]

#slide(title: "Introduction")[
  #cols(columns: (1fr, 1fr), gutter: 2em)[
    *Contexte*
    - Pollution = déterminant majeur de santé
    - Effets variables selon *territoires*, *périodes*, *polluants*
    - Enjeu prioritaire pour les autorités sanitaires
  ][
    *Objectifs du projet*
    - #stress[Quantifier] la relation pollution ↔ maladies respiratoires
    - #stress[Identifier] les zones prioritaires d'intervention
    - #stress[Prédire] l'évolution des maladies
    - #stress[Recommander] des actions prioritaires
  ]

  #v(1em)
  #align(center)[
    #framed(back-color: rgb("#e8e8ff"))[
      *Méthodologie* : #stress[CRISP-DM] — Business Understanding → Data Understanding → Data Preparation → Modeling
    ]
  ]
]

// =====================================================================
// PARTIE 1 : BUSINESS UNDERSTANDING
// =====================================================================

#title-slide[
  Business Understanding
]

#slide(title: "Contexte général")[
  - *Domaine* : Santé publique & environnement
  - *Problème* : Lien qualité de l'air ↔ santé humaine
  - *Enjeu* : Orienter les politiques de prévention avec des données

  #v(0.5em)
  *Acteurs impliqués :*
  - Collectivités territoriales & Agences de santé publique
  - Ministères (santé, environnement) & Commission Européenne
  - #stress[Citoyens] — bénéficiaires directs des politiques de réduction
]

#slide(title: "Question métier")[
  #align(center)[
    #framed(back-color: rgb("#e8e8ff"))[
      *Question centrale* : _Quelle est la relation entre la pollution atmosphérique et l'incidence des maladies respiratoires à l'échelle mondiale ?_
    ]
  ]

  #v(1em)
  #table(
    columns: (1fr, 1fr, 1fr, 1fr),
    stroke: none,
    inset: 6pt,
    align: center,
    [*🔍 Diagnostiquer*], [*📈 Expliquer*], [*🎯 Prédire*], [*💡 Recommander*],
    [Zones à hautes \ émissions/maladies],
    [Liens temporels \ pollution ↔ santé],
    [Évolution selon \ pollution],
    [Actions de \ réduction],
  )
]

#slide(title: "Enjeux du projet")[
  #table(
    columns: (1fr, 1fr),
    stroke: none,
    inset: 10pt,
    [
      *🌍 Environnementaux*
      - Réglementations européennes
      - Protection de la biodiversité
      - Réduction des émissions
    ],
    [
      *💰 Économiques*
      - Réduction dépenses hospitalières
      - Moins d'arrêts de travail
      - Gains de productivité
    ],

    [
      *🏥 Sanitaires*
      - Asthme, BPCO, cancers pulmonaires
      - Facteur aggravant majeur
      - Populations vulnérables
    ],
    [
      *👥 Sociaux*
      - Qualité de vie
      - Équité territoriale
      - Accès à un air sain
    ],
  )
]

#slide(title: "Objectifs métier")[
  *1. Identification des zones prioritaires*
  - Utiliser le #stress[data mining] pour cibler les territoires à forte marge de réduction

  #v(0.5em)
  *2. Réduction de l'incidence*
  - Réduire l'incidence des maladies respiratoires de #stress[5%] dans les zones sensibles
  - Diminuer les émissions des polluants les plus dangereux de #stress[10%]

  #v(0.5em)
  *3. Identification des polluants critiques*
  - Identifier les polluants ayant le plus d'impact sur la santé respiratoire
]

#slide(title: "Jeux de données")[
  #table(
    columns: (1fr, 1fr),
    stroke: 0.5pt + gray,
    inset: 10pt,
    [
      *📊 EDGAR* — Commission Européenne

      Emissions Database for Global Atmospheric Research
      - ~6 000 lignes/polluant
      - Année, Pays, Secteur, Polluant, Quantité (Gg)
      - #stress[Émissions atmosphériques]
    ],
    [
      *🏥 GBD 2023* — IHME

      Global Burden of Disease
      - ~30 000 lignes
      - Année, Pays, Sexe, Incidence, Mortalité
      - #stress[Maladies respiratoires]
    ],
  )

  #v(0.5em)
  #align(center)[
    *Période* : 1980–2022 • *Couverture* : 197 pays
  ]
]

#slide(title: "Périmètre analytique")[
  #cols(columns: (1fr, 1fr), gutter: 2em)[
    *📍 Dans le périmètre*
    - *Géographie* : 197 pays
    - *Période* : 1980–2022 (43 ans)
    - *Polluants* : PM2.5, PM10, NOx, SO₂, CO, NH₃, NMVOC, BC, OC
    - *Maladies* : Asthme, BPCO, Cancer, Pneumoconioses
  ][
    *❌ Hors périmètre*
    - Analyses intra-urbaines
    - Déterminants sociaux individuels

    *👥 Parties prenantes*
    - Commanditaire : ARS
    - Équipe projet : Analystes données
    - Secondaires : Santé Publique France, ATMO
  ]
]

// =====================================================================
// PARTIE 2 : DATA UNDERSTANDING
// =====================================================================

#title-slide[
  Data Understanding
]

#slide(title: "Description des données")[
  #align(center)[
    #table(
      columns: (auto, auto, auto),
      stroke: 0.5pt + gray,
      inset: 8pt,
      [*Caractéristique*], [*EDGAR*], [*GBD 2023*],
      [Nombre de pays], [215], [204],
      [Période], [1970–2022], [1980–2023],
      [Variables], [9 polluants], [5 maladies],
      [Granularité], [Pays, année, secteur], [Pays, année, sexe],
      [Unité], [Kilotonnes (kt)], [Taux /100k hab.],
    )
  ]

  #v(0.5em)
  - *Polluants* : PM2.5, PM10, NOx, SO₂, CO, NH₃, NMVOC, BC, OC
  - *Maladies* : Cancer poumon, BPCO, Asthme, Pneumoconioses, Maladies interstitielles
]

#slide(title: "Qualité des données")[
  #cols(columns: (1fr, 1fr), gutter: 2em)[
    *✅ Points forts*
    - Complétude exceptionnelle : #stress[> 99.99%]
    - Valeurs manquantes < 0.01%
    - Sources fiables (CE, IHME)

    *🔗 Jointure*
    - Clé : Code ISO 3166-1 alpha-3
    - Période commune : 1980–2022
    - #stress[197 pays] correspondants
  ][
    #align(center)[
      #image("data_understanding_files/data_understanding_37_1.png", width: 100%)
    ]
  ]
]

#slide(title: "Distribution des émissions")[
  #cols(columns: (3fr, 1fr), gutter: 1.5em)[
    #align(center)[
      #image("data_understanding_files/data_understanding_41_1.png", width: 100%)
    ]
  ][
    *📊 Observations*
    - Forte asymétrie positive : quelques pays émettent beaucoup plus que la moyenne
  ]
]

#slide(title: "Comparaison Hommes / Femmes")[
  #cols(columns: (2fr, 1fr), gutter: 1.5em)[
    #align(center)[
      #image("data_understanding_files/data_understanding_43_0.png", width: 100%)
    ]
  ][
    *📊 Observations*
    - Hommes = taux plus élevés
    - #stress[Cancer poumon] : H/F ≈ 2-3x
    - BPCO : différence significative
    - Facteurs : tabac, exposition pro
  ]
]

#slide(title: "Évolution temporelle des émissions")[
  #align(center)[
    #image("data_understanding_files/data_understanding_45_0.png", width: 85%)
  ]

  📈 Pic en 1990 • 🔗 Polluants très corrélés • 🏭 CO = plus émis
]

#slide(title: "Évolution temporelle des décès")[
  #align(center)[
    #image("data_understanding_files/data_understanding_46_0.png", width: 85%)
  ]

  📉 BPCO : diminution globale • ➡️ Cancer : stabilité • ✅ Asthme mortel : baisse
]

#slide(title: "Top émetteurs")[
  #cols(columns: (3fr, 2fr), gutter: 1.5em)[
    #align(center)[
      #image("data_understanding_files/data_understanding_48_0.png", width: 100%)
    ]
  ][
    *🏆 Top 5 émetteurs*
    + #stress[Chine]
    + États-Unis
    + Inde
    + Russie
    + Brésil

    _Reflète activité industrielle et population_
  ]
]

#slide(title: "Cartographie des maladies")[
  #align(center)[
    #image("data_understanding_files/diseases_countries.png", width: 90%)
  ]

  *Cancer* : Europe Est, Amérique Nord • *BPCO* : Asie Sud-Est, Afrique
]

#slide(title: "Cartographie des polluants")[
  #align(center)[
    #image("data_understanding_files/pollutants_countries.png", width: 80%)
  ]
]

#slide(title: "Analyse sectorielle")[
  #cols(columns: (1fr, 1fr), gutter: 1.5em)[
    #align(center)[
      #image("data_understanding_files/data_understanding_51_0.png", width: 100%)
    ]
  ][
    *🏭 Secteurs dominants*
    + Transport routier
    + Industrie manufacturière
    + Production d'énergie
    + Agriculture

    *🔗 Associations*
    - Transport → NOx, CO
    - Agriculture → NH₃
    - Industrie → SO₂, PM
  ]
]

#slide(title: "Heatmap secteurs × polluants")[
  #align(center)[
    #image("data_understanding_files/data_understanding_52_1.png", width: 80%)
  ]
]

#slide(title: "Corrélation Polluants vs Maladies")[
  #cols(columns: (3fr, 2fr), gutter: 1.5em)[
    #align(center)[
      #image("data_understanding_files/data_understanding_58_0.png", width: 100%)
    ]
  ][
    *🔍 Observations clés*
    - #stress[PM2.5, PM10] : corrélations positives modérées
    - #stress[NH₃, OC] : plus fortes avec cancer
    - #stress[BPCO] : corrélée à la plupart des polluants
  ]
]

#slide(title: "Matrice de corrélation complète")[
  #align(center)[
    #image("data_understanding_files/data_understanding_59_0.png", width: 60%)
  ]

  #align(center)[
    *Multicolinéarité* : polluants très corrélés entre eux (r > 0.8) → attention modélisation!
  ]
]

#slide(title: "Synthèse Data Understanding")[
  #cols(columns: (1fr, 1fr), gutter: 2em)[
    *✅ Qualité des données*
    - Complétude > 99.99%
    - 197 pays, 43 ans
    - Outliers < 2%

    *📊 Conclusions*
    - Corrélations significatives
    - BPCO = maladie la plus corrélée
    - Tendance baisse des décès
  ][
    *⚠️ Points d'attention*
    - Forte multicolinéarité
    - Différences H/F significatives
    - Disparités géographiques

    *💡 Recommandations*
    - Transformation logarithmique
    - ACP pour multicolinéarité
  ]
]

// =====================================================================
// PARTIE 3 : DATA PREPARATION
// =====================================================================

#title-slide[
  Data Preparation
]

#slide(title: "Pipeline de préparation")[
  #align(center)[
    *EDGAR (Excel)* → Extraction Polars → Dépivotage années \
    ↓ \
    *GBD (CSV)* → Extraction Polars → Mapping pays FR→EN \
    ↓ \
    *Jointure* (ISO 3166 + Année) → *Agrégation* → *Dataset final*
  ]

  #v(1em)
  #text(size: 16pt)[
    #table(
      columns: (1fr, 1fr, 1fr),
      stroke: none,
      inset: 8pt,
      align: center,
      [*🔧 Outils* \ Polars, Pandas, Parquet],
      [*📏 Dataset final* \ 8 471 lignes × 17 cols],
      [*⚡ Pourquoi Polars?* \ Rust, 10-100x plus rapide],
    )
  ]
]

#slide(title: "Défi : Harmonisation des pays")[
  #cols(columns: (1fr, 1fr), gutter: 2em)[
    *❌ Problème*
    - GBD : noms en français mal traduit
    - Articles aléatoires ("La Chine", "France")
    - Apostrophes mal encodées
    - Pas de codes ISO dans GBD
  ][
    *✅ Solution*
    - Table de correspondance manuelle
    - Mapping FR → EN → ISO
    - Export dans `country_mapping.csv`
    - Jointure sur codes ISO 3166-1 alpha-3
  ]

  #v(0.5em)
  #align(center)[
    #framed(back-color: rgb("#e8ffe8"))[
      *Résultat* : 197 pays correctement mappés
    ]
  ]
]

#slide(title: "Préparation pour la modélisation")[
  #cols(columns: (1fr, 1fr), gutter: 2em)[
    *📥 Chargement & Transformations*
    - Format Parquet (compression)
    - *Log-transform* : $x' = log(1 + x)$
    - *StandardScaler* : $x' = (x - mu) / sigma$
  ][
    *✂️ Séparation & Variables*
    - Train : 80% / Test : 20%
    - *9 features* : CO, SO₂, NOx, PM...
    - *3 cibles* : Cancer, BPCO, Pneumo
    - (Asthme exclu : corrélation ≈ 0)
  ]
]

#slide(title: "Test du décalage temporel (Lag)")[
  _Hypothèse : délai biologique entre exposition et maladie_

  #v(0.5em)
  #align(center)[
    #table(
      columns: (auto, auto, auto, auto, auto),
      stroke: 0.5pt + gray,
      inset: 6pt,
      [*Maladie*], [*Lag 0*], [*Lag 3*], [*Lag 6*], [*Lag 9*],
      [Cancer], [0.857], [0.863], [0.872], [0.866],
      [Pneumo], [0.806], [0.787], [0.737], [0.793],
      [BPCO], [0.794], [0.781], [0.792], [0.812],
    )
  ]

  #align(center)[
    Pas de pattern consistant → #stress[Lag = 0] retenu
  ]
]

// =====================================================================
// PARTIE 4 : MODELIZATION
// =====================================================================

#title-slide[
  Modelization
]

#slide(title: "Approche de modélisation")[
  #cols(columns: (1fr, 1fr), gutter: 2em)[
    *🤖 Machine Learning classique*

    Bibliothèque : #stress[scikit-learn]

    Modèles testés :
    - Ridge (régression linéaire)
    - Random Forest
    - #stress[Gradient Boosting] ✓
  ][
    *🧠 Deep Learning*

    Bibliothèque : #stress[PyTorch]

    Architecture MLP :
    - 2 couches cachées (64 → 32)
    - Activation ReLU
    - Sortie linéaire
  ]
]

#slide(title: "Comparaison des algorithmes ML")[
  #align(center)[
    #table(
      columns: (auto, auto, auto),
      stroke: 0.5pt + gray,
      inset: 10pt,
      [*Modèle*], [*R²*], [*RMSE*],
      [Ridge], [0.156], [9188.9],
      [Random Forest], [0.737], [5128.3],
      [#stress[Gradient Boosting]], [#stress[0.772]], [#stress[4782.2]],
    )
  ]

  #v(1em)
  - *Ridge* : trop simple, sous-apprentissage
  - *Random Forest* : bon, robuste aux outliers
  - *Gradient Boosting* : #stress[meilleure performance], corrige les erreurs itérativement
]

#slide(title: "Architecture du réseau de neurones")[
  #cols(columns: (3fr, 2fr), gutter: 1.5em)[
    ```python
    class MLP(nn.Module):
        def __init__(self, n_features):
            super().__init__()
            self.layers = nn.Sequential(
                nn.Linear(n_features, 64),
                nn.ReLU(),
                nn.Linear(64, 32),
                nn.ReLU(),
                nn.Linear(32, 1)
            )

        def forward(self, x):
            return self.layers(x)
    ```
  ][
    *📐 Architecture*
    - Entrée : 9 features
    - Couche 1 : 64 + ReLU
    - Couche 2 : 32 + ReLU
    - Sortie : 1 (linéaire)

    *⚙️ Hyperparamètres*
    - Optimizer : Adam
    - Loss : MSE
    - LR : 0.001, Epochs : 500
  ]
]

#slide(title: "Fonctionnement des réseaux de neurones")[
  #cols(columns: (1fr, 1fr), gutter: 1.5em)[
    #align(center)[
      #image("img/ann.jpg", width: 100%)
    ]
  ][
    *🔄 Processus d'apprentissage*
    + Forward pass : données → prédiction
    + Calcul loss : erreur vs réel
    + Backpropagation : calcul gradients
    + Mise à jour : ajustement poids

    *⚠️ Enjeux*
    - Overfitting vs Underfitting
    - Équilibre learning rate/epochs
  ]
]

#slide(title: "Overfitting vs Underfitting")[
  #cols(columns: (3fr, 2fr), gutter: 1.5em)[
    #align(center)[
      #image("img/over_underfitting.png", width: 100%)
    ]
  ][
    *📉 Underfitting*
    - Modèle trop simple
    - Ne capture pas les patterns

    *📈 Overfitting*
    - Modèle trop complexe
    - Mémorise le bruit
  ]
]

#slide(title: "Résultats — Gradient Boosting")[
  #align(center)[
    #table(
      columns: (auto, auto, auto),
      stroke: 0.5pt + gray,
      inset: 8pt,
      [*Maladie*], [*R²*], [*Top polluants*],
      [Cancer], [#stress[0.923]], [SO₂, NH₃, NOx, OC, CO],
      [Pneumo], [0.805], [OC, NH₃, NMVOC, PM10, NOx],
      [BPCO], [#stress[0.901]], [NH₃, OC, NMVOC, SO₂, NOx],
    )
  ]

  #v(0.5em)
  #align(center)[
    ✅ *Excellentes performances* sur les données de test
  ]
]

#slide(title: "Résultats — Réseau de neurones (ANN)")[
  #cols(columns: (1fr, 1fr), gutter: 2em)[
    #align(center)[
      #table(
        columns: (auto, auto),
        stroke: 0.5pt + gray,
        inset: 10pt,
        [*Maladie*], [*R²*],
        [Cancer], [0.872],
        [Pneumo], [#stress[0.956]],
        [BPCO], [0.637],
      )
    ]
  ][
    *✅ Forces*
    - Excellente perf. Pneumoconiose
    - Meilleure généralisation

    *⚠️ Faiblesses*
    - Moins bon sur BPCO
    - Plus difficile à interpréter
  ]
]

#slide(title: "Comparaison GB vs ANN")[
  #align(center)[
    #text(size: 24pt)[
      #table(
        columns: (auto, auto, auto, auto),
        stroke: 0.5pt + gray,
        inset: 8pt,
        [*Critère*], [*GB*], [*ANN*], [*Meilleur*],
        [Cancer], [0.923], [0.872], [GB],
        [Pneumo], [0.805], [0.956], [ANN],
        [BPCO], [0.901], [0.637], [GB],
        [Interpolation], [Excellent], [Bon], [GB],
        [Extrapolation], [Limité], [Meilleur], [ANN],
        [Interprétabilité], [Bonne], [Faible], [GB],
      )
    ]
  ]
]

// =====================================================================
// PARTIE 5 : PRÉDICTIONS & SCENARII
// =====================================================================

#title-slide[
  Prédictions & Scenarii
]

#slide(title: "Définition des scenarii")[
  Simuler l'impact de réductions d'émissions sur la mortalité

  #v(0.5em)
  #align(center)[
    #table(
      columns: (auto, auto, auto),
      stroke: 0.5pt + gray,
      inset: 10pt,
      [*Scénario*], [*Réduction*], [*Émissions*],
      [Baseline], [0%], [100%],
      [Modéré], [-5%], [95%],
      [Ambitieux], [-10%], [90%],
      [Très ambitieux], [-20%], [80%],
    )
  ]

  #align(center)[
    _Année référence : 2022 • Projection : 10 ans_
  ]
]

#slide(title: "Prédictions — Gradient Boosting")[
  #align(center)[
    #image("img/predictions_gb.png", width: 90%)
  ]

  ⚠️ *Incohérences* : réduction 20% → augmentation mortalité cancer? Limites de l'#stress[extrapolation]
]

#slide(title: "Prédictions — Réseau de neurones")[
  #align(center)[
    #image("img/predictions_ann.png", width: 90%)
  ]

  ✅ *Résultats plus cohérents* : diminution mortalité avec réduction émissions
]

#slide(title: "Limites des prédictions")[
  #cols(columns: (1fr, 1fr), gutter: 2em)[
    *⚠️ Limites identifiées*
    - R² performant ≠ prédictions cohérentes hors distribution
    - GB : mauvais pour extrapolation
    - ANN : quelques anomalies mineures
  ][
    *🔍 Facteurs non inclus*
    - Politiques de santé
    - Évolution démographique
    - Progrès médicaux
    - Changement climatique
  ]

  #v(0.5em)
  #align(center)[
    Les prédictions indiquent des #stress[tendances], pas des prévisions précises
  ]
]

// =====================================================================
// PARTIE 6 : OMNISCOPE
// =====================================================================

#title-slide[
  Implémentation Omniscope
]

#slide(title: "Pipeline Omniscope")[
  #align(center)[
    #image("img/omni_data_prep.png", width: 80%)
  ]

  #align(center)[
    Réplication de la pipeline Python avec les blocs natifs
  ]
]

#slide(title: "Modèle de régression Omniscope")[
  #cols(columns: (2fr, 1fr), gutter: 1.5em)[
    #align(center)[
      #image("img/omni_model_details.png", width: 100%)
    ]
  ][
    *📊 Configuration*
    - Type : Linear Regression
    - Split : 80/20
    - Cible : BPCO

    *📈 Résultats*
    - R² = #stress[0.79]
    - Comparable à sklearn
  ]
]

#slide(title: "Dashboard Omniscope")[
  #align(center)[
    #image("img/omni_dashboard.png", width: 68%)
  ]

  #align(center)[
    Comparaison prédictions vs valeurs réelles
  ]
]

#slide(title: "Scenarii dans Omniscope")[
  #align(center)[
    #image("img/omni_scenario_results.png", width: 80%)
  ]

  *Limite* : Régression linéaire → prédiction d'une droite. Pas d'export modèle!
]

#slide(title: "Omniscope — Bilan")[
  #cols(columns: (1fr, 1fr), gutter: 2em)[
    *✅ Avantages*
    - Interface conviviale
    - Dashboards interactifs
    - Pas besoin de coder
    - Intégration scripts Python/R
  ][
    *❌ Limites*
    - Choix modèles limité
    - Pas de contrôle hyperparamètres
    - #stress[Export impossible]
    - MARS : problème de convergence
  ]

  #v(0.5em)
  #align(center)[
    Omniscope = exploration & dashboards • Modélisation avancée → #stress[Python]
  ]
]

// =====================================================================
// ÉVALUATION
// =====================================================================

#title-slide[
  Évaluation des Modèles
]

#slide(title: "Principes d'évaluation")[
  #cols(columns: (1fr, 1fr), gutter: 2em)[
    *📊 Métriques utilisées*
    - #stress[R²] : variance expliquée
    - #stress[RMSE] : erreur quadratique
    - Analyse des résidus

    *✂️ Séparation des données*
    - Train : 80% (entraînement)
    - Test : 20% (évaluation)
    - Graine aléatoire fixée
  ][
    *🔄 Méthodes appliquées*
    - Comparaison multi-modèles
    - GridSearchCV (hyperparams)
    - Test d'extrapolation

    *⚠️ Points d'attention*
    - Pas de k-fold CV
    - Split non temporel
    - Pas de validation externe
  ]
]

#slide(title: "Synthèse de l'évaluation")[
  #align(center)[
    #table(
      columns: (auto, auto, auto, auto),
      stroke: 0.5pt + gray,
      inset: 8pt,
      [*Critère*], [*GB*], [*ANN*], [*Note*],
      [R² Cancer], [0.923], [0.872], [GB meilleur],
      [R² BPCO], [0.901], [0.637], [GB meilleur],
      [R² Pneumo], [0.805], [0.956], [ANN meilleur],
      [Extrapolation], [❌ Incohérent], [✅ Cohérent], [ANN meilleur],
      [Interprétabilité], [✅ Bonne], [❌ Opaque], [GB meilleur],
    )
  ]

  #align(center)[
    R² élevé ≠ prédictions fiables hors distribution !
  ]
]

// =====================================================================
// DÉPLOIEMENT
// =====================================================================

#title-slide[
  Déploiement
]


#slide(title: "Comment déployer un modèle ?")[
  #cols(columns: (1fr, 1fr), gutter: 2em)[
    *1. Sauvegarder le modèle*
    - sklearn : `joblib.dump()`
    - PyTorch : `torch.save()`
    - + Scaler, transformations

    *2. Créer une API*
    - FastAPI / Flask
    - Endpoint `/predict`
    - Validation des entrées
  ][
    *3. Conteneuriser*
    - Dockerfile
    - Environnement reproductible
    - CI/CD automatisé

    *4. Déployer en cloud*
    - AWS SageMaker
    - GCP Vertex AI
    - Azure ML
  ]
]


// =====================================================================
// CONCLUSION
// =====================================================================

#title-slide[
  Conclusion
]

#slide(title: "Synthèse des résultats")[
  #cols(columns: (1fr, 1fr), gutter: 2em)[
    *📊 Data Understanding*
    - 197 pays, 43 ans de données
    - Corrélations significatives
    - BPCO = plus corrélée
    - Forte multicolinéarité

    *🤖 Modélisation*
    - GB : R² ≈ 0.90 (interpolation)
    - ANN : meilleure extrapolation
    - Polluants : NH₃, OC, SO₂
  ][
    *🎯 Objectifs atteints*
    - ✅ Quantification relations
    - ✅ Polluants critiques identifiés
    - ✅ Zones prioritaires
    - ⚠️ Prédictions = tendances

    *🔧 Outils maîtrisés*
    - Polars, Pandas, NumPy
    - scikit-learn, PyTorch
    - Omniscope, CRISP-DM
  ]
]

#slide(title: "Recommandations")[
  #cols(columns: (1fr, 1fr), gutter: 2em)[
    *🏛️ Pour les décideurs*
    - Cibler #stress[NH₃] (agriculture)
    - Cibler #stress[SO₂] (industrie)
    - Prioriser zones BPCO
    - Surveiller PM2.5 et OC
  ][
    *🔬 Pour la recherche*
    - Facteurs socio-économiques
    - Analyses intra-urbaines
    - Modèles de panel temporel
    - Variables contrôle (PIB)
  ]

  #v(0.5em)
  *⚠️ Limites* : Corrélation ≠ causalité • Extrapolation limitée • Granularité pays
]

#focus-slide[
  Merci pour votre attention !

  _Questions ?_
]

#blank-slide[
  #align(center)[
    #text(size: 22pt, weight: "bold")[Références]
  ]

  #v(0.5em)
  *📊 Données* : EDGAR v8.0, GBD 2023

  *📚 Méthodologie* : CRISP-DM, Gradient Boosting, Multilayer Perceptron

  *🔧 Outils* : scikit-learn, PyTorch, Polars, Omniscope



  #v(0.5em)
  #align(center)[
    #link("https://github.com/malcolm-a/nf21_respiratory_diseases")[🔗 Dépôt GitHub]
  ]
]
