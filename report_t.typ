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
  margin: (x: 2.5cm, top: 2.5cm, bottom: 2.3cm),
)


// Listes
#set list(marker: [--])

// Couleurs (exactement comme TikZ)
#let primary-color = rgb("#0000ac")    // blue!70!black équivalent
#let secondary-color = rgb("#00007c")  // blue!50!black équivalent
#let tg-fill = rgb("#cce0ff")          // blue!10
#let tg-stroke = rgb("#4d94ff")        // blue!70
#let ts-fill = rgb("#ffe6e6")          // red!10
#let ts-stroke = rgb("#b33939")        // red!70!black
#let outil-fill = rgb("#e6ffe6")       // green!10
#let outil-stroke = rgb("#2d862d")     // green!50!black
#let fleche-color = rgb("#6699ff")     // blue!60
#let fleche-spec-color = rgb("#808080") // gray

// Configuration des liens
#show link: set text(fill: primary-color)

// Configuration des titres
#set heading(numbering: (..nums) => {
  numbering("1.", ..nums)
  h(0.3cm)
})

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
#set par(justify: true, first-line-indent: 1cm, leading: 0.5em, spacing: 1em)

// Configuration des listes
#set list(indent: 1em)
#set enum(indent: 1em)

// Configuration des blocs de code (listings)
#show raw.where(block: true): it => block(
  fill: rgb("#f5f5f5"),
  inset: 4pt,
  radius: 4pt,
  width: 100%,
  it,
)

// Renommer "Liste" en "Code" pour les figures contenant du code
#show figure.where(kind: raw): set figure(supplement: "Code")

// Aligner le code à gauche mais garder la caption centrée
#show figure.where(kind: raw): it => {
  align(left, it.body)
  align(center, it.caption)
}

// Import CeTZ
#import "@preview/cetz:0.3.4"

// Fonction pour créer un schéma de chaîne de valorisation avec CeTZ
#let chaine-schema(
  taches-gen: (), // Liste des 4 tâches génériques
  taches-spec: (), // Liste de 8 tâches spécifiques (2 par TG)
  outils: (), // Liste des 4 outils
) = {
  cetz.canvas(length: 1cm, {
    import cetz.draw: *

    // Positions X des 4 colonnes
    let x-positions = (0, 4, 8, 12)

    // Dessiner les tâches génériques (ligne du haut)
    for (i, x) in x-positions.enumerate() {
      rect(
        (x - 1.1, 0.45),
        (x + 1.1, -0.45),
        fill: tg-fill,
        stroke: 1pt + tg-stroke,
        radius: 6pt,
        name: "tg" + str(i),
      )
      content((x, 0), text(size: 8pt, weight: "bold")[#taches-gen.at(i)])
    }

    // Flèches entre tâches génériques
    for i in range(3) {
      line(
        (x-positions.at(i) + 1.2, 0),
        (x-positions.at(i + 1) - 1.2, 0),
        stroke: 2pt + fleche-color,
        mark: (end: "stealth", fill: fleche-color, scale: 0.5),
      )
    }

    // Dessiner les tâches spécifiques (2 par colonne, côte à côte) - hauteur augmentée pour 2 lignes
    for (i, x) in x-positions.enumerate() {
      // Tâche spécifique gauche
      let ts-left-x = x - 1
      rect(
        (ts-left-x - 0.95, -1.0),
        (ts-left-x + 0.95, -2.0),
        fill: ts-fill,
        stroke: 0.5pt + ts-stroke,
        radius: 4pt,
        name: "ts" + str(i * 2),
      )
      content((ts-left-x, -1.5), box(width: 1.8cm, align(center, text(size: 8pt, weight: "bold")[#taches-spec.at(
        i * 2,
      )])))

      // Tâche spécifique droite
      let ts-right-x = x + 1
      rect(
        (ts-right-x - 0.95, -1.0),
        (ts-right-x + 0.95, -2.0),
        fill: ts-fill,
        stroke: 0.5pt + ts-stroke,
        radius: 4pt,
        name: "ts" + str(i * 2 + 1),
      )
      content((ts-right-x, -1.5), box(width: 1.8cm, align(center, text(size: 8pt, weight: "bold")[#taches-spec.at(
        i * 2 + 1,
      )])))

      // Lignes de connexion TG -> TS
      line((x - 0.3, -0.45), (ts-left-x, -1.0), stroke: 0.5pt + fleche-spec-color)
      line((x + 0.3, -0.45), (ts-right-x, -1.0), stroke: 0.5pt + fleche-spec-color)
    }

    // Dessiner les outils (ligne du bas) - élargis
    for (i, x) in x-positions.enumerate() {
      rect(
        (x - 1.5, -2.7),
        (x + 1.5, -3.5),
        fill: outil-fill,
        stroke: 0.5pt + outil-stroke,
        radius: 3pt,
        name: "outil" + str(i),
      )
      content((x, -3.1), box(width: 2.8cm, align(center, text(size: 8pt, weight: "bold")[#outils.at(i)])))

      // Lignes pointillées TS -> Outils
      let ts-left-x = x - 1
      let ts-right-x = x + 1
      line((ts-left-x, -2.0), (x - 0.4, -2.7), stroke: (paint: fleche-spec-color, thickness: 0.5pt, dash: "dashed"))
      line((ts-right-x, -2.0), (x + 0.4, -2.7), stroke: (paint: fleche-spec-color, thickness: 0.5pt, dash: "dashed"))
    }

    // Légende
    let legend-y = -4.5
    // TG
    rect((3 - 0.3, legend-y + 0.15), (3 + 0.3, legend-y - 0.15), fill: tg-fill, stroke: 0.5pt + tg-stroke, radius: 3pt)
    content((3, legend-y), text(size: 4pt, weight: "bold")[TG])
    content((3.8, legend-y), text(size: 6pt, weight: "bold")[Tâche gén.], anchor: "west")
    // TS
    rect((6 - 0.3, legend-y + 0.15), (6 + 0.3, legend-y - 0.15), fill: ts-fill, stroke: 0.5pt + ts-stroke, radius: 3pt)
    content((6, legend-y), text(size: 4pt, weight: "bold")[TS])
    content((6.8, legend-y), text(size: 6pt, weight: "bold")[Tâche spéc.], anchor: "west")
    // Outils
    rect(
      (9 - 0.3, legend-y + 0.15),
      (9 + 0.3, legend-y - 0.15),
      fill: outil-fill,
      stroke: 0.5pt + outil-stroke,
      radius: 3pt,
    )
    content((9, legend-y), text(size: 4pt, weight: "bold")[O])
    content((9.8, legend-y), text(size: 6pt, weight: "bold")[Outils], anchor: "west")
  })
}


// Variable pour tracker la partie courante
#let current-part = state("current-part", "")

// Compteur pour les parties
#let part-counter = counter("part")

// Fonction pour créer une partie (comme \part en LaTeX)
#let part(title) = {
  pagebreak()
  current-part.update(title)
  part-counter.step()
  // Heading invisible pour la TOC
  [
    #heading(level: 1, numbering: none, outlined: true)[#title]
    #v(-1.5em) // Compense l'espace du heading
  ]
  // Reset section counter pour chaque partie
  counter(heading).update(0)
}

// Style spécial pour les headings de niveau 1 sans numérotation (les parties)
#show heading.where(level: 1, numbering: none): it => {
  set text(size: 24pt, weight: "bold", fill: primary-color)
  block(above: 0.5em, below: 1.5em)[#it.body]
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
        [#part-name], [NF21 -- UTT],
      )
      line(length: 100%, stroke: 0.4pt)
    }
  },
  footer: context {
    line(length: 100%, stroke: 0.4pt)
    v(0.5em)
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
    v(0.5em)
    align(center)[
      #set text(size: 10pt)
      #counter(page).display()
    ]
  },
)[
  // Compteur local pour les parties dans la TOC
  #let toc-part-counter = counter("toc-part")

  #show outline.entry: it => {
    let el = it.element
    let loc = el.location()
    let page-num = counter(page).at(loc).first()

    // Parties (niveau 1 sans numérotation)
    if it.level == 1 and el.numbering == none {
      toc-part-counter.step()
      v(0.8em)
      block[
        #link(loc)[
          #text(weight: "bold", fill: primary-color, size: 11pt)[
            #context toc-part-counter.display("I")
            #h(0.5em)
            #el.body
            #box(width: 1fr, repeat[.#h(3pt)])
            #page-num
          ]
        ]
      ]
    } // Sections niveau 1 (numérotées)
    else if it.level == 1 {
      block[
        #link(loc)[
          #text(weight: "bold", fill: primary-color)[
            #numbering(el.numbering, ..counter(heading).at(loc))
            #h(0.3em)
            #el.body
            #box(width: 1fr, repeat[.#h(3pt)])
            #page-num
          ]
        ]
      ]
    } // Sous-sections niveau 2
    else if it.level == 2 {
      block[
        #h(1.2em)
        #link(loc)[
          #text(fill: primary-color)[
            #numbering(el.numbering, ..counter(heading).at(loc))
            #h(0.3em)
            #el.body
            #box(width: 1fr, repeat[.#h(3pt)])
            #page-num
          ]
        ]
      ]
    } // Sous-sous-sections niveau 3
    else {
      block[
        #h(2.4em)
        #link(loc)[
          #text(fill: primary-color)[
            #numbering(el.numbering, ..counter(heading).at(loc))
            #h(0.3em)
            #el.body
            #box(width: 1fr, repeat[.#h(3pt)])
            #page-num
          ]
        ]
      ]
    }
  }

  #outline(
    title: [Table des matières],
    indent: 0em,
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
      [#if part-name != "" { part-name } else { "Introduction" }], [NF21 -- UTT],
    )
    line(length: 100%, stroke: 0.4pt)
  },
  footer: context {
    line(length: 100%, stroke: 0.4pt)
    v(0.5em)
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

#linebreak()
*Objectifs de l'étude*


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
    table.header([*Dimension*], [*Périmètre*]),
    [Couverture géographique], [Ensemble des pays du monde (197 pays)],
    [Période], [1980--2022],
    [Polluants], [PM2.5, PM10, NOx, SO2, CO, NH3, NMVOC, BC, OC],
    [Maladies], [Asthme, BPCO, cancer du poumon, pneumoconioses, maladies pulmonaires interstitielles],
  ),
  caption: [Périmètre du projet],
)

*Hors périmètre :* Les analyses à l'échelle intra-urbaine, ou celles portant sur les déterminants sociaux individuels, ne sont pas incluses en raison du manque de données disponibles.


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

// =============================================================================
// PARTIE II : DATA UNDERSTANDING
// =============================================================================

#part[Data Understanding]

= Indicateurs clefs

Dans le cadre de la méthodologie CRISP-DM, cette section présente les indicateurs clefs et les chaînes de valorisation identifiées pour l'exploration des données sur la pollution atmosphérique et les maladies respiratoires.

