#import "@preview/typslides:1.3.0": *

// =====================================================================
// CONFIGURATION - Thème moderne et sobre
// =====================================================================
#show: typslides.with(
  ratio: "16-9",
  theme: rgb("#1a1a2e"), // Dark navy - moderne et sobre
  font: "Helvetica Neue",
  font-size: 22pt,
  link-style: "color",
  show-progress: true,
)

// =====================================================================
// PAGE DE TITRE
// =====================================================================
#front-slide(
  title: "Respiratory Risk Analytics",
  subtitle: [Pollution Atmosphérique & Maladies Respiratoires],
  authors: "Y. APEAPEA-MIGUE • M. ARIDORY • H. CHEVALIER • Y. FATHALLAH • G. RODRIGUES",
  info: [NF21 — UTT — Automne 2025],
)

// =====================================================================
// SOMMAIRE
// =====================================================================
#table-of-contents(title: "Agenda")

// =====================================================================
// 1. PROBLÉMATIQUE
// =====================================================================
#focus-slide[
  #text(size: 38pt, weight: "bold")[
    Quelle relation entre pollution atmosphérique et maladies respiratoires ?
  ]
]

// Slide 1 - Contexte visuel
#slide(title: "Contexte")[
  #align(center)[
    #table(
      columns: (1fr, 1fr, 1fr, 1fr),
      stroke: none,
      inset: 15pt,
      align: center,
      [#text(size: 48pt)[🌍]], [#text(size: 48pt)[🏭]], [#text(size: 48pt)[🏥]], [#text(size: 48pt)[📊]],
      [*197 pays*], [*9 polluants*], [*5 maladies*], [*43 ans*],
      [Couverture mondiale], [EDGAR Database], [GBD 2023], [1980–2022],
    )
  ]

  #v(1.5em)
  #align(center)[
    #framed(back-color: rgb("#e8e8ff"))[
      *Objectif* : Identifier les leviers de réduction de la mortalité respiratoire
    ]
  ]
]

// Slide 2 - Sous-questions
#slide(title: "Questions de recherche")[
  #align(center)[
    #v(1em)
    #table(
      columns: (1fr, 1fr),
      stroke: none,
      inset: 20pt,
      [
        #text(size: 40pt)[🔍]
        *Diagnostiquer*

        Où sont les zones critiques ?
      ],
      [
        #text(size: 40pt)[📈]
        *Expliquer*

        Quels liens temporels ?
      ],

      [
        #text(size: 40pt)[🎯]
        *Prédire*

        Évolution future ?
      ],
      [
        #text(size: 40pt)[💡]
        *Recommander*

        Actions prioritaires ?
      ],
    )
  ]
]

// Slide 3 - Enjeux
#slide(title: "Enjeux")[
  #align(center)[
    #image("data_understanding_files/diseases_countries.png", width: 75%)
  ]
  #align(center)[
    _Distribution géographique des maladies respiratoires — disparités majeures_
  ]
]

// =====================================================================
// 2. DATA UNDERSTANDING
// =====================================================================
#title-slide[
  Data Understanding
]

// Slide 4 - Sources de données
#slide(title: "Sources de données")[
  #cols(columns: (1fr, 1fr), gutter: 2em)[
    #align(center)[
      *EDGAR*

      Commission Européenne

      #text(size: 16pt)[
        • 9 polluants atmosphériques
        • Granularité : pays, année, secteur
        • Unité : kilotonnes (kt)
      ]

      #v(0.5em)
      PM2.5 • PM10 • NOx • SO₂ • CO
      NH₃ • NMVOC • BC • OC
    ]
  ][
    #align(center)[
      *GBD 2023*

      IHME — Global Burden of Disease

      #text(size: 16pt)[
        • 5 maladies respiratoires
        • Taux standardisés par âge
        • Unité : décès/100k hab.
      ]

      #v(0.5em)
      Cancer • BPCO • Asthme
      Pneumoconioses • Maladies interstitielles
    ]
  ]
]

// Slide 5 - Qualité des données
#slide(title: "Qualité des données")[
  #cols(columns: (1fr, 2fr), gutter: 2em)[
    #text(size: 60pt, weight: "bold")[99.99%]

    *Complétude*

    • 197 pays fusionnés
    • 8 471 observations
    • Outliers < 2%
  ][
    #align(center)[
      #image("data_understanding_files/data_understanding_37_1.png", width: 100%)
    ]
  ]
]

// Slide 6 - Distribution des émissions
#slide(title: "Distribution des émissions")[
  #align(center)[
    #image("data_understanding_files/data_understanding_41_1.png", width: 90%)
  ]
]

