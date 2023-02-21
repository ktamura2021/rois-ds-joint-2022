---
title: 'Comparison of the ortholog finder tools in plant genes'
tags:
  - Life Sciences
  - Genetics and Genomics
  - Plant Sciences
  - Bioinformatics
authors:
  - name: Keita Tamura
    orcid: 0000-0000-0000-0000
    affiliation: 1
  - name: Hirokazu Chiba
    orcid: 0000-0000-0000-0000
    affiliation: 2
  - name: Hiromasa Ono
    orcid: 0000-0000-0000-0000
    affiliation: 2

affiliations:
 - name: Hiroshima University, Higashihiroshima, Hiroshima, Japan
   index: 1
 - name: Database Center for Life Science, Joint Support-Center for Data Science Research, Research Organization of Information and Systems, Kashiwa, Chiba, Japan
   index: 2
date: 01 January 2023
bibliography: paper.bib
authors_short: Keita Tamura & Hirokazu Chiba \emph{et al.}
group: BioHackrXiv
event: DBCLS domestic BioHackathon Kochi, Japan, 2022
biohackathon_name: "BH22.9"
biohackathon_url: "https://wiki.lifesciencedb.jp/mw/BH22.9"
biohackathon_location: "Kochi, Japan, 2022"
---

# Abstract

Orthologous genes for five plant genes are obtained using several orthology finder tools and the results are compared with each other, to figure out the differences of those tools.

Keywords: Arabidopsis, Orthologs, Soybean

# Introduction

Among the various biological resources, ortholog information can play a central role in integrating the biological data of multiple species [@Chiba2015].
Various orthology finding tools ara available, but they provide different results.
It is important to examine the difference for plant research.

Here, we selected five plant genes to figure out the differences of orthology finding tools 

# Hackathon results

## Genes used for the analysis

We selected four genes from *A. thaliana* and one gene from *G. max* (Table 1) for the analysis. The first two genes from *A. thaliana* (CAS1 and PDS3) are well-known genes conserved among higher plants. The latter two genes from *A. thaliana* (PAP1 and CYP716A1) and *G. max* CYP93E1 are genes involving the production of specialized metabolites. PAP1 is ... CYP716A1 is ... On the other hand, CYP93E1 is ...

| NCBI Gene ID | Locus tag | Gene symbol | Gene description |
| -------- | -------- | -------- | -------- |
| 815275 | AT2G07050 | CAS1 | cycloartenol synthase 1 |
| 827061 | AT4G14210 | PDS3 | phytoene desaturase 3 |
| 842120 | AT1G56650 | PAP1 | production of anthocyanin pigment 1 |
| 833607 | AT5G36110 | CYP716A1 | cytochrome P450, family 716, subfamily A, polypeptide 1 |
| 100037459 | GLYMA_08G350800 | CYP93E1 | beta-amyrin and sophoradiol 24-hydroxylase |

## Tables, figures and so on

Please remember to introduce tables (see Table 1) before they appear on the document. We recommend to center tables, formulas and figure but not the corresponding captions. Feel free to modify the table style as it better suits to your data.

Table 1
| Header 1 | Header 2 |
| -------- | -------- |
| item 1 | item 2 |
| item 3 | item 4 |

Remember to introduce figures (see Figure 1) before they appear on the document. 

![BioHackrXiv logo](./biohackrxiv.png)
 
Figure 1. A figure corresponding to the logo of our BioHackrXiv preprint.

# Other main section on your manuscript level 1

Feel free to use numbered lists or bullet points as you need.
* Item 1
* Item 2

# Discussion

We compared the results from OMA, OrthoDB, PGDBj, and Ensembl Plants.

# Future work
The conclusion will be generalized to other genes of plant species.
The orthology relations will be used in RefEx service.

# GitHub repository
https://github.com/hchiba1/rois-ds-joint

# Acknowledgements
We thank the participants of BH22.9 (domestic biohackathon in Japan) for giving us the chance to discuss on this issue.

# References