#figure(
  table(
    columns: 3,
    align: (left, left, left),
    stroke: (x, y) => if y == 0 { (bottom: 1pt) } else { none },
    table.header([*Indicateur*], [*Description*], [*Unité*]),
    [Émissions totales par polluant], [Somme des émissions annuelles par type de polluant], [Kilotonnes (kt)],
    [Taux de mortalité standardisé], [Décès pour 100 000 habitants ajusté par âge], [Taux / 100 000 hab.],
    [Corrélation polluant-maladie], [Coefficient de Pearson entre émissions et mortalité], [\[-1, 1\]],
    [Part sectorielle], [Pourcentage des émissions par secteur d'activité], [%],
    [Tendance temporelle], [Variation annuelle moyenne des émissions/mortalité], [% / an],
  ),
  caption: [Indicateurs identifiés pour l'étude],
)

#pagebreak()

= Description des Données

== Vue d'ensemble (TG12 -- Préparation)

#figure(
  table(
    columns: 3,
    align: (left, center, center),
    stroke: (x, y) => if y == 0 { (bottom: 1pt) } else { none },
    table.header([*Caractéristique*], [*EDGAR*], [*GBD 2023*]),
    [Nombre de pays], [215], [204],
    [Période], [1970--2022], [1980--2023],
    [Variables], [9 polluants], [5 maladies],
    [Granularité], [Pays, année, secteur], [Pays, année, sexe],
    [Unité], [Kilotonnes (kt)], [Taux pour 100 000 hab.],
  ),
  caption: [Caractéristiques des jeux de données],
)

== Polluants étudiés (EDGAR)

+ *PM2.5* : Particules fines (< 2.5 μm)
+ *PM10* : Particules (< 10 μm)
+ *NOx* : Oxydes d'azote
+ *SO2* : Dioxyde de soufre
+ *CO* : Monoxyde de carbone
+ *NH3* : Ammoniac
+ *NMVOC* : Composés organiques volatils non méthaniques
+ *BC* : Carbone noir
+ *OC* : Carbone organique

== Maladies respiratoires (GBD)

+ Cancer de la trachée, des bronches et des poumons
+ Bronchopneumopathie chronique obstructive (BPCO) ou Maladie pulmonaire obstructive chronique dans le dataset
+ Asthme
+ Pneumoconioses
+ Maladies pulmonaires interstitielles

#pagebreak()

= Qualité des Données

== Valeurs manquantes (TG12 -- Préparation)

L'analyse des valeurs manquantes révèle une excellente complétude des données. Le taux de valeurs manquantes global est inférieur à 0.01%, principalement concentré dans les correspondances de noms de pays entre les deux sources.

#figure(
  image("data_understanding_files/data_understanding_37_1.png", width: 85%),
  caption: [Distribution des valeurs manquantes par variable],
) <fig-missing>

== Jointure des données

La jointure des deux sources de données (EDGAR et GBD) a été réalisée sur :

- Le code ISO à 3 lettres des pays (197 pays communs)
- L'année (période commune : 1980--2022)

Le dataset final contient *38 millions d'observations* après jointure complète, et *63 445 observations* après agrégation par pays-année.

#pagebreak()

= Analyse Exploratoire

== Distribution des émissions par polluant (TG13 -- Traitement)

La @fig-emissions-dist montre la distribution des émissions pour chaque polluant. On observe une forte asymétrie positive (skewness) pour tous les polluants, avec quelques pays émettant des quantités significativement supérieures à la moyenne mondiale.

#figure(
  image("data_understanding_files/data_understanding_41_1.png", width: 95%),
  caption: [Distribution des émissions par polluant (échelle logarithmique)],
) <fig-emissions-dist>

#pagebreak()

== Comparaison hommes/femmes

L'analyse par sexe révèle des différences significatives dans les taux de mortalité. Les hommes présentent des taux plus élevés pour la majorité des maladies respiratoires, notamment pour le cancer du poumon et les BPCO.

#figure(
  image("data_understanding_files/data_understanding_43_0.png", width: 95%),
  caption: [Comparaison des taux de mortalité par sexe],
) <fig-gender>

#pagebreak()

= Évolutions Temporelles

== Tendances des émissions 1980--2022 (TG23 -- Traitement)

#figure(
  image("data_understanding_files/data_understanding_45_0.png", width: 95%),
  caption: [Évolution temporelle des émissions mondiales par polluant],
) <fig-emissions-time>

*Observations clés :*

- Pics d'émissions en 1990 pour tous les polluants
- Tous les polluants semblent très corrélés
- L'Oxide de Carbone (CO) est le polluant le plus présent

== Tendances des décès 1980--2022 (TG23 -- Traitement)

#figure(
  image("data_understanding_files/data_understanding_46_0.png", width: 95%),
  caption: [Évolution temporelle des taux de mortalité par maladie],
) <fig-deaths-time>

*Observations clés :*

- Diminution globale des taux de mortalité pour les BPCO
- Stabilité relative du cancer du poumon
- Baisse significative de l'asthme mortel

#pagebreak()

= Analyse Géographique

== Pays les plus émetteurs (TG24 -- Restitution)

#figure(
  image("data_understanding_files/data_understanding_48_0.png", width: 95%),
  caption: [Top 15 des pays émetteurs (toutes émissions confondues)],
) <fig-top-emitters>

Les plus grands émetteurs sont la Chine, les États-Unis, l'Inde et la Russie, reflétant leur activité industrielle et leur population.

== Pays avec les taux de mortalité les plus élevés

#figure(
  image("data_understanding_files/data_understanding_49_0.png", width: 95%),
  caption: [Top 15 des pays par taux de mortalité respiratoire],
) <fig-top-deaths>

== Cartographie des maladies respiratoires (TG24 -- Restitution)

#figure(
  image("data_understanding_files/diseases_countries.png", width: 95%),
  caption: [Distribution géographique des taux de mortalité (cancer de la trachée et BPCO)],
) <fig-map-diseases>

*Observations :*

- Le cancer de la trachée présente des taux élevés en Europe de l'Est, Amérique du Nord et Océanie
- La BPCO touche particulièrement l'Asie du Sud-Est (Chine, Inde) et certains pays africains
- Les pays développés montrent des patterns différents selon la maladie

#pagebreak()

== Cartographie des émissions de polluants

#figure(
  image("data_understanding_files/pollutants_countries.png", width: 95%),
  caption: [Distribution géographique des émissions (PM2.5, PM10, NH3, OC)],
) <fig-map-pollutants>

*Observations :*

- La Chine et les États-Unis dominent pour tous les polluants
- Les particules fines (PM2.5, PM10) montrent des répartitions similaires
- L'ammoniac (NH3) est particulièrement élevé dans les pays à forte activité agricole (Inde, Chine, Brésil, États-Unis, Russie)
- Le carbone organique (OC) suit une distribution proche de celle des particules fines

#pagebreak()

= Analyse Sectorielle

== Secteurs d'activité (TG33 -- Traitement)

#figure(
  image("data_understanding_files/data_understanding_51_0.png", width: 95%),
  caption: [Top 10 des secteurs d'activité par émissions totales],
) <fig-sectors>

Les secteurs dominants sont :

- Transport routier
- Industrie manufacturière
- Production d'énergie
- Agriculture

== Relation secteur-polluant (TG34 -- Restitution)

#figure(
  image("data_understanding_files/data_understanding_52_1.png", width: 95%),
  caption: [Heatmap des émissions par secteur et polluant],
) <fig-sector-pollutant>

Cette heatmap révèle les associations secteur-polluant : le transport routier est associé aux NOx et CO, tandis que l'agriculture domine les émissions de NH3.

#pagebreak()

= Analyse des Corrélations

== Corrélations polluants-maladies (TG13 -- Traitement)

La matrice de corrélation entre polluants et maladies respiratoires constitue le cœur de cette étude exploratoire.

#figure(
  image("data_understanding_files/data_understanding_58_0.png", width: 95%),
  caption: [Matrice de corrélation : polluants vs maladies respiratoires],
) <fig-corr-pollutant-disease>

*Corrélations notables :*

- PM2.5 et PM10 montrent des corrélations positives modérées avec toutes les maladies
- NH3 et OC présentent les corrélations les plus fortes avec le cancer du poumon
- Les BPCO sont corrélées à la plupart des polluants

== Matrice de corrélation complète (TG14 -- Restitution)

#figure(
  image("data_understanding_files/data_understanding_59_0.png", width: 95%),
  caption: [Matrice de corrélation complète (polluants et maladies)],
) <fig-corr-full>

*Observations :*

- Forte multicolinéarité entre polluants (r > 0.8 pour la plupart)
- Les maladies sont également corrélées entre elles
- Ces corrélations suggèrent des facteurs communs (développement économique, urbanisation)
- Les BPCO semblent plus corrélées aux polluants que les autres maladies (notamment NMVOC, OC, PM10 et PM25)

== Relations détaillées -- scatter plots (TG14 -- Restitution)

#figure(
  image("data_understanding_files/data_understanding_61_0.png", width: 95%),
  caption: [Scatter plots : polluants clés vs maladies (échelle log)],
) <fig-scatter>

#pagebreak()

= Synthèse de l'Analyse Exploratoire

== Qualité des données

#figure(
  table(
    columns: 2,
    align: (left, center),
    stroke: (x, y) => if y == 0 { (bottom: 1pt) } else { none },
    table.header([*Critère*], [*Évaluation*]),
    [Complétude], [Excellente (> 99.99%)],
    [Couverture géographique], [197 pays],
    [Couverture temporelle], [43 ans (1980--2022)],
    [Cohérence des unités], [Vérifiée],
    [Outliers], [< 2% (à traiter)],
  ),
  caption: [Résumé de la qualité des données],
)

== Principales conclusions

+ *Corrélations significatives* : Des corrélations positives modérées existent entre les polluants atmosphériques et les maladies respiratoires, particulièrement pour les particules fines (PM2.5, PM10), les NVMOC, l'Oxide de Carbone et le cancer du poumon ainsi que les bronchopneumopathies chroniques obstructives (BPCO).

+ *Multicolinéarité* : Les polluants sont fortement corrélés entre eux, ce qui nécessitera une attention particulière lors de la modélisation (régularisation, réduction de dimension).

+ *Disparités géographiques* : Les pays en développement présentent des taux d'émission croissants tandis que les pays développés montrent des tendances à la baisse.

+ *Différences par sexe* : Les hommes sont plus touchés par les maladies respiratoires, avec des taux de mortalité 2 à 3 fois supérieurs pour le cancer du poumon.

+ *Évolution temporelle* : Malgré l'augmentation des émissions globales, les taux de mortalité standardisés tendent à diminuer, suggérant l'impact positif des avancées médicales.

== Recommandations pour la modélisation

- Appliquer une transformation logarithmique aux émissions
- Considérer une analyse en composantes principales (ACP) pour réduire la multicolinéarité
- Inclure des variables de contrôle (PIB, urbanisation, accès aux soins)
- Utiliser des modèles de panel pour exploiter la dimension temporelle
- Tester des modèles avec décalage temporel (lag) entre exposition et maladie

#pagebreak()

= Chaînes de valorisation

Trois chaînes de valorisation principales ont été identifiées pour cette phase d'exploration.

== Chaîne 1 -- Analyse des corrélations polluants-maladies

*Objectif :* Identifier les liens statistiques entre les émissions de polluants atmosphériques et les taux de mortalité par maladie respiratoire.

#set par(justify: false)

