#!/bin/Rscript

library(tidyverse)
df <- read_csv("SraRunTable_PRJEB32665.csv")

df_select <- df %>% select(Run, Age, BioSample, Developmental_stage, Ecotype, `Experimental_Factor:_developmental_stage (exp)`, `Experimental_Factor:_organism_part (exp)`, `Experimental_Factor:_sampling_site (exp)`, External_Id, Genotype, organism_part, Organism, Sampling_site)

df_select <- df_select %>% arrange(BioSample)

# Extract BioSample
df_biosample <- df_select %>% select(BioSample) %>% distinct()
# Create RefexSampleId
df_refexsampleid <- paste("RES0000", seq(3791, 3791 + 55), sep = "") %>% as_tibble_col(column_name = "RefexSampleId")
# Join two columns
df_biosample <- bind_cols(df_biosample, df_refexsampleid)

# Add RefexSampleId to the sample table
df_select_refexsampleid <- df_select %>% left_join(df_biosample, by = "BioSample") %>% relocate(RefexSampleId)
# Count NumberOfSamples
df_count <- df_select_refexsampleid %>% count(RefexSampleId)
# Add NumberOfSamples
df_select_refexsampleid <- df_select_refexsampleid %>% left_join(df_count, by = "RefexSampleId") %>% rename(NumberOfSamples = n) %>% relocate(RefexSampleId, NumberOfSamples)

# Create grouped sample table
df_grouped <- df_select_refexsampleid %>% select(-Run) %>% distinct() %>% write_tsv("Arabidopsis_Nat_2020_refextable_grouped_sample.tsv")
# Create sampleID mapping
df_idmap <- df_select_refexsampleid %>% select(RefexSampleId, Run) %>% distinct() %>% write_tsv("Arabidopsis_Nat_2020_refextable_sampleID_mapping.tsv")



sessionInfo()

