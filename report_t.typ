// =============================================================================
// CONFIGURATION DU DOCUMENT
// =============================================================================

#set document(
  title: "Respiratory Risk Analytics",
  author: ("Yves APEAPEA-MIGUE", "Malcolm ARIDORY", "Hélèna CHEVALIER", "Yesmine FATHALLAH", "Gwendal RODRIGUES"),
  date: auto,
)

// Police CMU Serif
#set text(
  font: "CMU Serif",
  size: 11pt,
  lang: "fr",
)

// Marges
#set page(
  paper: "a4",
  margin: 2.5cm,
)

// Couleurs
#let primary-color = rgb("#1a5fb4")    // blue!70!black équivalent
#let secondary-color = rgb("#3584e4")  // blue!50!black équivalent

// Configuration des liens
#show link: set text(fill: primary-color)

// Configuration des titres
#set heading(numbering: "1.")

#show heading.where(level: 1): it => {
  set text(size: 14pt, weight: "bold", fill: primary-color)
  block(above: 1.5em, below: 1em)[#it]
}

#show heading.where(level: 2): it => {
  set text(size: 12pt, weight: "bold", fill: secondary-color)
  block(above: 1.2em, below: 0.8em)[#it]
}

#show heading.where(level: 3): it => {
  set text(size: 11pt, weight: "bold", fill: secondary-color)
  block(above: 1em, below: 0.6em)[#it]
}

// Configuration des paragraphes
#set par(justify: true)

// Configuration des listes
#set list(indent: 1em)
#set enum(indent: 1em)

// Variable pour tracker la partie courante
#let current-part = state("current-part", "")

// Fonction pour créer une partie (comme \part en LaTeX)
#let part(title) = {
  pagebreak()
  current-part.update(title)
  align(center)[
    #v(3cm)
    #text(size: 24pt, weight: "bold")[Partie]
    #v(0.5cm)
    #text(size: 28pt, weight: "bold", fill: primary-color)[#title]
    #v(2cm)
  ]
  // Reset section counter pour chaque partie
  counter(heading).update(0)
}

// En-tête et pied de page (après la page de titre)
#let header-footer-style = page.with(
  header: context {
    let part-name = current-part.get()
    if part-name != "" {
      set text(size: 9pt)
      grid(
        columns: (1fr, 1fr),
        align: (left, right),
        [#part-name],
        [NF21 -- UTT]
      )
      line(length: 100%, stroke: 0.4pt)
    }
  },
  footer: context {
    line(length: 100%, stroke: 0.4pt)
    v(0.3em)
    align(center)[
      #set text(size: 10pt)
      #counter(page).display()
    ]
  },
)

// =============================================================================
// PAGE DE TITRE
// =============================================================================

#page(
  header: none,
  footer: none,
)[
  #align(center)[
    #v(1cm)
    
    #text(size: 14pt, smallcaps[Université de Technologie de Troyes])
    
    #v(0.3cm)
    
    #line(length: 100%, stroke: 0.5pt)
    #v(0.4cm)
    #text(size: 24pt, weight: "bold")[Respiratory Risk Analytics]
    #v(0.2cm)
    #text(size: 14pt)[Pollution Atmosphérique et Maladies Respiratoires]
    #v(0.3cm)
    #line(length: 100%, stroke: 0.5pt)
    
    #v(1.5cm)
    
    #text(size: 12pt, weight: "bold")[Auteurs :]
    #v(0.3cm)
    
    #table(
      columns: 1,
      align: center,
      stroke: none,
      [Yves APEAPEA-MIGUE],
      [Malcolm ARIDORY],
      [Hélèna CHEVALIER],
      [Yesmine FATHALLAH],
      [Gwendal RODRIGUES],
    )
    
    #v(1.5cm)
    
    #table(
      columns: 2,
      align: (right, left),
      stroke: none,
      column-gutter: 1em,
      [*Sources de données :*], [EDGAR (Émissions)],
      [], [GBD 2023 (Maladies)],
      [], [],
      [*Période :*], [1980 -- 2022],
      [], [],
      [*Couverture :*], [197 pays],
    )
    
    #v(1fr)
    
    #text(size: 12pt)[NF21 -- A25]
  ]
]

// =============================================================================
// TABLE DES MATIÈRES
// =============================================================================

#page(
  header: none,
  footer: context {
    line(length: 100%, stroke: 0.4pt)
    v(0.3em)
    align(center)[
      #set text(size: 10pt)
      #counter(page).display()
    ]
  },
)[
  #outline(
    title: [Table des matières],
    indent: auto,
    depth: 3,
  )
]

#pagebreak()

// =============================================================================
// INTRODUCTION
// =============================================================================

#set page(
  header: context {
    let part-name = current-part.get()
    set text(size: 9pt)
    grid(
      columns: (1fr, 1fr),
      align: (left, right),
      [#if part-name != "" { part-name } else { "Introduction" }],
      [NF21 -- UTT]
    )
    line(length: 100%, stroke: 0.4pt)
  },
  footer: context {
    line(length: 100%, stroke: 0.4pt)
    v(0.3em)
    align(center)[
      #set text(size: 10pt)
      #counter(page).display()
    ]
  },
)

