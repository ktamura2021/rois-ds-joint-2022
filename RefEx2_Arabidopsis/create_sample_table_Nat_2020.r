#!/bin/Rscript

library(tidyverse)
df <- read_csv("SraRunTable_PRJEB32665.csv")

df_select <- df %>% select(Run, Age, BioSample, Developmental_stage, Ecotype, `Experimental_Factor:_developmental_stage (exp)`, `Experimental_Factor:_organism_part (exp)`, `Experimental_Factor:_sampling_site (exp)`, External_Id, Genotype, organism_part, Organism, Sampling_site)

df_select <- df_select %>% arrange(BioSample)

write_csv(df_select, "sample_table_Arabidopsis_Nat_2020.csv")

sessionInfo()

