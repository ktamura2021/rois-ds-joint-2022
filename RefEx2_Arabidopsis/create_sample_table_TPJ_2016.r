#!/bin/Rscript

library(tidyverse)
df1 <- read_csv("SraRunTable_PRJNA314076.csv")
df2 <- read_csv("SraRunTable_PRJNA324514.csv")
df <- bind_rows(df1, df2)

df_select <- df %>% select(Run, BioSample, Ecotype, Organism, `Sample Name`, Tissue, dev_stage, Age, Treatment)
df_select <- df_select %>% arrange(BioSample)

# Extract BioSample
df_biosample <- df_select %>% select(BioSample) %>% distinct()
# Create RefexSampleId
df_refexsampleid <- paste("RES0000", seq(3706, 3706 + 84), sep = "") %>% as_tibble_col(column_name = "RefexSampleId")
# Join two columns
df_biosample <- bind_cols(df_biosample, df_refexsampleid)

# Add RefexSampleId to the sample table
df_select_refexsampleid <- df_select %>% left_join(df_biosample, by = "BioSample") %>% relocate(RefexSampleId)
# Count NumberOfSamples
df_count <- df_select_refexsampleid %>% count(RefexSampleId)
# Add NumberOfSamples
df_select_refexsampleid <- df_select_refexsampleid %>% left_join(df_count, by = "RefexSampleId") %>% rename(NumberOfSamples = n) %>% relocate(RefexSampleId, NumberOfSamples)

# Create grouped sample table
df_grouped <- df_select_refexsampleid %>% select(-Run) %>% distinct() %>% write_tsv("Arabidopsis_TPJ_2016_refextable_grouped_sample.tsv")
# Create sampleID mapping
df_idmap <- df_select_refexsampleid %>% select(RefexSampleId, Run) %>% distinct() %>% write_tsv("Arabidopsis_TPJ_2016_refextable_sampleID_mapping.tsv")

sessionInfo()