#heading(level: 1, numbering: none)[Introduction]

La pollution atmosphérique constitue aujourd'hui l'un des principaux déterminants environnementaux de santé. Ses effets sur les pathologies respiratoires sont largement documentés, mais leur ampleur et leur dynamique varient selon les territoires, les périodes et les types de polluants.

Le projet *Respiratory Risk Analytics* s'inscrit dans cette perspective. Il vise à mieux comprendre les interactions entre les émissions atmosphériques et l'évolution des maladies respiratoires à l'échelle mondiale. En s'appuyant sur des bases de données reconnues et actualisées, le projet cherche à fournir des éléments factuels pour aider les décideurs à identifier les zones les plus sensibles et à prioriser les actions de réduction de la pollution.

Ce rapport est structuré selon la méthodologie CRISP-DM :

- *Business Understanding* : compréhension du contexte métier, des enjeux et des objectifs du projet
- *Data Understanding* : exploration et analyse des données disponibles
- *Data Preparation* : préparation des données pour la modélisation
- *Modeling* : modélisation des données
- *Evaluation* : évaluation des modèles
- *Deployment* : déploiement des modèles

=== Objectifs de l'étude

- Comprendre et quantifier la relation entre la pollution atmosphérique et l'incidence des maladies respiratoires
- Identifier les zones prioritaires d'intervention
- Analyser les tendances temporelles des émissions de polluants atmosphériques
- Étudier la distribution géographique des maladies respiratoires
- Identifier les corrélations entre polluants et pathologies
- Préparer les données pour la phase de modélisation
- Modéliser la relation entre la pollution atmosphérique et l'incidence des maladies respiratoires

// =============================================================================
// PARTIE I : BUSINESS UNDERSTANDING
// =============================================================================

#part[Business Understanding]

= Contexte Général

Ce projet s'inscrit dans le champ de la santé publique et de l'environnement, deux domaines où les interactions entre qualité de l'air et santé humaine constituent des préoccupations majeures. L'augmentation de la fréquence des épisodes de pollution et la progression des maladies respiratoires en font un enjeu prioritaire pour les autorités sanitaires nationales et internationales. Les politiques publiques s'appuient désormais fortement sur les données pour orienter les stratégies territoriales de prévention et d'intervention.

Plusieurs acteurs sont impliqués dans cette dynamique : les collectivités territoriales, les agences de santé publique, les ministères en charge de la santé et de l'environnement, ainsi que les organisations européennes comme la Commission Européenne. Les citoyens, directement exposés aux risques liés à la pollution atmosphérique, représentent la première population bénéficiaire du projet. Dans ce contexte institutionnel riche, le recours à une analyse _data-driven_ constitue un outil d'aide à la décision essentiel.

= Question Métier et Objectifs

L'objectif global du projet Respiratory Risk Analytics consiste à comprendre et quantifier la relation entre la pollution atmosphérique et l'incidence des maladies respiratoires dans le monde. Cette question métier répond à un besoin décisionnel réel : identifier les zones prioritaires d'intervention et mesurer l'impact potentiel ou réel des politiques publiques de réduction de la pollution.

La question centrale formulée est la suivante : *« Quelle est la relation entre la pollution atmosphérique et l'incidence des maladies respiratoires à l'échelle mondiale ? »*.

Plusieurs sous-questions guident cette problématique :

- *Diagnostiquer* : identifier les zones où les émissions et les maladies respiratoires sont les plus élevées
- *Expliquer* : analyser les liens temporels entre variations de pollution et variations de santé
- *Prédire* : estimer l'évolution potentielle des maladies à partir des niveaux de pollution
- *Recommander* : proposer des actions prioritaires

#pagebreak()

= Enjeux du Projet

Les enjeux sont multiples et concernent plusieurs dimensions :

== Enjeux environnementaux

La réduction des émissions de polluants constitue un impératif lié à la fois aux réglementations européennes et à la protection de la biodiversité.

== Enjeux sanitaires

La pollution atmosphérique est reconnue comme un facteur aggravant majeur pour des pathologies telles que l'asthme, la bronchopneumopathie chronique obstructive (BPCO) et les infections respiratoires aiguës.

== Enjeux économiques

Une diminution de l'incidence des maladies respiratoires permettrait une réduction des dépenses hospitalières, des coûts de prise en charge et des pertes de productivité liées aux arrêts de travail.

== Enjeux sociaux

Les enjeux sociaux touchent directement la qualité de vie des populations, notamment les plus vulnérables.

#v(0.5cm)

Ce projet présente ainsi une forte valeur ajoutée, car il vise à éclairer la décision publique et à cibler les zones où les actions de réduction de la pollution atmosphérique auraient l'effet le plus significatif.

= Objectifs Métier

Le projet se fixe plusieurs objectifs métier :

+ *Identification des zones prioritaires* : grâce à une démarche de data mining, identifier les zones géographiques où les marges de réduction de la pollution sont les plus fortes et où les interventions publiques peuvent avoir un impact significatif.