#figure(
  table(
    columns: (1fr, 2fr, 1fr),
    align: (left, left, left),
    stroke: (x, y) => if y == 0 { (bottom: 1pt) } else { none },
    table.header([*Tâche générique (TG)*], [*Tâches spécifiques (TS)*], [*Outils*]),
    [TG11 -- Collecte et Intégration],
    [Télécharger les données EDGAR (émissions) et GBD (mortalité), extraire les fichiers Excel/CSV],
    [Python (requests), Excel, CSV],

    [TG12 -- Préparation et Mise en qualité],
    [Harmoniser les noms de pays (ISO 3166), traiter les valeurs manquantes, uniformiser les unités],
    [Polars, Pandas],

    [TG13 -- Traitement et Analyse],
    [Calculer les matrices de corrélation, identifier les associations significatives],
    [Python (scipy, numpy), Omniscope],

    [TG14 -- Restitution et Visualisation],
    [Générer les heatmaps de corrélation, scatter plots polluant vs maladie],
    [Matplotlib, Seaborn, Omniscope],
  ),
  caption: [Chaîne 1 -- Corrélations polluants-maladies],
)

#figure(
  chaine-schema(
    taches-gen: ("Collecte", "Préparation", "Traitement", "Restitution"),
    taches-spec: (
      "Télécharger EDGAR",
      "Télécharger GBD",
      "Harmoniser pays",
      "Nettoyer valeurs",
      "Fusionner données",
      "Calculer corrél.",
      "Heatmaps",
      "Scatter plots",
    ),
    outils: ("Python, Excel", "Polars, Pandas", "Scipy, Omniscope", "Matplotlib, Omniscope"),
  ),
  caption: [Schéma de la chaîne 1 -- Corrélations polluants-maladies],
)

#pagebreak()

== Chaîne 2 -- Analyse géographique et temporelle

*Objectif :* Comprendre la distribution spatiale et l'évolution temporelle des émissions et de la mortalité respiratoire.

#figure(
  table(
    columns: (1fr, 2fr, 1fr),
    align: (left, left, left),
    stroke: (x, y) => if y == 0 { (bottom: 1pt) } else { none },
    table.header([*Tâche générique (TG)*], [*Tâches spécifiques (TS)*], [*Outils*]),
    [TG21 -- Collecte et Intégration], [Joindre les données EDGAR et GBD sur code ISO pays et année], [Polars (join)],

    [TG22 -- Préparation et Mise en qualité],
    [Agréger par pays-année, filtrer la période commune (1980-2022), 197 pays],
    [Polars (group\_by, filter)],

    [TG23 -- Traitement et Analyse],
    [Calculer les classements (top émetteurs, top mortalité), tendances temporelles],
    [Python (numpy, pandas), Omniscope],

    [TG24 -- Restitution et Visualisation],
    [Graphiques bar charts par pays, courbes d'évolution temporelle],
    [Matplotlib, Seaborn, Omniscope],
  ),
  caption: [Chaîne 2 -- Analyse géographique et temporelle],
)

#figure(
  chaine-schema(
    taches-gen: ("Collecte", "Préparation", "Traitement", "Restitution"),
    taches-spec: (
      "Joindre EDGAR",
      "Joindre GBD",
      "Agréger pays-an",
      "Filtrer période",
      "Classements",
      "Tendances temp.",
      "Bar charts",
      "Courbes évol.",
    ),
    outils: ("Polars (join)", "Polars, Pandas", "Numpy, Omniscope", "Matplotlib, Omniscope"),
  ),
  caption: [Schéma de la chaîne 2 -- Analyse géographique et temporelle],
)

#pagebreak()

== Chaîne 3 -- Analyse sectorielle des émissions

*Objectif :* Identifier les secteurs d'activité les plus polluants pour orienter les analyses et recommandations.

#figure(
  table(
    columns: (1fr, 2fr, 1fr),
    align: (left, left, left),
    stroke: (x, y) => if y == 0 { (bottom: 1pt) } else { none },
    table.header([*Tâche générique (TG)*], [*Tâches spécifiques (TS)*], [*Outils*]),
    [TG31 -- Collecte et Intégration],
    [Extraire les données EDGAR avec granularité sectorielle (IPCC categories)],
    [Python, Excel],

    [TG32 -- Préparation et Mise en qualité],
    [Regrouper les secteurs par catégorie IPCC, normaliser les noms],
    [Polars, Pandas, Omniscope],

    [TG33 -- Traitement et Analyse],
    [Calculer les émissions totales par secteur et polluant, identifier les associations secteur-polluant],
    [Python (numpy), Omniscope],

    [TG34 -- Restitution et Visualisation],
    [Heatmap secteur-polluant, bar charts des top secteurs],
    [Matplotlib, Seaborn, Omniscope],
  ),
  caption: [Chaîne 3 -- Analyse sectorielle],
)

#figure(
  chaine-schema(
    taches-gen: ("Collecte", "Préparation", "Traitement", "Restitution"),
    taches-spec: (
      "Extraire EDGAR",
      "Catég. IPCC",
      "Regrouper sect.",
      "Normaliser noms",
      "Émissions/sect.",
      "Assoc. sect-pol.",
      "Heatmap",
      "Top secteurs",
    ),
    outils: ("Python, Excel", "Polars, Omniscope", "Numpy, Omniscope", "Seaborn, Omniscope"),
  ),
  caption: [Schéma de la chaîne 3 -- Analyse sectorielle des émissions],
)

#set par(justify: true)

// =============================================================================
// PARTIE III : DATA PREPARATION
// =============================================================================

#part[Data Preparation]

= Jeux de données (rappel)

- *EDGAR* : #link("https://edgar.jrc.ec.europa.eu/")
- *GBD 2023* : #link("https://ghdx.healthdata.org/gbd-2023")

Pour plus de précisions, voir la section @sec-jeux-de-donnees.

= Extraction des données

Les données étant statiques et n'ayant pas pour but d'être récoltées périodiquement, elles ont simplement été téléchargées à la main depuis les sources respectives. Pour les données du dataset _EDGAR_, il a suffit de télécharger les différents fichiers Excel correspondant à chaque polluant sur le site de la Commission Européenne. Pour les données du dataset _GBD_, nous avons dû remplir plusieurs formulaires par paquets en prenant soin de sélectionner les mêmes critères de mesures afin de ne pas excéder les quotas, la réponse à notre demande d'extension des dits quotas étant arrivée assez tardivement.

#pagebreak()

= Prétraitement des données

== Fusion des données (TG41-43 -- Transformation)

La partie la plus considérable de l'étape de préparation des données s'est portée sur la création d'un dataset unique et cohérent à partir des données extraites. Ce travail a été effectué avant l'exploration des données : en effet, il est nécessaire de fusionner les données des différents datasets pour pouvoir les exploiter ensemble. Nous avons utilisé la bibliothèque _Polars_ de Python pour effectuer cette fusion. En effet, malgré notre plus grande maîtrise de la bibliothèque _Pandas_, nous avons choisi d'utiliser _Polars_ en raison de son efficacité et de sa capacité à gérer plus rapidement et efficacement des données relativement volumineuses. Cet outil, écrit en Rust, offre des performances bien supérieures et une syntaxe similaire à celle de _Pandas_ (bien que parfois plus complexe), ce qui facilite la transition entre les deux bibliothèques. Dans les cas où nos connaissances de Pandas pouvaient permettre des opérations plus rapides (e.g.: avec matplotlib ou seaborn), une simple conversion avec `df.to_pandas()` suffit.

Ainsi, polars a été utilisé pour effectuer les opérations suivantes :

#figure(
  ```python
  import polars as pl

  edgar_dirs = [d for d in Path('data/EDGAR').iterdir() if d.is_dir()]

  poll_dfs = {}

  for subdir in edgar_dirs:
      df = pl.read_excel(
          list(subdir.glob('*.xlsx'))[0], engine='calamine',
          read_options={"header_row": 9}
      )
      poll_dfs[code.lower()] = df

  edgar = pl.concat(
      [df.with_columns(pl.lit(name).alias("Pollutant")) for name, df in poll_dfs.items()],
      how="vertical"
  )
  ```,
  caption: [Extraction des données EDGAR avec Polars],
)

L'extraction des données GBD se fait de manière similaire. Un challenge a été les noms de pays : afin de fusionner les données EDGAR et GBD, nous devions joindre sur les années et les pays. Or, si EDGAR nous fournit des noms de pays en anglais et des codes ISO 3166-1 alpha-3, soit une catégorisation propre, GBD lui nous fournit des noms de pays en français mal traduit. En effet, même en naviguant le site en anglais avec un navigateur en anglais, le dataset GBD renvoie des noms de pays en français avec une traduction automatique. Ce qui donne des apostrophes mal encodés, des articles de manière aléatoire (e.g.: France, Espagne, mais "_La Chine_"). Cela nous a forcé à créer une table de traduction des noms de pays en français vers ceux en anglais, à la main, dans un dictionnaire `country_mapping` exporté dans un fichier CSV.

#pagebreak()

Une fois cela fait, il ne restait plus qu'à dépivoter les années du dataset EDGAR (qui étaient des colonnes au format `Y_NNNN`) et à fusionner les datasets, ce qui nous donne un énorme dataset qui regroupe sur une ligne pour chaque pays, chaque année, chaque polluant, chaque maladie et chaque industrie les émissions du polluant et les morts causés par la maladie. Ce dataset brut est intéressant pour une analyse préliminaire, mais il est nécessaire d'ensuite grouper les données simplement par pays, années et polluant pour obtenir un dataset plus exploitable.

#figure(
  ```python
  emissions_agg = (
      combined2
      .group_by(['gbd_location', 'Country_code_A3', 'year', 'Pollutant'])
      .agg(pl.col('emission_value').sum().alias('total_emission'))
      .pivot(on='Pollutant', index=['gbd_location', 'Country_code_A3', 'year'], values='total_emission')
  )

  ...

  correlation_data = emissions_agg.join(
      deaths_agg,
      on=['gbd_location', 'Country_code_A3', 'year'],
      how='inner'
  )

  correlation_data.write_parquet('data/combined/correlation_ready.parquet')
  ```,
  caption: [Agrégation du dataset combiné pour la corrélation],
)

#figure(
  ```
  Joined data for correlation: (8471, 17)

  Countries: 197

  Years: 43

  Countries with ISO codes: 197

  shape: (5, 17)
  ```,
  caption: [Joined data for correlation: (8471, 17)],
) <lst:joined_data>

C'est à partir de ce dataset que nous avons obtenu notre matrice de corrélation et c'est à partir de celui-ci que nous avons commencé à développer notre modèle.

== Stockage des données (TG44 -- Export)

Le dataset brut étant assez lourd, pour optimiser le stockage, nous avons utilisé le format _Parquet_ afin de pouvoir facilement stocker, charger et manipuler les données. Cela permettait en outre de rendre plus facile le partage de ces fichiers, évitant des fichiers CSV de plusieurs gigaoctets contre seulement quelques mégaoctets.

Le format _Parquet_, un format binaire ouvert, est particulièrement adapté à notre utilisation de Polars, étant donné qu'il est supporté nativement et peut donc être lu et transformé en dataframe d'un simple appel à la méthode `read_parquet`. Sa structure columnaire stocke les données par colonnes plutôt que par lignes, ce qui est idéal pour les opérations analytiques où seules certaines colonnes sont nécessaires, réduisant ainsi les entrées-sorties. Contrairement aux fichiers texte comme le CSV, le caractère binaire de Parquet permet une compression avancée et une lecture plus rapide.

#pagebreak()

= Préparation pour la modélisation

Une fois le dataset fusionné et stocké au format Parquet, les données doivent être préparées pour la modélisation prédictive. Cette étape comprend le chargement des données, l'application de transformations, la gestion des valeurs manquantes, la normalisation des features et la séparation train/test.

== Décalage temporel (Lag)