// Slide 7 - Évolution temporelle émissions
#slide(title: "Évolution temporelle — Émissions")[
  #align(center)[
    #image("data_understanding_files/data_understanding_45_0.png", width: 85%)
  ]
  #align(center)[
    _Pic en 1990 • CO = polluant dominant • Polluants très corrélés_
  ]
]

// Slide 8 - Évolution temporelle décès
#slide(title: "Évolution temporelle — Décès")[
  #align(center)[
    #image("data_understanding_files/data_understanding_46_0.png", width: 85%)
  ]
  #align(center)[
    _BPCO ↘ • Cancer stable • Impact des progrès médicaux_
  ]
]

// Slide 9 - Top émetteurs
#slide(title: "Top 15 pays émetteurs")[
  #align(center)[
    #image("data_understanding_files/data_understanding_48_0.png", width: 90%)
  ]
]

// Slide 10 - Comparaison H/F
#slide(title: "Disparités Hommes / Femmes")[
  #cols(columns: (3fr, 1fr), gutter: 1em)[
    #align(center)[
      #image("data_understanding_files/data_understanding_43_0.png", width: 100%)
    ]
  ][
    #v(2em)
    *Cancer poumon*
    H/F ≈ 2-3x

    #v(1em)
    *BPCO*
    Écart significatif

    #v(1em)
    _Facteurs : tabac, exp. pro._
  ]
]

// Slide 11 - Analyse sectorielle
#slide(title: "Analyse sectorielle")[
  #align(center)[
    #image("data_understanding_files/data_understanding_52_1.png", width: 85%)
  ]
]

// Slide 12 - Corrélations polluants/maladies
#slide(title: "Corrélations polluants × maladies")[
  #cols(columns: (1fr, 1fr), gutter: 1em)[
    #align(center)[
      #image("data_understanding_files/data_understanding_58_0.png", width: 100%)
    ]
  ][
    #v(2em)
    *Observations clés*

    • #stress[BPCO] : plus corrélée
    • PM2.5, PM10 : impact universel
    • NH₃, OC : cancer poumon

    #v(1em)
    *⚠️ Multicolinéarité*
    Polluants corrélés entre eux
    (r > 0.8)
  ]
]

// =====================================================================
// 3. CHAÎNES DE VALORISATION
// =====================================================================
#title-slide[
  Chaînes de Valorisation
]

// Slide 13 - Chaîne 1
#slide(title: "Chaîne 1 — Corrélations polluants-maladies")[
  #align(center)[
    #table(
      columns: (1fr, 1fr, 1fr, 1fr),
      stroke: 1pt + rgb("#1a1a2e"),
      inset: 12pt,
      align: center,
      fill: (x, _) => if x == 0 { rgb("#1a1a2e") } else { white },
      text(fill: white)[*Collecte*],
      text(fill: white)[*Préparation*],
      text(fill: white)[*Traitement*],
      text(fill: white)[*Restitution*],

      [EDGAR\nGBD], [Harmonisation\nISO 3166], [Corrélations\nPearson], [Heatmaps\nScatter plots],
      [Python\nrequests], [Polars\nPandas], [Scipy\nOmniscope], [Matplotlib\nOmniscope],
    )
  ]

  #v(1em)
  #align(center)[
    *Objectif* : Identifier les liens statistiques émissions ↔ mortalité
  ]
]

// Slide 14 - Chaîne 2
#slide(title: "Chaîne 2 — Analyse géo-temporelle")[
  #align(center)[
    #table(
      columns: (1fr, 1fr, 1fr, 1fr),
      stroke: 1pt + rgb("#1a1a2e"),
      inset: 12pt,
      align: center,
      fill: (x, _) => if x == 0 { rgb("#1a1a2e") } else { white },
      text(fill: white)[*Collecte*],
      text(fill: white)[*Préparation*],
      text(fill: white)[*Traitement*],
      text(fill: white)[*Restitution*],

      [Jointure\nEDGAR+GBD], [Agrégation\npays-année], [Classements\nTendances], [Bar charts\nCourbes],
      [Polars join], [group_by\nfilter], [Numpy\nOmniscope], [Seaborn\nOmniscope],
    )
  ]

  #v(1em)
  #align(center)[
    *Objectif* : Comprendre la distribution spatiale et l'évolution temporelle
  ]
]