+ *Réduction de l'incidence* : proposer des solutions permettant de réduire l'incidence des maladies respiratoires de 5% dans les zones les plus sensibles, et de diminuer de 10% les émissions des polluants les plus dangereux pour la santé.

+ *Identification des polluants critiques* : identifier les polluants ayant l'impact le plus important sur la santé respiratoire à l'échelle mondiale.

#pagebreak()

= Jeux de Données <sec-jeux-de-donnees>

Pour répondre à ces objectifs, deux principaux jeux de données externes ont été identifiés.

== Données EDGAR (TG11 -- Collecte)

*EDGAR (Emissions Database for Global Atmospheric Research)* : Base de données de la Commission Européenne contenant les émissions de polluants atmosphériques par pays, année et secteur d'activité.

Les données se présentent sous forme de fichiers Excel contenant environ 6 000 lignes par polluant. Les variables incluent :

- L'année (numérique)
- Le pays (catégoriel)
- Le secteur d'émission (catégoriel)
- Le type de polluant (catégoriel)
- La quantité d'émissions en gigagrammes (numérique)

Ces données permettent de suivre l'évolution des polluants majeurs (PM2.5, PM10, NOx, SO2, etc.) dans le temps.

== Données IHME : Global Burden of Disease

*GBD 2023 (Global Burden of Disease)* : Étude de l'Institute for Health Metrics and Evaluation (IHME) fournissant les taux de mortalité standardisés par âge pour les maladies respiratoires.

Les fichiers CSV contiennent environ 30 000 lignes et décrivent les taux normalisés d'incidence et de mortalité pour 100 000 habitants. Les variables incluent :

- L'année (numérique)
- Le pays (catégoriel)
- Le sexe (catégoriel)
- Les taux d'incidence et de décès (numériques)

Ces deux jeux de données sont complémentaires et permettent une analyse spatio-temporelle robuste. La littérature scientifique, notamment les travaux de Santé Publique France, confirme l'existence d'un lien entre pollution atmosphérique et santé respiratoire, justifiant pleinement leur mise en relation.

= Périmètre Analytique

Le périmètre analytique du projet est défini comme suit :

#figure(
  table(
    columns: 2,
    align: (left, left),
    stroke: (x, y) => if y == 0 { (bottom: 1pt) } else { none },
    table.header(
      [*Dimension*], [*Périmètre*],
    ),
    [Couverture géographique], [Ensemble des pays du monde (197 pays)],
    [Période], [1980--2022],
    [Polluants], [PM2.5, PM10, NOx, SO2, CO, NH3, NMVOC, BC, OC],
    [Maladies], [Asthme, BPCO, cancer du poumon, pneumoconioses, maladies pulmonaires interstitielles],
  ),
  caption: [Périmètre du projet],
)

*Hors périmètre :* Les analyses à l'échelle intra-urbaine, ou celles portant sur les déterminants sociaux individuels, ne sont pas incluses en raison du manque de données disponibles.

#pagebreak()

= Parties Prenantes

== Commanditaire principal

L'*Agence Régionale de Santé (ARS)* constitue une partie prenante centrale dans ce projet, à la fois comme utilisatrice directe des analyses produites et comme actrice opérationnelle des décisions qui pourront en découler. En tant qu'autorité sanitaire de proximité, l'ARS est chargée de mettre en œuvre au niveau régional les politiques nationales liées à la prévention, à la surveillance épidémiologique et à la protection de la santé des populations.

Dans le contexte de la pollution atmosphérique, l'ARS joue un rôle d'interface entre les données scientifiques, les acteurs locaux et les décisions publiques. Les résultats du projet pourront être mobilisés pour ajuster les plans régionaux santé-environnement, cibler les territoires les plus vulnérables et renforcer les dispositifs de prévention.

== Équipe projet

L'équipe projet est composée d'analystes et de spécialistes des données chargés de transformer les données brutes (EDGAR, IHME) en indicateurs intelligibles.

== Acteurs secondaires

Les résultats du projet sont également destinés à des acteurs secondaires :

- *Santé Publique France* : intégration des indicateurs dans la surveillance sanitaire nationale
- *Observatoires régionaux de la qualité de l'air (ATMO)* : relais de l'information à l'échelle locale
- *Collectivités territoriales* (métropoles, régions) : déploiement des actions concrètes de réduction des émissions
- *Organismes de recherche* spécialisés en climat, pollution ou santé publique

= Risques et Hypothèses

== Risques identifiés

Plusieurs risques concernent la qualité et la comparabilité des données :

- Les méthodes de mesure diffèrent selon les pays
- Certaines séries peuvent être incomplètes
- Des facteurs socio-économiques non observés peuvent introduire des biais
- La granularité géographique est limitée à l'échelle des pays

== Hypothèses

Les hypothèses principales du projet reposent sur :

- La fiabilité des données EDGAR et IHME
- La comparabilité des observations dans le temps et entre pays
- L'existence d'un lien statistique entre pollution atmosphérique et maladies respiratoires