Un point clef de la préparation pour la modélisation est l'introduction d'un décalage temporel entre les émissions (variables explicatives) et les décès (variable cible). En effet, il existe un délai biologique entre l'exposition à la pollution atmosphérique et le développement de maladies respiratoires. Dans notre cas, les données sont préparées de telle sorte que les émissions de l'année $t$ prédisent les décès de l'année $t + "lag"$, où `lag` est le nombre d'années considérées.

Dans les faits, le décalage temporel a été testé et n'a pas permis d'améliorer les performances du modèle. Nous avons donc décidé de garder la fonctionnalité, mais de ne pas l'utiliser en choisissant un lag égal à zéro. Les résultats des tests de lag sont présentés ci-dessous :

#figure(
  ```text
  LAG ANALYSIS BY DISEASE
  ============================================================

  Random State: 1

  Lung Cancer:
      Lag 0 years | R² = 0.8567
      Lag 3 years | R² = 0.8625
      Lag 6 years | R² = 0.8720
      Lag 9 years | R² = 0.8660

    Pneumoconiosis:
      Lag 0 years | R² = 0.8058
      Lag 3 years | R² = 0.7868
      Lag 6 years | R² = 0.7367
      Lag 9 years | R² = 0.7928

    COPD:
      Lag 0 years | R² = 0.7937
      Lag 3 years | R² = 0.7811
      Lag 6 years | R² = 0.7924
      Lag 9 years | R² = 0.8119

  ...
  ```,
  caption: [Analyse des décalages temporels par maladie],
) <lst:lag_analysis>

Comme montré dans la sortie de script ci-dessus, les performances varient légèrement selon le décalage temporel choisi, mais aucun pattern consistant n'émerge. Un décalage de 0 années fournit un bon équilibre et reste notre choix par défaut.

#pagebreak()

== Gestion des valeurs manquantes (TG51 -- Préparation ML)

Le dataset combiné contient quelques valeurs manquantes dues aux enregistrements manquants pour les émissions de polluants dans certains pays certaines années.

Nous avons opté pour la stratégie la plus simple et la plus robuste : *supprimer les lignes contenant des valeurs manquantes*. Cette approche, bien qu'elle réduise la taille du dataset, garantit la qualité des données utilisées pour le modèle et évite les artefacts introduits par l'imputation. L'imputation remplace les valeurs manquantes par une estimation statistique fixe calculée sur l'ensemble de la colonne, comme la moyenne, la médiane ou la valeur la plus fréquente. L'interpolation est une autre méthode possible, elle consiste à deviner la valeur manquante en observant la tendance des valeurs voisines (juste avant et juste après), souvent de manière linéaire. Elle est particulièrement adaptée aux séries temporelles, mais peut introduire des artefacts si les données sont bruitées ou si la tendance n'est pas linéaire.

== Transformations des features (TG51 -- Préparation ML)

=== Transformation logarithmique

Les émissions de polluants présentent souvent une distribution asymétrique avec des valeurs aberrantes. Pour normaliser cette distribution et réduire l'influence des valeurs extrêmes, nous appliquons une transformation logarithmique :

$ x'_i = log(1 + x_i) $

où $x_i$ est l'émission du polluant $i$. La constante additive 1 (log1p) permet de gérer les valeurs zéro ou très proches de zéro sans générer d'erreurs numériques.

=== Normalisation des features

Après la transformation logarithmique, nous normalisons et réduisons toutes les features à l'aide d'un `StandardScaler` du framework de machine-learning _scikit-learn_. Cette normalisation ramène les features à une moyenne de 0 et un écart-type de 1 :

$ x'_i = (x_i - mu) / sigma $

où $mu$ et $sigma$ sont la moyenne et l'écart-type estimés sur l'ensemble d'entraînement. Cette étape est essentielle pour les modèles sensibles à l'échelle (régression linéaire, réseaux de neurones, etc.).

#pagebreak()

== Sélection des features et cibles

Pour la modélisation, nous utilisons les neuf polluants comme features explicatives :

- CO (Monoxyde de carbone)
- SO#sub[2] (Dioxyde de soufre)
- NO#sub[x] (Oxydes d'azote)
- NMVOC (Composés organiques volatils non méthaniques)
- PM#sub[2.5] (Particules fines)
- PM#sub[10] (Particules grossières)
- NH#sub[3] (Ammoniac)
- BC (Carbone noir)
- OC (Carbone organique)

Pour les cibles (variables à prédire), nous avons sélectionné trois maladies respiratoires principales basées sur l'analyse exploratoire :

- *Lung Cancer* : Cancer de la trachée, des bronches et des poumons
- *Pneumoconiosis* : Pneumoconiose
- *COPD* : Bronchopneumopathie chronique obstructive

Les deux autres maladies (Asthme et Autres maladies respiratoires chroniques) ont été exclues car l'analyse exploratoire n'a révélé aucune corrélation significative avec les polluants étudiés.

== Séparation train/test

Le dataset est divisé en deux ensembles :

- *Ensemble d'entraînement* (80%) : utilisé pour ajuster les paramètres du modèle et calibrer le `StandardScaler`
- *Ensemble de test* (20%) : utilisé pour évaluer les performances du modèle sur des données non vues pendant l'entraînement

Cette séparation en 80/20 est assez standard et permet une évaluation fiable des performances du modèle dans la grande majorité des cas.

== Implémentations

Deux versions de la pipeline de préparation ont été implémentées dans le module `model.data_prep` :

- *`prepare_data()`* : pour scikit-learn, retournant un objet `PreparedData` avec les arrays NumPy
- *`prepare_data_torch()`* : pour PyTorch, retournant un objet `PreparedDataTorch` avec les tensors PyTorch

Les deux versions partagent la même logique de préparation et de normalisation, garantissant la cohérence entre les deux frameworks.

== Analyse des scenarii

Le module inclut également des fonctions qui nous seront utiles dans la partie modélisation pour l'analyse de scenarii post-modélisation (`get_baseline_emissions()`, `create_scenario_features()`), permettant d'évaluer l'impact de réductions d'émissions sur la mortalité prédite. Cela facilite l'interprétabilité du modèle et le support à la décision.

#pagebreak()

= Chaîne de valorisation

Une chaîne de valorisation a été identifiée pour la phase de préparation des données, regroupant l'extraction, le nettoyage, la fusion et le stockage.

== Chaîne 4 -- Préparation et intégration des données

*Objectif :* Construire un dataset unifié, cohérent et optimisé à partir des sources EDGAR et GBD pour permettre les analyses exploratoires et la modélisation.

#set par(justify: false)

#figure(
  table(
    columns: (1fr, 2fr, 1fr),
    align: (left, left, left),
    stroke: (x, y) => if y == 0 { (bottom: 1pt) } else { none },
    table.header([*Tâche générique (TG)*], [*Tâches spécifiques (TS)*], [*Outils*]),
    [TG41 -- Extraction des données brutes],
    [Télécharger les fichiers Excel EDGAR (par polluant), télécharger les CSV GBD (par paquets, respect des quotas), charger les fichiers avec Polars],
    [Python, Polars, calamine],

    [TG42 -- Nettoyage et Harmonisation],
    [Créer le mapping des noms de pays FR→EN, harmoniser les codes ISO 3166-1 alpha-3, traiter les valeurs manquantes et les apostrophes mal encodées],
    [Polars, dictionnaire Python, CSV],

    [TG43 -- Transformation et Fusion],
    [Dépivoter les colonnes années EDGAR (Y\_NNNN), joindre EDGAR et GBD sur pays/année, agréger par pays/année/polluant pour la corrélation],
    [Polars (unpivot, join, group\_by, pivot)],

    [TG44 -- Stockage et Export],
    [Exporter les datasets en format Parquet (compression, performance), vérifier l'intégrité des données],
    [Polars (write\_parquet)],
  ),
  caption: [Chaîne 4 -- Préparation et intégration des données],
)

#figure(
  chaine-schema(
    taches-gen: ("Extraction", "Nettoyage", "Transform.", "Stockage"),
    taches-spec: (
      "Téléch. EDGAR",
      "Téléch. GBD",
      "Mapping pays",
      "Codes ISO",
      "Dépivoter années",
      "Joindre datasets",
      "Export Parquet",
      "Vérif. intégrité",
    ),
    outils: ("Polars, calamine", "Polars, Omniscope", "Polars, Omniscope", "Parquet"),
  ),
  caption: [Schéma de la chaîne 4 -- Préparation et intégration des données],
)

#set par(justify: true)

#pagebreak()

= Synthèse de la préparation des données

La préparation des données est une étape cruciale dans le processus qui doit aboutir à la modélisation. Une donnée mal préparée peut complètement ruiner un modèle. Il est donc capital de passer par les étapes de compréhension business, compréhension des données et de préparation des données, dans cet ordre. Bien qu'une partie de ce processus s'effectue dans le cadre de la compréhension des données, il faut noter que les objectifs sont différents : c'est pourquoi nous avons deux jeux de données : un pour l'exploration plus globale (plus fourni car encore à défricher) et un pour des observations plus fines et pour la modélisation (plus compact car déjà pré-traité). Le dataset utilisé pour la modélisation est le suivant :

#figure(
  ```
  Saved aggregated dataset: 8,471 rows × 17 columns
  File: data/combined/correlation_ready.parquet

  Columns: ['gbd_location', 'Country_code_A3', 'year', 'pm10', 'oc', 'nmvoc', 'nox', 'pm25', 'nh3', 'co', 'so2', 'bc', 'Asthme', 'Cancer de la trachée, des bronches et des poumons', 'Pneumoconiose', 'Autres maladies respiratoires chroniques', 'Maladie pulmonaire obstructive chronique']
  ```,
  caption: [Sortie du script de préparation des données et présentation du dataset final],
) <lst:final-dataset>
// =============================================================================
// PARTIE IV : MODELIZATION
// =============================================================================

#part[Modelization]

= Réflexions préliminaires

== Modèles, machine-learning et deep-learning

L'étape du modèle du framework CRISP-DM implique la réflexion autour de modèles mathématiques permettant d'exprimer des relations entre nos données, relations qui peuvent s'avérer complexes et difficiles à identifier à l'œil nu. Ces modèles plus ou moins complexes, peuvent notamment se baser sur des méthodes statistiques ou des approches d'apprentissage automatique. Ces modèles sont stochastiques, c'est-à-dire non-déterministes. Ainsi, deux exécutions du même modèle avec les mêmes données mais des initialisations différentes peuvent produire des résultats différents, d'où l'importance d'une graine aléatoire (`random_state`) fixée pour assurer la reproductibilité.

L'apprentissage automatique (_machine learning_) regroupe des algorithmes qui apprennent automatiquement à partir des données sans être explicitement programmés. Ces algorithmes cherchent à identifier des patterns dans les données pour faire des prédictions sur de nouvelles données. On distingue plusieurs catégories : la régression (prédire une valeur continue), la classification (prédire une catégorie), le clustering (grouper les données), etc. Des exemples courants incluent la régression linéaire, les arbres de décision, les forêts aléatoires et les machines à vecteurs de support (SVM). Ces modèles sont généralement interprétables et relativement rapides à entraîner.

L'apprentissage profond (_deep learning_) est un sous-ensemble du machine learning basé sur les réseaux de neurones artificiels (artificial neural networks). Contrairement aux modèles classiques, les réseaux de neurones apprennent des représentations hiérarchiques des données, où chaque couche du réseau transforme les données en abstractions de plus en plus complexes. Bien que les réseaux de neurones soient plus exigeants en termes de données et de puissance de calcul, ils peuvent capturer des relations non-linéaires très complexes et sont particulièrement efficaces pour les données de haute dimension.