// Slide 15 - Chaîne 5
#slide(title: "Chaîne 5 — Modélisation prédictive")[
  #align(center)[
    #table(
      columns: (1fr, 1fr, 1fr, 1fr),
      stroke: 1pt + rgb("#1a1a2e"),
      inset: 12pt,
      align: center,
      fill: (x, _) => if x == 0 { rgb("#1a1a2e") } else { white },
      text(fill: white)[*Préparation ML*],
      text(fill: white)[*ML Classique*],
      text(fill: white)[*Deep Learning*],
      text(fill: white)[*Évaluation*],

      [Log-transform\nStandardScaler], [Gradient\nBoosting], [MLP\nPyTorch], [R², RMSE\nComparaison],
      [Polars\nsklearn], [GridSearchCV\nOmniscope], [Adam\nMSE], [joblib\nOmniscope],
    )
  ]

  #v(1em)
  #align(center)[
    *Objectif* : Prédire la mortalité à partir des émissions de polluants
  ]
]

// =====================================================================
// 4. DATA PREPARATION
// =====================================================================
#title-slide[
  Data Preparation
]

// Slide 16 - Pipeline
#slide(title: "Pipeline de préparation")[
  #align(center)[
    #v(1em)
    #text(size: 24pt)[
      *EDGAR* (Excel) #h(0.5em) → #h(0.5em) Polars #h(0.5em) → #h(0.5em) Dépivotage
    ]

    #v(0.5em)
    #text(size: 32pt)[↓]

    #text(size: 24pt)[
      *Jointure ISO 3166 + Année*
    ]

    #v(0.5em)
    #text(size: 32pt)[↓]

    #text(size: 24pt)[
      *GBD* (CSV) #h(0.5em) → #h(0.5em) Polars #h(0.5em) → #h(0.5em) Mapping FR→EN
    ]

    #v(1em)
    #framed(back-color: rgb("#d4edda"))[
      Dataset final : *8 471 lignes × 17 colonnes* • Format *Parquet*
    ]
  ]
]

// Slide 17 - Préparation ML
#slide(title: "Préparation pour la modélisation")[
  #cols(columns: (1fr, 1fr), gutter: 2.5em)[
    *Transformations*

    #v(0.5em)
    #text(size: 18pt)[
      *Log-transform*
      $ x' = log(1 + x) $

      *StandardScaler*
      $ x' = (x - mu) / sigma $
    ]

    #v(1em)
    *Split* : 80% train / 20% test
  ][
    *Variables*

    #v(0.5em)
    *9 features* (polluants)
    CO, SO₂, NOx, PM2.5, PM10
    NH₃, NMVOC, BC, OC

    #v(1em)
    *3 cibles* (maladies)
    Cancer • BPCO • Pneumoconiose

    #text(size: 16pt, fill: gray)[_(Asthme exclu : corrélation ≈ 0)_]
  ]
]

// =====================================================================
// 5. MODELING
// =====================================================================
#title-slide[
  Modeling
]

// Slide 18 - Approche
#slide(title: "Approche — Deux frameworks")[
  #cols(columns: (1fr, 1fr), gutter: 3em)[
    #align(center)[
      #text(size: 32pt)[🤖]

      *scikit-learn*

      #v(0.5em)
      Machine Learning classique

      • Ridge
      • Random Forest
      • #stress[Gradient Boosting] ✓
    ]
  ][
    #align(center)[
      #text(size: 32pt)[🧠]

      *PyTorch*

      #v(0.5em)
      Deep Learning

      • MLP (Perceptron multicouche)
      • 2 couches cachées
      • Activation ReLU
    ]
  ]
]

// Slide 19 - Architecture ANN
#slide(title: "Architecture du réseau de neurones")[
  #cols(columns: (1fr, 1fr), gutter: 1em)[
    #align(center)[
      #image("img/ann.jpg", width: 100%)
    ]
  ][
    *Architecture MLP*

    #v(0.5em)
    #text(size: 18pt)[
      ```
      Entrée (9) → Dense(64) → ReLU
                 → Dense(32) → ReLU
                 → Dense(1) → Sortie
      ```
    ]

    #v(1em)
    *Hyperparamètres*
    • Optimizer : Adam
    • Loss : MSE
    • LR : 0.001
    • Epochs : 500
  ]
]

// Slide 20 - Overfitting
#slide(title: "Overfitting vs Underfitting")[
  #align(center)[
    #image("img/over_underfitting.png", width: 75%)
  ]
  #align(center)[
    _Équilibre crucial : généralisation sans mémorisation du bruit_
  ]
]

// Slide 21 - Comparaison modèles sklearn
#slide(title: "Comparaison des algorithmes")[
  #align(center)[
    #v(1em)
    #table(
      columns: (auto, auto, auto),
      stroke: 0.5pt + gray,
      inset: 12pt,
      align: center,
      [*Modèle*], [*R²*], [*RMSE*],
      [Ridge], [0.156], [9 188],
      [Random Forest], [0.737], [5 128],
      [#stress[Gradient Boosting]], [#stress[0.772]], [#stress[4 782]],
    )

    #v(1.5em)
    *Gradient Boosting* retenu — correction itérative des erreurs
  ]
]

