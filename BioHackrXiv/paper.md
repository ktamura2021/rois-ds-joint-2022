---
title: 'Comparison of the ortholog finder tools in plant genes'
tags:
  - Life Sciences
  - Genetics and Genomics
  - Plant Sciences
  - Bioinformatics
authors:
  - name: Keita Tamura
    orcid: 0000-0002-6198-4336
    affiliation: 1
  - name: Hirokazu Chiba
    orcid: 0000-0003-4062-8903
    affiliation: 2
  - name: Hiromasa Ono
    orcid: 0000-0001-8675-963X
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

Among the various biological resources, ortholog information can play a central role in integrating the biological data of multiple species [@Chiba2015]. Various orthology finding tools are available, but they provide different results.
It is important to examine the difference for plant research. Although a benchmarking tool such as LEMOrtho (https://lemortho.ezlab.org) [@orthodb] by using the standardized gene sets for the comparison of various orthology finding tools is available, it is also important to compare such tools by picking up some specific genes of interest.
Here, we selected five plant genes with different degree of conservation and focusing on Arabidopsis (*Arabidopsis thaliana*) and soybean (*Glycine max*) to figure out the differences of orthology finding tools. 

# Hackathon results

## Genes used for the analysis

We selected four genes from Arabidopsis and one gene from soybean (Table 1) for the analysis.
The first two genes from Arabidopsis (CAS1 and PDS3) are essential genes for plants. CAS1 is a cycloartenol synthase, which is necessary for the production of essential plant sterols [@corey1993isolation], and PDS3 is phytoene desaturase, which is needed for the production of carotenoids, the essential pigments in various physiological processes in plants including photosynthesis [@qin2007disruption].
The latter three genes are related to the production of specialized metabolites. PAP1 (production of anthocyanin pigment 1) is a MYB transcription factor (also known as AtMYB75) involving the regulation of anthocyanin biosynthesis [@borevitz2000activation].
CYP716A1 and CYP93E1 are cytochrome P450 monooxygenases involving triterpenoid biosynthesis. CYP716A1 is one of the CYP716A subfamily members, which is widely isolated from various plant species, involving the oxidization pentacyclic triterpene skeletons including beta-amyrin at C-28 position [@yasumoto2016novel]. 
On the other hand, CYP93E subfamily members have been isolated only from Fabaceae plants [@seki2015p450s]. Soybean CYP93E1 is catalyzing the oxidization of beta-amyrin and sophoradiol at C-24 position [@shibuya2006identification].

Table: Gene list

| NCBI Gene ID | Locus tag | Gene symbol |
| ------------ | --------- | ----------- |
| 815275 | AT2G07050 | CAS1 |
| 827061 | AT4G14210 | PDS3 |
| 842120 | AT1G56650 | PAP1 |
| 833607 | AT5G36110 | CYP716A1 |
| 100037459 | GLYMA_08G350800 | CYP93E1 |

## Tools used for analysis 
OMA (https://omabrowser.org) [@oma], OrthoDB (https://www.orthodb.org) [@orthodb], Ortholog Database at PGDBj (http://pgdbj.jp) [@asamizu2014plant], and Ensembl Plants (https://plants.ensembl.org) [@yates2022ensembl] were used to retrieve orthology information. However, as the Ortholog Database at PGDBj is not maintained since September 2016, and the source is an outdated version of RefSeq (RefSeq Release 66, July 15, 2014), we did not analyze PGDBj in detail.

### OMA
Fhe following query was used to retrieve orthologs from OMA.
```
PREFIX oo: <http://purl.org/net/orth#>
PREFIX upTax: <http://purl.uniprot.org/taxonomy/>

SELECT DISTINCT ?member1 ?member2
WHERE {
  ?group oo:hasHomologousMember+ ?member1 , ?member2 .
  ?group oo:hasTaxonomicRange upTax:33090 . # Viridiplantae
  ?member1 a oo:Protein .
  ?member2 a oo:Protein .
  ?member1 oo:organism <https://omabrowser.org/oma/genome/3702> .
  ?member2 oo:organism <https://omabrowser.org/oma/genome/3847> .
}
```
Several taxonomic ranges were used: Viridiplantae (green plants, taxonomy ID 33090), Embryophyta (land plants, taxonomy ID 3193), and rosids (taxonomy ID 71275).

### OrthoDB
Fhe following query is used to retrieve orthologs from OrthoDB.
```
PREFIX orthodb: <http://purl.orthodb.org/>
PREFIX upTax: <http://purl.uniprot.org/taxonomy/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX up: <http://purl.uniprot.org/core/>
PREFIX obo: <http://purl.obolibrary.org/obo/>

SELECT DISTINCT ?entrez_id1 ?entrez_id2
WHERE {
  ?group orthodb:ogBuiltAt upTax:71240 . # eudicots
  ?group orthodb:hasMember ?member1 , ?member2 .
  ?member1 rdfs:seeAlso ?member_entrez1 ;
      up:organism ?odb_organism1 .
  ?member2 rdfs:seeAlso ?member_entrez2 ;
      up:organism ?odb_organism2 .
  ?odb_organism1 obo:RO_0002162 upTax:3702 . # Arabi
  ?odb_organism2 obo:RO_0002162 upTax:3847 . # soy
  ?member_entrez1 a orthodb:Entrez ;
      rdfs:label ?entrez_id1 .
  ?member_entrez2 a orthodb:Entrez ;
      rdfs:label ?entrez_id2 .
}
```
Several taxonomic ranges were used: Viridiplantae (green plants, taxonomy ID 33090), Embryophyta (land plants, taxonomy ID 3193), and eudicotyledons (eudicots, taxonomy ID 71240).

### Ensembl Plants
Pairs of orthologous genes (55,356 gene pairs) between Arabidopsis and soybean were retreaved from the FTP site of Ensembl Plants release 54 (http://ftp.ebi.ac.uk/ensemblgenomes/pub/plants/release-54/tsv/ensembl-compara/homologies/glycine_max/Compara.107.protein_default.homologies.tsv.gz), and extracted the pairs related to the five genes for analysis.

## Comparison of the tools

We first compared the effects of taxonomic range for orthology detection in OMA and OrthoDB (Figure 1). As the smallest taxonomic group containing both Arabidopsis and soybean is rosits (OMA) and eudicotyledons (OrthoDB), we tested the these smallest shared taxonomic group as well as Embryophyta (land plants) and Viridiplantae (green plants). In both tools, the higher taxonomic group datasets identified more ortholog pairs, however, this is not observed as incremental manner. 

![Number of ortholog pairs (Arabidopsis–soybean) in different orthologous groups using OMA (left) and OrthoDB (right). Numbers in the parentheses indicate total ortholog pairs identified in each level of the tool.](./Fig1.png)

![Number of ortholog pairs (Arabidopsis–soybean) between three different tools. OMA and OrthoDB are analysed at green plants level (left) or land plants level (right). Numbers in the parentheses indicate total ortholog pairs identified in each level of the tool.](./Fig2.png)

We also compared the number of ortholog pairs (Arabidopsis–soybean) among OMA, OrthoDB, and Ensembl plants (Figure 2). OMA and OrthoDB were analyzed at the level of green plants or land plants. The highest number of ortholog pairs was found in OrthoDB, followed by Ensembl Plants, which had almost half as many pairs as OrthoDB.

Next, we compared the orthology detection in the three tools by focusing the five plant genes (Figure 1). The results are shown in Figures 2–6. In each table, OMA and OrthoDB (ODB) shows the results in green plants and land plants, separated by comma (green plants, land plants). In addition, N/A in Gene description indicates the locus tag not found in NCBI Gene.

For the identified orthologs of AT2G07050 (CAS1) in soybean, GLYMA_01G001300 was identified in all conditions (Table 2). OMA and OrthoDB identified more orthologs in green plants than in land plants. Especially, OrthoDB in green plants identified 10 orthologs. GLYMA_07G001300 and GLYMA_08G225800 are characterized as beta-amyrin synthase [@takagi2011manipulation], while GLYMA_08G027000 and GLYMA_20G192700 are characterized as lupeol synthase [@PPR568134]. Cycloartenol synthase, beta-amyrin synthase, and lupeol synthase are classified as oxidosqualene cyclase. Therefore, it is suggested that green plants in OrthoDB classified these different types of oxidosqualene cyclases in one group.

The identified orthologs of AT4G14210 (PDS3) in soybean were identical among tools and taxonomic levels (Table 3). GLYMA_18G003900 is a functionally characterized PDS in soybean [@bartley1991molecular], and GLYMA_18G003900 is annotated as its palalog in SoyBase (https://www.soybase.org).


Table: Identified orthologs of AT2G07050 (CAS1) in soybean.

| Locus tag | NCBI Gene ID | Gene symbol | OMA | ODB | EP |
| --------- | ------------ | ----------- | :---: | :---: | :---: |
| GLYMA_01G001300 | 548054 | | Y,Y | Y,Y | Y |
| GLYMA_01G001500 | 100784662 | | Y,N | Y,Y | N |
| GLYMA_03G121300 | 100809670 | | N,N | Y,N | N |
| GLYMA_03G121500 | 100810544 | | N,N | Y,N | N |
| GLYMA_07G001300 | 547702 | AMS1 | N,N | Y,N | N |
| GLYMA_08G027000 | 100794151　| | N,N | Y,Y | N |
| GLYMA_08G225800 | 100778398　| | N,N | Y,N | N |
| GLYMA_15G065600 | 100797878　| | N,N | Y,N | N |
| GLYMA_15G101800 | 100781065　| | N,N | Y,N | N |
| GLYMA_15G223600 | N/A　| N/A | Y,N | N,N | N |
| GLYMA_20G192700 | 100810400　| | N,N | Y,Y | N |


Table: Identified orthologs of AT4G14210 (PDS3) in soybean.

| Locus tag | Gene description | OMA | ODB | EP |
| --------- | ---------------- | :---: | :---: | :---: |
| GLYMA_11G253000 | 15-cis-phytoene desaturase, chloroplastic/chromoplastic | Y,Y | Y,Y | Y |
| GLYMA_18G003900 | phytoene desaturase | Y,Y | Y,Y | Y |


Table: Identified orthologs of AT1G56650 (PAP1) in soybean.

| Locus tag | Gene description | OMA | ODB | EP |
| --------- | ---------------- | :---: | :---: | :---: |
| GLYMA_07G037700 | transcription factor MYB8 | N,N | Y,Y | N |
| GLYMA_07G141100 | transcription factor MYB1 | N,N | Y,Y | N |
| GLYMA_09G234900 | transcription factor MYB1 | N,N | Y,Y | Y |
| GLYMA_09G235000 | N/A                       | N,N | N,N | Y |
| GLYMA_09G235100 | R2R3 MYB transcription factor | N,N | Y,Y | Y |
| GLYMA_09G235300 | transcription factor MYB1 | N,N | Y,Y | Y |
| GLYMA_13G226800 | transcription factor MYB1 | N,N | Y,Y | N |
| GLYMA_15G176000 | transcription factor MYBZ1 | N,N | Y,Y | N |
| GLYMA_16G007100 | transcription factor MYB1 | N,N | Y,Y | N |
| GLYMA_18G191200 | transcription factor MYB1 | N,N | Y,Y | N |
| GLYMA_18G261700 | N/A                        | N,N | N,N | Y |
| GLYMA_18G262000 | transcription repressor MYB6 | N,N | Y,Y | Y |
| GLYMA_19G025000 | transcription factor MYB114 | N,N | Y,Y | Y |


Table: Identified orthologs of AT5G36110 (CYP716A1) in soybean.

| Locus tag | Gene description | OMA | ODB | EP |
| --------- | ---------------- | :---: | :---: | :---: |
| GLYMA_05G166900 | beta-amyrin 28-monooxygenase | Y,Y | N,Y | N |
| GLYMA_05G170400 | beta-amyrin 28-monooxygenase | Y,Y | N,N | N |
| GLYMA_05G220500 | beta-amyrin 28-monooxygenase | Y,Y | Y,Y | Y |
| GLYMA_08G026900 | beta-amyrin 28-monooxygenase | Y,Y | Y,Y | Y |
| GLYMA_08G125000 | beta-amyrin 28-monooxygenase | Y,Y | N,Y | N |
| GLYMA_08G125100 | beta-amyrin 28-monooxygenase | Y,Y | N,Y | N |
| GLYMA_08G243600 | beta-amyrin 28-monooxygenase | Y,Y | Y,Y | N |


Table: Identified orthologs of GLYMA_08G350800 (CYP93E1) in Arabidopsis.

| Locus tag | Gene description | OMA | ODB | EP |
| --------- | ---------------- | :---: | :---: | :---: |
| AT2G42250 | cytochrome P450, family 712, subfamily A, polypeptide 1 | N,N | Y,Y | N |
| AT5G06900 | cytochrome P450, family 93, subfamily D, polypeptide 1 | N,N | Y,Y | N |
| AT5G06905 | cytochrome P450, family 712, subfamily A, polypeptide 2 | N,N | Y,Y | N |


The identified orthologs of AT1G56650 (PAP1) in soybean were different between the tools (Table 4). OMA did not identified any orthologs, while OrthoDB and Ensembl Plants identified 11 and seven orthologs, respectively. As GLYMA_09G235000 and GLYMA_18G261700 were not included in the OrthoDB v10.1, OrthoDB identified all of the orthologs identified in Ensembl Plants.
The previous phylogenetic analysis of soybean MYB proteins identified seven genes clustered together with PAP1 (AtMYB75); namely, GmMYB192 (GLYMA_07G141100), GmMYB227 (GLYMA_09G235100), GmMYB241 (GLYMA_09G235300), GmMYB155 (GLYMA_18G191200), GmMYB008 (GLYMA_18G261700), GmMYB080, (GLYMA_18G262000), and GmMYB096 (GLYMA_19G025000) [@du2012genome].
OrthoDB identified all of these genes.

For AT5G36110 (CYP716A1), OMA identified seven orthologs, OrthoDB identified six (land plants) or three (green plants) orthologs, and Ensembl Plants identified two orthologs (Table 5). GLYMA_05G220500 and GLYMA_08G026900 were identified in all of the tools. In soybean, three CYP716A, three CYP716D, and one CYP716G subfamily genes are reported [@guttikonda2010whole].
By comparing the phylogenetic trees reported by [@guttikonda2010whole] and [@khatri2022comprehensive], and UniRef50 (UniProt Reference Clusters) of AT5G36110 (CYP716A1) contains three soybean entries including GLYMA_08G026900 and GLYMA_05G220500, it is expected that GLYMA_05G220500, GLYMA_08G026900, and GLYMA_08G043600 are the three CYP716A genes, and GLYMA_05G166900, GLYMA_08G125000, and GLYMA_08G125100 are the three CYP716D genes (the locus tag for one CYP716G gene is unknown).
OrthoDB (green plants) and Ensembl plants identified all or two of the three CYP716A genes, while OMA and OrthoDB (land plants) identified all of the CYP716A as well as CYP716D genes.

Finally, for GLYMA_08G350800 (CYP93E1), only OrthoDB identified orthologs in soybean (Table 6). In Arabidopsis, a single CYP93 family gene (CYP93D1) is known, and the two CYP712A subfamily genes are relatively close relathionship to CYP93 [@bak2011cytochromes]. OrthoDB clustered these Arabidopsis P450s together, while OMA and Ensembl Plants did not.


# Discussion

We compared the search results of OMA, OrthoDB, PGDBj, and Ensembl Plants for five plant genes. We observed substantial difference of the results among the tools. PGDBj seems to detect many paralogs compared to others. OMA and OrthoDB has functionality of controlling the taxonomic range for orthology detection, and changing the range affected the search results. In some cases, the effect of the taxonimc range makes it difficult to interpret the search results by practical scientists. By manual inspection of the results, we confirmed that OrthoDB produces reasonable results at the current status.


# Future work
The orthology relations will be utilized within RefEx ([https://refex.dbcls.jp](https://refex.dbcls.jp)), a web-based tool that facilitates browsing of reference gene expression. The RefEx project is presently engaged in the development of a successor website (RefEx2), which will incorporate expression datasets from a range of species. The survey findings will constitute a significant resource for the RefEx2 website, which aims to establish links between each gene search result and its orthologous association with related plant or other species.

# GitHub repository
https://github.com/hchiba1/rois-ds-joint-tamura

# Acknowledgements
We thank the organizes and participants of BH22.9 (domestic biohackathon in Japan) for giving us the chance to discuss on this issue.
This work was supported by ROIS-DS-JOINT (003RP2022) to K.Tamura.

# References