Dans notre contexte de prédiction de mortalité due à la pollution, nous explorons à la fois des modèles classiques de machine learning (pour l'interprétabilité et la performance) et des approches de deep learning (pour la flexibilité et la capacité à modéliser des relations complexes potentiellement cachées dans les données). Nous avons de prime abord choisi cette approche à des fins éducatives : à la fois dans le but de pratiquer ces différentes techniques et d'identifier leurs différences une fois mis en application, mais également pour démontrer leurs forces et leurs faiblesses.

#pagebreak()

== Technologies choisies

Afin de mettre en œuvre un algorithme de machine learning, nous nous sommes dirigés vers la bibliothèque _scikit-learn_. _sklearn_, de son nom abrégé, est une bibliothèque Python open-source qui implémente de nombreux algorithmes de machine learning. C'est le standard dans l'industrie et du côté de la recherche pour le machine learning dit "classique", de la préparation des données à la modélisation. Scikit-learn et les algorithmes de machine learning qu'il implémente sont particulièrement adaptés aux problèmes de régression sur des données tabulaires comme le notre. _PyTorch_, quant à elle, est une bibliothèque Python open-source développée par Meta pour le deep learning.

PyTorch n'est a priori pas l'outil idéal pour traiter un problème de régression simple comme le notre : il peut fonctionner, mais l'intérêt des réseaux de neurones se situe dans leur capacité à représenter les données d'une manière beaucoup plus complexe, par exemple en utilisant des couches de convolution pour traiter des images. Ayant déjà travaillé avec ces deux bibliothèques, nous savons donc que PyTorch introduit une complexité supplémentaire qui n'est a priori pas nécessaire pour notre problème. Cependant, toujours pour des raisons éducatives, nous avons décidé de traiter les deux, avec un réseau de neurones basique pour PyTorch et un modèle d'arbres de décision pour scikit-learn. Nous aurons donc deux modèles, et en réalité plus que cela en raison des différentes variables cibles.

== Choix des variables

Dans un premier temps, les variables d'entrées, les features, étaient tous les polluants + les années. Après analyse, nous avons décidé d'exclure la variable temporelle (année) de l'ensemble d'entraînement. En effet, l'inclusion de l'année pourrait conduire le modèle à apprendre une simple tendance temporelle (tendance à la baisse de la mortalité due aux progrès médicaux) plutôt que la relation causale entre pollution et santé. Notre objectif étant d'isoler l'impact des polluants, nous avons privilégié une approche agnostique du temps. De même, nous avons décidé de ne pas garder l'Asthme et les autres maladies respiratoires, étant donné que la corrélation avec les variables d'entrées était autour de 0 voire légèrement en dessous. Nous nous sommes donc concentrés sur les bronchopneumopathies chroniques obstructives (BPCO), et dans une moindre mesure sur les cancers de la trachée et des poumons, ainsi que sur les pneumoconioses, qui avaient une corrélation positive avec les variables d'entrées.

== Méthodes d'évaluation d'un modèle

Il existe une multitude de méthodes pour évaluer de prime abord les performances d'un modèle. Les deux que nous verrons ici sont l'écart quadratique moyen (RMSE, pour _Root Mean Squared Error_) et le coefficient de détermination (R²). Le R² mesure la proportion de variance des données expliquée par le modèle : un R² de 1 indique un modèle parfait, tandis qu'un R² de 0 signifie que le modèle ne fait pas mieux que prédire la moyenne.

$ "RMSE" = sqrt(1/n sum_(i=1)^n (y_i - hat(y)_i)^2) $

$ R^2 = 1 - (sum_(i=1)^n (y_i - hat(y)_i)^2) / (sum_(i=1)^n (y_i - macron(y))^2) = 1 - "SS"_"res" / "SS"_"tot" $

- $hat(y)_i$ : la prédiction du modèle pour la donnée $i$
- $y_i$ : la valeur réelle de la donnée $i$
- $macron(y)$ : la moyenne des valeurs réelles

#pagebreak()

= Implémentation itérative des modèles

== Modèle de machine learning scikit-learn (TG52 -- Modélisation classique)

Dans un premier temps, le temps de calcul et l'écriture du code étant très rapide avec scikit-learn une fois nos données prétraitées et nos features/targets définies, nous avons décidé de comparer plusieurs algorithmes de machine learning pour trouver le meilleur modèle. Nous avons utilisé les algorithmes suivants :

- Ridge (régression linéaire)
- Forêts aléatoires
- Boost de Gradients

=== Ridge

Ridge est une extension de la régression linéaire classique. Dans la régression linéaire standard, on cherche à trouver une ligne (ou un hyperplan en haute dimension) qui minimise l'erreur entre les prédictions et les valeurs réelles. Cependant, lorsqu'on a de nombreuses features ou que les données sont bruitées, la régression linéaire peut _overfitter_ (sur-apprendre) en mémorisant le bruit des données d'entraînement au lieu de généraliser à de nouvelles données.

Ridge résout ce problème en ajoutant une pénalité (_regularization term_) à la fonction d'erreur. Cette pénalité décourage les coefficients du modèle de devenir trop grands. Intuitivement, cela force le modèle à être plus « conservateur » : au lieu de chercher à ajuster parfaitement chaque point de données, il accepte une légère erreur mais conserve des coefficients modérés et stables. Le paramètre $alpha$ contrôle la force de cette pénalité : une valeur faible permet aux coefficients d'être grands (plus proche de la régression linéaire classique), tandis qu'une valeur élevée les force à être petits.

=== Forêts aléatoires (Random Forests)

Les forêts aléatoires sont un ensemble (_ensemble learning_) d'arbres de décision. Un arbre de décision fonctionne en posant une série de questions sur les features (par exemple, « PM2.5 > 10 ? ») et en suivant les branches selon les réponses jusqu'à atteindre une prédiction. Bien que faciles à comprendre, un seul arbre a tendance à overfitter en créant trop de branches spécialisées.

Une forêt aléatoire construit des centaines d'arbres de décision, chacun entraîné sur un sous-ensemble aléatoire des données (avec remise) et utilisant des subsets aléatoires des features. Chaque arbre fait une prédiction, et la prédiction finale est la *moyenne* (pour la régression) ou le *vote majoritaire* (pour la classification) de tous les arbres. Cette approche d'ensemble réduit drastiquement l'overfitting car les erreurs d'apprentissage des arbres individuels se compensent mutuellement. De plus, les forêts aléatoires peuvent capturer des relations non-linéaires et des interactions entre features sans nécessiter d'ingénierie manuelle des features.

#pagebreak()

=== Gradient Boosting

Le Gradient Boosting (ou Boost de Gradients) fonctionne également en construisant un ensemble d'arbres, mais de manière séquentielle et intelligente. Contrairement aux forêts aléatoires où tous les arbres sont indépendants, le Gradient Boosting entraîne les arbres un par un. Chaque nouvel arbre est entraîné pour *corriger les erreurs* du modèle précédent en se concentrant sur les cas mal prédits.

Concrètement, le premier arbre fait une prédiction imparfaite. Le deuxième arbre apprend à prédire les « résidus » (les erreurs) du premier arbre. Le troisième arbre apprend les résidus du premier plus le deuxième, et ainsi de suite. À la fin, la prédiction finale est la somme des contributions de tous les arbres. Cette approche itérative permet au modèle d'améliorer graduellement ses prédictions, similaire à un processus d'apprentissage où on apprend de ses erreurs. Le Gradient Boosting est réputé pour sa haute performance sur de nombreuses tâches et peut capturer des relations très complexes.

=== Modèle retenu

Il n'est pas nécessaire à notre niveau de comprendre en détails comment fonctionne chaque modèle d'un point de vue théorique pour obtenir un résultat satisfaisant, au delà de ce qui a été évoqué précédemment. En revanche, il est tout de même nécessaire de faire un choix éclairé. Nous avons donc comparé ces modèles avec notre pipeline de préparation et une boucle très simple :

#figure(
  ```python
  results = {}
  for name, model in models.items():
      # Train
      model.fit(data.X_train, data.y_train)
      # Predict
      y_pred = model.predict(data.X_test)
      # Evaluate
      r2 = r2_score(data.y_test, y_pred)
      rmse = np.sqrt(mean_squared_error(data.y_test, y_pred))

      results[name] = {'model': model, 'r2': r2, 'rmse': rmse}
      print(f"{name:20s} | R² = {r2:.4f} | RMSE = {rmse:.1f}")
  ```,
  caption: [Comparaison des modèles scikit-learn],
)

Cette boucle nous donne la sortie suivante :

#figure(
  ```
  Ridge                | R² = 0.1564 | RMSE = 9188.9
  Random Forest        | R² = 0.7373 | RMSE = 5128.3
  Gradient Boosting    | R² = 0.7715 | RMSE = 4782.2
  ```,
  caption: [Comparaison des modèles scikit-learn (sortie de script)],
) <lst:sklearn-comparison-output>

Le modèle qui se démarque ici est celui du boost de gradient, qui présente un R² de 0.7715 et un RMSE de 4782.2. C'est donc le modèle que nous avons choisi pour notre analyse. On notera que le code scikit-learn est extrêmement simple et va droit au but. `model.fit()` pour entraîner le modèle et `model.predict()` pour obtenir les prédictions.

#pagebreak()

== Modèle de deep learning PyTorch (TG53 -- Modélisation Deep Learning)

=== Réseaux de neurones artificiels (ANN)

Les réseaux de neurones artificiels (ANN) sont des modèles de machine learning organisés en couches. Ils sont constitués d'une entrée, d'une ou plusieurs couches cachées (_hidden layers_) et d'une couche de sortie. Chaque couche est composée de neurones qui sont connectés entre eux par des poids et des biais déterminés lors de l'entraînement. Les neurones sont activés par une fonction d'activation qui permet de moduler la sortie du neurone en fonction de sa somme pondérée d'entrée. Les neurones combinent linéairement leurs entrées ($z = w dot x + b$) avant d'appliquer une fonction d'activation qui introduit de la non-linéarité.

Les fonctions d'activation sont essentielles pour permettre aux réseaux de neurones de capturer des relations non-linéaires. Sans elles, même un réseau multicouche ne serait qu'une combinaison linéaire inutile. Pour les couches cachées, nous utilisons :

- *Linéaire* : définie par $f(z) = z$. Elle ne transforme pas l'entrée et est utilisée dans la couche de sortie pour les problèmes de régression (comme notre prédiction de mortalité), où nous voulons une sortie continue non bornée. Bien qu'il n'y ait pas de transformation non-linéaire, la couche de sortie possède toujours des *poids* et des *biais* qui sont appris durant l'entraînement. Cette couche combine linéairement les activations de la couche cachée précédente selon $y = W dot h + b$, où $W$ est la matrice des poids et $b$ est le vecteur de biais.
- *ReLU (Rectified Linear Unit)* : définie par $f(z) = max(0, z)$. Elle retourne 0 si l'entrée est négative, sinon retourne l'entrée telle quelle. C'est la fonction la plus populaire pour les couches cachées car elle est simple, rapide à calculer, et encourage la parcimonie des activations.

#figure(
  image("img/ann.jpg", width: 85%),
  caption: [Artificial Neural Network (ANN)],
)