// Slide 22 - Résultats GB
#slide(title: "Résultats — Gradient Boosting")[
  #align(center)[
    #v(1em)
    #table(
      columns: (auto, auto, auto),
      stroke: 0.5pt + gray,
      inset: 12pt,
      align: center,
      [*Maladie*], [*R²*], [*Top 5 polluants*],
      [Cancer], [#stress[0.923]], [SO₂ (25%), NH₃ (17%), NOx (13%)],
      [BPCO], [#stress[0.901]], [NH₃ (18%), OC (18%), NMVOC (15%)],
      [Pneumoconiose], [0.805], [OC (16%), NH₃ (15%), NMVOC (13%)],
    )

    #v(1.5em)
    *NH₃* et *OC* : polluants les plus prédictifs
  ]
]

// Slide 23 - Résultats ANN
#slide(title: "Résultats — Réseau de neurones")[
  #align(center)[
    #v(1em)
    #table(
      columns: (auto, auto, auto),
      stroke: 0.5pt + gray,
      inset: 12pt,
      align: center,
      [*Maladie*], [*R² GB*], [*R² ANN*],
      [Cancer], [0.923], [0.872],
      [Pneumoconiose], [0.805], [#stress[0.956]],
      [BPCO], [0.901], [0.637],
    )

    #v(1.5em)
    ANN excellent sur Pneumoconiose • GB plus robuste globalement
  ]
]

// =====================================================================
// 6. OMNISCOPE
// =====================================================================
#title-slide[
  Implémentation Omniscope
]

// Slide 24 - Pipeline Omniscope
#slide(title: "Pipeline de données — Omniscope")[
  #align(center)[
    #image("img/omni_data_prep.png", width: 85%)
  ]
]

// Slide 25 - Modèle Omniscope
#slide(title: "Modèle de régression — Omniscope")[
  #cols(columns: (2fr, 1fr), gutter: 1em)[
    #align(center)[
      #image("img/omni_model_pipeline.png", width: 100%)
    ]
  ][
    *Configuration*

    • Linear Regression
    • Split 80/20
    • Cible : BPCO

    #v(1em)
    *Résultat*

    R² = #stress[0.79]
  ]
]

// Slide 26 - Dashboard Omniscope
#slide(title: "Dashboard interactif")[
  #align(center)[
    #image("img/omni_dashboard.png", width: 72%)
  ]
]

// Slide 27 - Scenarii Omniscope
#slide(title: "Scenarii de réduction — Omniscope")[
  #align(center)[
    #image("img/omni_scenario_results.png", width: 85%)
  ]
  #align(center)[
    _Régression linéaire : tendance générale, pas de nuances_
  ]
]

// =====================================================================
// 7. PRÉDICTIONS
// =====================================================================
#title-slide[
  Prédictions & Scenarii
]

// Slide 28 - Prédictions GB
#slide(title: "Prédictions — Gradient Boosting")[
  #align(center)[
    #image("img/predictions_gb.png", width: 92%)
  ]
  #align(center)[
    _⚠️ Incohérences en extrapolation — limites des arbres de décision_
  ]
]

// Slide 29 - Prédictions ANN
#slide(title: "Prédictions — Réseau de neurones")[
  #align(center)[
    #image("img/predictions_ann.png", width: 92%)
  ]
  #align(center)[
    _✓ Tendances cohérentes — meilleure généralisation_
  ]
]

// =====================================================================
// 8. CONCLUSION
// =====================================================================
#title-slide[
  Conclusion
]

// Slide 30 - Synthèse
#slide(title: "Synthèse")[
  #cols(columns: (1fr, 1fr), gutter: 2em)[
    *✅ Résultats*

    • Corrélations significatives
    #h(0.5em) NH₃, OC, SO₂ ↔ BPCO, Cancer

    • Modèles performants
    #h(0.5em) R² > 0.80 (interpolation)

    • Polluants critiques identifiés

    • Pipeline reproductible
  ][
    *⚠️ Limites*

    • Corrélation ≠ causalité

    • Extrapolation limitée (GB)

    • Facteurs confondants
    #h(0.5em) _(PIB, soins, démographie)_

    • Granularité pays uniquement
  ]
]

// Slide final
#focus-slide[
  #text(size: 32pt, weight: "bold")[
    Merci de votre attention
  ]

  #v(1em)

  #text(size: 20pt)[
    📧 Contact : équipe projet

    🔗 GitHub : github.com/malcolm-a/nf21_respiratory_diseases
  ]
]