Le processus d'apprentissage comporte deux phases : la *propagation avant* (_forward pass_) et la *rétropropagation* (_backpropagation_).

Lors de la propagation avant, une donnée d'entrée traverse le réseau couche par couche. Chaque neurone reçoit les activations de la couche précédente, les multiplie par ses poids, ajoute son biais, puis applique sa fonction d'activation. Cette sortie devient l'entrée des neurones de la couche suivante, jusqu'à atteindre la couche de sortie qui produit la prédiction finale.

Ensuite, on compare la prédiction avec la vraie valeur pour calculer l'erreur (loss). La rétropropagation calcule comment cette erreur dépend de chaque poids et biais du réseau en utilisant la dérivation en chaîne. Ces gradients indiquent dans quelle direction chaque poids doit être ajusté pour réduire l'erreur.

L'entraînement suit un processus itératif :

+ *Propagation avant* : passer les données à travers le réseau pour obtenir une prédiction
+ *Calcul de l'erreur* : comparer la prédiction avec la vraie valeur (ex. : erreur quadratique moyenne)
+ *Rétropropagation* : calculer les gradients via la dérivation en chaîne
+ *Mise à jour des poids* : ajuster les poids et biais dans la direction opposée au gradient (descente de gradient) avec un pas d'apprentissage (_learning rate_) qui contrôle la taille des ajustements

Ce cycle est répété sur plusieurs _epochs_ (passes complètes sur les données) jusqu'à convergence du modèle, c'est-à-dire quand l'erreur se stabilise. Un learning rate trop élevé peut faire _diverger_ le modèle (la loss explose au lieu de diminuer), tandis qu'un learning rate trop faible ralentit la convergence. Des problèmes d'_overfitting_ peuvent survenir lorsque le modèle est trop complexe ou entraîné trop longtemps : il mémorise le bruit des données d'entraînement au lieu de généraliser. Ce principe s'applique à tous les modèles de machine learning. C'est pour résoudre cela qu'il faut ajuster les hyperparamètres (learning rate, epochs, régularisation, etc.).

#figure(
  image("img/over_underfitting.png", width: 85%),
  caption: [Overfitting et Underfitting : illustration des deux extrêmes],
)

#pagebreak()

=== Notre modèle d'ANN

#figure(
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
  ```,
  caption: [Notre ANN],
)

C'est le modèle le plus basique que nous puissions définir. Il est composé de deux couches cachées avec une fonction d'activation ReLU entre chaque couche. En effet, nous ne traitons pas de données catégorielles et notre dataset n'est pas très complexe ou volumineux : nous travaillons sur un problème de régression avec des données numériques tabulaires.

=== Boucle d'entraînement

Avec PyTorch, contrairement à scikit-learn, nous devons définir nous-mêmes la boucle d'entraînement :

#figure(
  ```python
  def train_model(data, epochs=500, lr=0.001):
      model = MLP(data.n_features)
      optimizer = torch.optim.Adam(model.parameters(), lr=lr)
      loss_fn = nn.MSELoss()

      loader = DataLoader(
          TensorDataset(data.X_train, data.y_train.unsqueeze(1)),
          batch_size=64, shuffle=True
      )

      for epoch in range(epochs):
          for X_batch, y_batch in loader:
              optimizer.zero_grad()
              loss = loss_fn(model(X_batch), y_batch)
              loss.backward()
              torch.nn.utils.clip_grad_norm_(model.parameters(), max_norm=1.0)
              optimizer.step()
      return model
  ```,
  caption: [Boucle d'entraînement de notre modèle],
)

Nous avons choisi un optimiseur Adam et l'erreur quadratique moyenne (MSE) comme fonction de perte.

#pagebreak()

= Implémentation finale et résultats

== Implémentation

=== Implémentation PyTorch : ANN

L'implémentation PyTorch est celle présentée dans la section précédente. Pour rappel :

#figure(
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
  ```,
  caption: [Notre ANN (rappel)],
)

=== Implémentation scikit-learn : GradientBoostingRegressor

#figure(
  ```python
  for disease in DISEASES:
      from data_prep import FEATURES
      data = prepare_data(target_disease=disease, lag_years=0, feature_names=FEATURES)

      # fine tuned for COPD with gridsearchCV
      model = GradientBoostingRegressor(n_estimators=300, max_depth=7, learning_rate=0.1, random_state=20)
      model.fit(data.X_train, data.y_train)

      r2 = r2_score(data.y_test, model.predict(data.X_test))

      models[disease] = {'model': model, 'r2': r2, 'data': data}

      short_name = DISEASE_SHORT_NAMES[disease]
      print(f"{short_name:25s} | R² = {r2:.4f}")
  ```,
  caption: [Modèle scikit-learn final],
)

=== Problèmes rencontrés

Nous avons dû adapter notre modèle pour contrer l'overfitting présent dans notre configuration initiale des hyperparamètres. Nous avons utilisé GridSearchCV afin de tester plusieurs combinaisons et de déterminer les meilleurs hyperparamètres pour le modèle de régression gradient boosting, en nous concentrant en particulier sur les BPCO. Une fois cela fait, nous avons pu obtenir des résultats plus satisfaisants.

Toutefois, nous nous sommes heurtés à un problème assez classique en machine learning. Notre modèle est assez précis et il est très bon pour l'interpolation des données, c'est-à-dire pour prédire des valeurs dans une plage de valeurs connues. En revanche, les modèles basés sur des arbres de décisions sont très mauvais en ce qui concerne la prédiction des valeurs hors de la plage de valeurs connues, c'est-à-dire l'extrapolation. Nous avons donc un modèle relativement simple et performant, mais limité pour l'étape suivante qui consistait à créer des scenarii.

== Résultats (TG54 -- Évaluation)

En effet, notre modèle de régression gradient boosting (GB) a obtenu un R² assez satisfaisant pour les données de test. Ce résultat est satisfaisant car il indique que notre modèle est capable de prédire correctement les valeurs dans une plage de valeurs connues.

#figure(
  ```
  GRADIENT BOOSTING - ALL DISEASES
  ==================================================
  Lung Cancer               | R² = 0.9232
  Pneumoconiosis            | R² = 0.8054
  COPD                      | R² = 0.9007

  ==================================================
  TOP 5 POLLUTANTS PER DISEASE
  ==================================================
  Lung Cancer               | so2 (25%), nh3 (17%), nox (13%), oc (10%), co (9%)
  Pneumoconiosis            | oc (16%), nh3 (15%), nmvoc (13%), pm10 (12%), nox (12%)
  COPD                      | nh3 (18%), oc (18%), nmvoc (15%), so2 (10%), nox (10%)
  ```,
  caption: [Résultats du modèle de régression gradient boosting],
)

Le modèle a identifié des liens entre des polluants spécifiques et les maladies respiratoires, sans nécessiter de connaissances préalables sur les mécanismes physiologiques sous-jacents.

Nous pouvons également observer quelles features ont été les plus importantes pour notre modèle de régression GB. Cette information est capitale, c'est elle qui nous permet de comprendre quelles variables ont le plus d'influence sur la prédiction de la maladie respiratoire.

#pagebreak()

En ce qui concerne notre modèle ANN, nous avons des résultats un peu moins probants à première vue :

#figure(
  ```
  PYTORCH MLP - ALL DISEASES
  ==================================================
  Lung Cancer               | R² = 0.8718
  Pneumoconiosis            | R² = 0.9558
  COPD                      | R² = 0.6374
  ```,
  caption: [Résultats du modèle ANN],
) <lst:ann_results>

En particulier, le modèle se retrouve en difficulté à prédire les bronchopneumopathies chroniques obstructives (COPD). Cela peut être attribué à la complexité des mécanismes physiologiques impliqués dans ces maladies et à la nécessité d'un modèle plus sophistiqué pour prendre en compte ces interactions.

== Prédictions (TG61-64 -- Simulation de scenarii)

Une fois les modèles entraînés et évalués, nous les avons utilisés pour effectuer des prédictions sur des scenarii hypothétiques de réduction des émissions de polluants. L'objectif est de simuler l'impact de politiques environnementales sur la mortalité due aux maladies respiratoires.

=== Analyse de scenarii

Nous avons défini plusieurs scenarii de réduction des émissions sur 10 ans par rapport aux niveaux actuels (année de référence : 2022) :

- *Niveau actuel* : 100% des émissions (baseline)
- *Réduction de 5%* : 95% des émissions
- *Réduction de 10%* : 90% des émissions
- *Réduction de 20%* : 80% des émissions

Pour chaque scénario, nous appliquons le multiplicateur correspondant aux émissions moyennes de l'année de référence, puis nous utilisons les modèles entraînés pour prédire le taux de mortalité associé à chaque maladie. Cela permet d'estimer les bénéfices potentiels en termes de santé publique d'une réduction des émissions polluantes.

#pagebreak()

=== Résultats des prédictions -- Gradient Boosting

#figure(
  image("img/predictions_gb.png", width: 100%),
  caption: [Prédictions des taux de mortalité selon les scenarii de réduction -- Gradient Boosting],
)

Les prédictions du modèle Gradient Boosting présentent des incohérences notables. Pour le cancer du poumon, une réduction de 20% des émissions entraîne paradoxalement une augmentation de la mortalité prédite, ce qui est contre-intuitif. Les prédictions pour la pneumoconiose et la BPCO sont également erratiques et ne suivent pas une tendance logique de diminution avec la réduction des émissions. Ces résultats mettent en évidence les limites du modèle Gradient Boosting pour ce type d'analyse prospective.

=== Résultats des prédictions -- Réseau de neurones (ANN)

#figure(
  image("img/predictions_ann.png", width: 100%),
  caption: [Prédictions des taux de mortalité selon les scenarii de réduction -- ANN],
)

Les prédictions du réseau de neurones sont globalement plus cohérentes. On observe une tendance générale à la diminution de la mortalité avec la réduction des émissions, ce qui correspond à l'intuition médicale et épidémiologique. On note toutefois une légère anomalie pour la pneumoconiose, où les réductions de 5% et 10% produisent des prédictions légèrement supérieures au niveau actuel avant de diminuer pour des réductions plus importantes. Malgré cette irrégularité mineure, le modèle ANN capture mieux la relation attendue entre émissions et mortalité.

=== Interprétation et limites

Ces résultats illustrent plusieurs points importants :

- Les modèles de machine learning, même performants en interpolation (sur des données similaires au set d'entraînement), peuvent échouer en extrapolation (sur des données hors distribution). C'est particulièrement vrai pour les méthodes basées sur les arbres (Gradient Boosting) qui sont par nature limitées aux bornes vues lors de l'entraînement (fonction en escalier), contrairement aux réseaux de neurones qui approximent une fonction continue.
- Le réseau de neurones semble mieux généraliser la relation sous-jacente entre émissions et mortalité, offrant une "pente" de réduction plus cohérente.
- Les prédictions doivent être interprétées avec prudence : elles ne constituent pas des prévisions épidémiologiques précises, mais plutôt des indications de tendances potentielles.
- D'autres facteurs non modélisés (politiques de santé, évolution démographique, progrès médicaux) influencent également la mortalité.

#pagebreak()

= Implémentation dans Omniscope

Dans le cadre de NF21, nous avons appris à utiliser #link("https://visokio.com/omniscope/")[Omniscope], outil de _Business Intelligence (BI)_ permettant notamment de créer des tableaux de bord interactifs. C'est l'usage principal que nous en avons fait au cours de nos séances de travaux pratiques, mais dans le cadre de ce projet, nous pouvons utiliser Omniscope pour implémenter des modèles statistiques. En effet, dans la partie permettant la préparation des données, il est possible d'ajouter des blocs de la catégorie _Analytics_ afin d'appliquer des modèles de machine learning sur les données préparées.

== Portage de la pipeline de préparation

La première étape consiste à répliquer notre pipeline de préparation des données dans Omniscope. Nous avons tout d'abord voulu utiliser le fichier Parquet généré par notre script Python, étant donné qu'Omniscope supporte nativement ce format de fichier. Cependant, il semble que notre fichier contienne des métadonnées qui ne sont pas supportées par Omniscope. Qu'à cela ne tienne, nous avons repris nos fichiers `edgar.csv` et `gbd.csv` et avons recréé la pipeline de préparation des données en utilisant les blocs natifs d'Omniscope. Nous avons pu gagner du temps en réutilisant ces fichiers déjà traités et en nous basant sur les processus déjà créés. Le résultat est le même que celui obtenu avec notre script Python, à savoir un dataset agrégé par pays et par année, avec les polluants et les maladies respiratoires.

#figure(
  image("img/omni_data_prep.png", width: 100%),
  caption: [Pipeline de préparation des données dans Omniscope],
)

Nous avons chargé le dataset GBD ainsi qu'un fichier contenant les traductions de pays afin d'éviter les problèmes rencontrés plus tôt. Nous avons chargé le dataset EDGAR, dépivoté et renommé les années puis nous avons corrigé les types de données des deux datasets, agrégé les données par pays et par année puis avons fusionné les deux datasets sur les colonnes pays et année. Enfin, nous n'avons gardé que les décès comme métrique et les BPCO comme maladie cible.

#pagebreak()

== Modèles de régression dans Omniscope

#figure(
  image("img/omni_model_pipeline.png", width: 100%),
  caption: [Modèle de régression dans Omniscope],
)

À partir de ces données, nous avons pu utiliser les blocs de modèles prédéfinis dans la partie _Analytics_. Nous avons choisi d'utiliser le modèle appelé _Regression_, car c'était plus ou moins le seul qui correspondait à notre besoin. Ce bloc se base sur du code _R_ que nous ne pouvons malheureusement pas inspecter et modifier nous-mêmes. Il propose deux types de régressions : "Regression" et "Adaptive Spline Regression (MARS)". Le premier type propose trois modèles : _Linear Regression_, _Logistic Regression_ et _Count Regression_. Nous pouvons cocher les trois et le code se chargera de choisir le meilleur modèle lui-même. Nous avons seulement à choisir notre variable cible et nos variables d'entrée.

#figure(
  image("img/omni_model_details.png", width: 100%),
  caption: [Configuration du modèle de régression dans Omniscope],
)

#pagebreak()

Nous avons testé les deux solutions. La solution MARS n'a pas fonctionné : la boucle d'entraînement du modèle ne s'est jamais arrêtée, ce qui suggère un problème de convergence que le modèle de Regression classique n'a – a priori – pas. Comme nous n'avons aucun contrôle sur les hyperparamètres, nous nous contenterons du modèle de régression qui fonctionne. Nous lui avons fourni un split 80/20 de nos données pour l'entraînement et le test. Nous obtenons après entraînement un R² de 0.79 avec le modèle _Linear Regression_, ainsi que les données brutes de prédiction et des données permettant de visualiser l'impact des variables d'entrée sur la variable cible. Avec les données brutes, nous créons un bloc de concaténation avec les données du split test afin de comparer les prédictions avec les valeurs réelles. Cela nous permet de créer le dashboard suivant :

#figure(
  image("img/omni_dashboard.png", width: 100%),
  caption: [Dashboard Omniscope des prédictions],
)

On observe en effet que les prédictions sont relativement proches des valeurs réelles. Néanmoins, on reste dans le cadre de nos valeurs de test, et non dans un cadre d'extrapolation comme pour nos scenarii de réduction des émissions. Un problème que nous avons rencontré est qu'avec Omniscope, il n'est pas possible d'exporter le modèle entraîné pour l'utiliser en dehors de l'outil. Nous ne pouvons donc pas utiliser ce modèle pour faire des prédictions sur nos scenarii de réduction des émissions, ce qui limite grandement l'intérêt de cette implémentation. À la place, nous allons devoir ré-entraîner le même modèle en mettant nos extrapolations comme données de test, ce qui n'est pas optimal car le modèle n'aura pas vu de telles données lors de l'entraînement.

#pagebreak()

== Prédictions des scenarii dans Omniscope

Nous avons donc ré-entraîné notre modèle de régression dans Omniscope en utilisant nos données de scenarii comme données de test. Afin d'obtenir des données de scenarii, nous avons créé un bloc _Custom Python script_ (on aurait tout aussi bien pu utiliser _R_) afin de créer un dataset avec des émissions réduites de 15% sur 10 ans par rapport à l'année de référence.

#figure(
  image("img/omni_python.png", width: 100%),
  caption: [Création des données de scenarii dans Omniscope],
)

Les blocs Python d'Omniscope sont relativement simples à utiliser, les données en entrée et en sortie sont des DataFrames Pandas, ce qui rend leur manipulation aisée. Nous avons ensuite relié ce bloc au bloc de modèle de régression afin d'obtenir les prédictions sur ces nouvelles données.

Le résultat est le suivant :

#figure(
  image("img/omni_scenario_results.png", width: 100%),
  caption: [Résultats des prédictions des scenarii dans Omniscope],
)

Le modèle n'a pu prédire qu'une simple baisse linéaire de la mortalité en fonction de la réduction des émissions, ce qui est cohérent avec le modèle de régression linéaire utilisé. Cependant, cette droite semble indiquer plutôt une tendance générale qu'une prédiction précise, car rien ne nous dit que la mortalité due aux BPCO diminue de manière parfaitement linéaire avec la réduction des émissions dans la réalité. Néanmoins, cela illustre bien comment Omniscope peut être utilisé pour implémenter des modèles statistiques et effectuer des analyses de scenarii, même si les capacités sont limitées par rapport à une implémentation complète en Python ou R. La conclusion générale et les interprétations que l'on peut en faire sont les mêmes que pour les modèles précédents : il faut rester prudent dans l'interprétation des résultats et considérer les limites des modèles utilisés.

== Pertinence d'Omniscope pour la modélisation

Omniscope offre une interface conviviale pour la préparation des données et l'implémentation de modèles statistiques, ce qui peut être avantageux pour les utilisateurs non spécialisés en programmation. Cependant, ses capacités de modélisation sont limitées comparées à des bibliothèques dédiées comme scikit-learn ou PyTorch. L'impossibilité d'exporter les modèles entraînés restreint leur utilisation dans des analyses plus complexes. Ainsi, Omniscope est pertinent pour des analyses exploratoires, des tableaux de bord interactifs, ou encore pour de la modélisation légère.

#pagebreak()

= Chaînes de valorisation

Deux chaînes de valorisation ont été identifiées pour la phase de modélisation.

== Chaîne 5 -- Entraînement et évaluation des modèles prédictifs

*Objectif :* Construire, entraîner et évaluer des modèles de machine learning pour prédire la mortalité respiratoire à partir des données d'émissions de polluants.

#set par(justify: false)

#figure(
  table(
    columns: (1fr, 2fr, 1fr),
    align: (left, left, left),
    stroke: (x, y) => if y == 0 { (bottom: 1pt) } else { none },
    table.header([*Tâche générique (TG)*], [*Tâches spécifiques (TS)*], [*Outils*]),
    [TG51 -- Préparation ML],
    [Charger le dataset Parquet, appliquer la transformation log, normaliser avec StandardScaler, séparer train/test (80/20)],
    [Polars, scikit-learn, Omniscope],

    [TG52 -- Modélisation classique],
    [Entraîner GradientBoostingRegressor, optimiser les hyperparamètres avec GridSearchCV, extraire l'importance des features],
    [scikit-learn, Omniscope],

    [TG53 -- Modélisation deep learning],
    [Définir l'architecture MLP (64→32→1), entraîner avec Adam et MSE loss, ajuster learning rate et epochs],
    [PyTorch],

    [TG54 -- Évaluation et sélection],
    [Calculer R² et RMSE sur test set, comparer les performances GB vs ANN, sauvegarder les modèles, créer dashboard],
    [scikit-learn, PyTorch, joblib, Omniscope],
  ),
  caption: [Chaîne 5 -- Entraînement et évaluation des modèles],
)

#figure(
  chaine-schema(
    taches-gen: ("Préparation ML", "Modèle class.", "Modèle DL", "Évaluation"),
    taches-spec: (
      "Charger Parquet",
      "Normaliser",
      "Gradient Boost",
      "GridSearchCV",
      "Définir MLP",
      "Entraîner",
      "Calculer R²",
      "Dashboard",
    ),
    outils: ("Polars, Omniscope", "sklearn, Omniscope", "PyTorch", "joblib, Omniscope"),
  ),
  caption: [Schéma de la chaîne 5 -- Entraînement et évaluation des modèles],
)

#pagebreak()

== Chaîne 6 -- Simulation de scenarii de réduction des émissions

*Objectif :* Exploiter les modèles entraînés pour simuler l'impact de politiques de réduction des émissions sur la mortalité respiratoire et produire des recommandations de santé publique.

#figure(
  table(
    columns: (1fr, 2fr, 1fr),
    align: (left, left, left),
    stroke: (x, y) => if y == 0 { (bottom: 1pt) } else { none },
    table.header([*Tâche générique (TG)*], [*Tâches spécifiques (TS)*], [*Outils*]),
    [TG61 -- Définition des scenarii],
    [Établir les niveaux de référence (2022), définir les taux de réduction (5%, 10%, 20%), générer les vecteurs d'émissions simulées],
    [Python (numpy), Omniscope],

    [TG62 -- Prédiction prospective],
    [Charger les modèles sauvegardés, appliquer les scalers aux données simulées, effectuer les prédictions pour chaque scénario],
    [scikit-learn, PyTorch, joblib, Omniscope],

    [TG63 -- Analyse comparative],
    [Calculer les variations de mortalité prédites, comparer les résultats GB vs ANN, identifier les incohérences d'extrapolation],
    [Python (pandas, numpy)],

    [TG64 -- Restitution décisionnelle],
    [Générer les graphiques de prédiction par scénario, synthétiser les recommandations, documenter les limites du modèle],
    [Matplotlib, Omniscope, Typst],
  ),
  caption: [Chaîne 6 -- Simulation de scenarii],
)

#figure(
  chaine-schema(
    taches-gen: ("Définition", "Prédiction", "Analyse", "Restitution"),
    taches-spec: (
      "Niveau réf. 2022",
      "Taux réduction",
      "Charger modèles",
      "Prédire mortalité",
      "Calc. variations",
      "Comparer GB/ANN",
      "Graphiques",
      "Recommand.",
    ),
    outils: ("numpy, Omniscope", "sklearn, Omniscope", "pandas, numpy", "Matplotlib, Omniscope"),
  ),
  caption: [Schéma de la chaîne 6 -- Simulation de scenarii de réduction des émissions],
)

#set par(justify: true)

// =============================================================================
// PARTIE V : EVALUATION
// =============================================================================

#part[Evaluation]

= Évaluation des modèles

L'évaluation rigoureuse d'un modèle de machine learning est une étape cruciale avant toute utilisation opérationnelle. Cette section synthétise les principes généraux d'évaluation et les méthodes appliquées dans notre projet.

== Principes généraux d'évaluation

L'évaluation d'un modèle prédictif repose sur plusieurs axes complémentaires :

+ *Séparation des données* : La première règle fondamentale est de ne jamais évaluer un modèle sur les données ayant servi à l'entraîner. La séparation train/test (typiquement 80/20 ou 70/30, nous avons opté pour 80/20) permet de mesurer la capacité de généralisation du modèle sur des données inédites.

+ *Validation croisée* : Pour des évaluations plus robustes, la validation croisée (k-fold cross-validation) divise les données en k sous-ensembles, entraîne k modèles en utilisant k-1 sous-ensembles pour l'entraînement et 1 pour la validation, puis moyenne les scores obtenus. Cette technique réduit la variance de l'estimation des performances.

+ *Métriques adaptées* : Le choix des métriques dépend du type de problème. Pour la régression, on utilise typiquement :
  - Le *R²* (coefficient de détermination) : indique la proportion de variance expliquée
  - Le *RMSE* (Root Mean Squared Error) : erreur quadratique moyenne, sensible aux outliers
  - Le *MAE* (Mean Absolute Error) : erreur absolue moyenne, plus robuste aux outliers

+ *Analyse des résidus* : L'examen de la distribution des erreurs permet de détecter des biais systématiques (sous-estimation ou surestimation dans certaines plages de valeurs).

== Méthodes appliquées dans notre projet

Dans le cadre de ce projet, nous avons appliqué les méthodes suivantes :

- *Séparation train/test 80/20* : Le dataset de 8 471 observations a été divisé aléatoirement avec une graine fixe (random\_state) pour assurer la reproductibilité.

- *Évaluation sur données de test* : Les métriques R² et RMSE ont été calculées uniquement sur l'ensemble de test, garantissant une estimation non biaisée des performances.

- *Comparaison de modèles* : Plusieurs algorithmes (Ridge, Random Forest, Gradient Boosting, ANN) ont été comparés sur les mêmes données pour identifier le plus performant.

- *Optimisation des hyperparamètres* : GridSearchCV a été utilisé pour le Gradient Boosting afin de trouver la meilleure combinaison d'hyperparamètres (n\_estimators, max\_depth, learning\_rate).

- *Test d'extrapolation* : Au-delà des métriques classiques, nous avons testé la cohérence des prédictions sur des scenarii hors distribution (réductions d'émissions), révélant les limites de certains modèles.

#pagebreak()
== Limites de notre évaluation

Plusieurs limitations doivent être soulignées :

- *Pas de validation croisée formelle* : Nous n'avons pas implémenté de cross-validation (k-fold, par exemple), ce qui pourrait légèrement biaiser l'estimation des performances.

- *Données non temporellement séparées* : Le split train/test est aléatoire et non temporel. Pour des prévisions prospectives, un split temporel (entraînement sur années anciennes, test sur années récentes) aurait pu être une option envisageable.

- *Absence de validation externe* : Nos modèles n'ont pas été validés sur des données provenant d'autres sources, par un souci de disponibilité, ce qui limiterait la confiance que l'on pourrait avoir si on venait à vouloir généraliser nos résultats.

// =============================================================================
// PARTIE VI : DEPLOYMENT
// =============================================================================


#part[Deployment]

= Déploiement du modèle

*Note importante :* Dans le cadre de ce projet académique, le modèle n'a pas été déployé en production. Cette section présente néanmoins les étapes et considérations nécessaires pour un éventuel déploiement, à titre informatif et pédagogique.

== Sauvegarde et sérialisation du modèle

Avant tout déploiement, le modèle entraîné doit être sauvegardé dans un format permettant son rechargement ultérieur. Deux approches sont couramment utilisées :

- *Pour scikit-learn* : La bibliothèque `joblib` permet de sérialiser les modèles avec `joblib.dump(model, 'model.joblib')`. Le modèle peut ensuite être rechargé avec `joblib.load()`.

- *Pour PyTorch* : Les poids du réseau sont sauvegardés avec `torch.save(model.state_dict(), 'model.pt')`. Il faut également sauvegarder l'architecture du modèle et les paramètres de prétraitement (scaler, transformations).

== Architecture de déploiement

Plusieurs architectures sont envisageables selon les besoins :

=== API REST

L'approche la plus courante consiste à exposer le modèle via une API REST. Des frameworks comme *FastAPI* ou *Flask* permettent de créer rapidement un service web :

#figure(
  ```python
  from fastapi import FastAPI
  import joblib

  app = FastAPI()
  model = joblib.load('model.joblib')
  scaler = joblib.load('scaler.joblib')

  @app.post("/predict")
  async def predict(emissions: dict):
      features = scaler.transform([list(emissions.values())])
      prediction = model.predict(features)
      return {"mortality_rate": float(prediction[0])}
  ```,
  caption: [Exemple d'API REST avec FastAPI],
)

Une fois le serveur lancé, l'API peut être interrogée via une simple requête HTTP (cURL, Postman, ou script client). Voici un exemple d'appel :

#figure(
  ```bash
  curl -X POST "http://localhost:8000/predict" \
       -H "Content-Type: application/json" \
       -d '{"pm25": 12.5, "nox": 24.1, "so2": 3.2, "nmvoc": 10.5, ...}'
  ```,
  caption: [Simulation d'appel API],
)

Le serveur répondrait alors par une prédiction au format JSON : `{"mortality_rate": 154.2}`.

=== Conteneurisation Docker

Pour garantir la reproductibilité de l'environnement d'exécution, le service peut être conteneurisé avec Docker. Un Dockerfile typique inclurait Python, les dépendances (requirements.txt), le code de l'API et les fichiers du modèle sauvegardé.

=== Déploiement cloud

Les plateformes cloud offrent plusieurs options :

- *AWS* : Amazon SageMaker pour le ML managé, ou EC2/Lambda pour un contrôle total
- *GCP* : Vertex AI ou Cloud Run pour les conteneurs
- *Azure* : Azure Machine Learning ou Azure Container Instances

=== Intégration dans un Dashboard Omniscope

Comme nous l'avons souligné dans la partie modélisation, le fait que l'on ne puisse pas sauvegarder, recharger, ré-entraîner et réutiliser un modèle dans Omniscope est un problème majeur dans l'optique d'un déploiement continu et d'une mise en production réelle. En revanche, avec un modèle développé au moins en dehors d'Omniscope et exposé via une API REST, il est possible de contourner ce problème. C'est ici qu'Omniscope peut briller : ses fonctionnalités de visualisation et de paramétrage interactif permettent de créer un dashboard qui peut être connecté à un modèle externe via une API REST.

Une stratégie de déploiement efficace consisterait donc à utiliser Omniscope comme interface de visualisation connectée à notre modèle externe :

+ *Calcul déporté* : Le modèle Python entraîné (GB ou ANN), exposé via l'API décrite ci-dessus, assure la logique de prédiction.
+ *Interface Omniscope* : Un dashboard permet à l'utilisateur de définir des scénarii (ex: baisse de 10% de SO#sub[2]) via des paramètres interactifs.
+ *Connexion* : Un script Python embarqué dans Omniscope ou un connecteur API envoie ces variables au serveur de prédiction.
+ *Visualisation* : Omniscope récupère la réponse JSON et met à jour les indicateurs (cartes, graphes) en temps réel.

Cette architecture permet de contourner l'obligation d'utiliser les modèles internes "boîte noire" de l'outil BI, tout en offrant une expérience utilisateur fluide, à l'instar d'une intégration PowerBI avec Azure ML. Cela permettrait de facilement déployer la solution en production, tout en permettant une certaine flexibilité et évolutivité. On peut imaginer une future version où d'autres leviers peuvent être actionnés pour prédire des scenarii : il suffit alors de quelques ajustements dans le script python et d'ajouter les nouvelles variables dans le dashboard, pour un rendu globalement transparent pour l'utilisateur.

== Déploiement de notre modèle

Notre modèle n'a pas été déployé : cela ne fait pas partie du cadre de l'UE NF21, le livrable principal étant ce rapport. Cependant, nous avons présenté les étapes et considérations nécessaires pour un déploiement, à titre informatif et pédagogique.

// =============================================================================
// PARTIE VII : CONCLUSION
// =============================================================================

#part[Conclusion]


Ce projet a permis d'explorer la relation entre les émissions de polluants atmosphériques et la mortalité liée aux maladies respiratoires à l'échelle mondiale. En suivant la méthodologie CRISP-DM, nous avons parcouru l'ensemble du cycle de vie d'un projet de data science : compréhension du contexte métier, exploration des données, préparation, modélisation et évaluation.

Les principaux résultats montrent des corrélations significatives entre certains polluants (NH#sub[3], OC, SO#sub[2], PM) et les maladies respiratoires, notamment les BPCO et le cancer du poumon. Les modèles de machine learning développés (Gradient Boosting et réseaux de neurones) atteignent des performances satisfaisantes en interpolation (R² > 0.80), mais présentent des limites en extrapolation ainsi que dans l'interprétation que l'on peut tirer des résultats.

Ce travail illustre à la fois le potentiel et les précautions nécessaires lors de l'utilisation de modèles prédictifs pour des décisions de santé publique. Les corrélations observées ne peuvent être interprétées comme des relations causales, et les prédictions prospectives doivent être considérées comme des indications de tendances plutôt que des prévisions précises.

// =============================================================================
// ANNEXES
// =============================================================================


#set page(numbering: "i")
#counter(page).update(1)
#set heading(numbering: (..nums) => {
  numbering("I.", ..nums)
  h(0.3cm)
})


#part[Annexes]

= Références

- EDGAR v8.0 : #link("https://edgar.jrc.ec.europa.eu/")
- GBD 2023 : #link("https://ghdx.healthdata.org/gbd-2023")
- Méthodologie CRISP-DM : #link("https://moodle.utt.fr/pluginfile.php/13371/mod_resource/content/1/CRISP-DM.pdf")
- Gradient Boosting : #link("https://en.wikipedia.org/wiki/Gradient_boosting")
- Ridge Regression : #link("https://en.wikipedia.org/wiki/Ridge_regression")
- Multilayer Perceptron : #link("https://en.wikipedia.org/wiki/Multilayer_perceptron")
- Coefficient de détermination (R²) : #link("https://fr.wikipedia.org/wiki/Coefficient_de_détermination")
- scikit-learn API reference : #link("https://scikit-learn.org/stable/api/index.html")
- PyTorch Documentation : #link("https://pytorch.org/docs/stable/index.html")
- Polars API reference : #link("https://docs.pola.rs/api/python/dev/reference/index.html")

= Ressources

- GitHub repository : #link("https://github.com/malcolm-a/nf21_respiratory_diseases")


= Remerciements

- *Dr. Babiga BIRREGAH* (enseignant-chercheur UTT) — encadrement et conseils méthodologiques
- *Magali COLIN* (intervenante UTT) — tutoriels Omniscope et support technique
- *Aurélie VAN* (infirmière) — relecture médicale et corrections de la nomenclature

#pagebreak()

= Table des figures

#outline(title: none, target: figure.where(kind: image))

#pagebreak()


= Table des tables

#outline(
  title: none,
  target: figure.where(kind: table),
)

= Table des extraits de code

#outline(
  title: none,
  target: figure.where(kind: raw),
)

