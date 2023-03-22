#!/bin/Rscript

library(tidyverse)
df1 <- read_csv("SraRunTable_PRJNA314076.csv")
df2 <- read_csv("SraRunTable_PRJNA324514.csv")
df <- bind_rows(df1, df2)

df_select <- df %>% select(Run, BioSample, Ecotype, Organism, `Sample Name`, Tissue, dev_stage, Age, Treatment)

# Check the uniqueness of "Sample Name" row
# df_select %>% group_by(`Sample Name`) %>% summarize(n()) %>% summary()
#  Sample Name             n()   
#  Length:85          Min.   :2  
#  Class :character   1st Qu.:2  
#  Mode  :character   Median :2  
#                     Mean   :2  
#                     3rd Qu.:2  
#                     Max.   :2

# Order by BioSample ID
df_select <- df_select %>% arrange(BioSample)
# Rename row names
# Use the same names as much as Nat_2020 series, which uses ontologies.
df_select <- df_select %>% rename(Description = `Sample Name`, DevelopmentalStage = dev_stage, OrganismPart = Tissue)


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
df_select_refexsampleid <- df_select_refexsampleid %>% left_join(df_count, by = "RefexSampleId") %>% rename(NumberOfSamples = n) %>% relocate(RefexSampleId, Description, NumberOfSamples, Ecotype, Age, DevelopmentalStage)

# Create grouped sample table
df_select_refexsampleid %>% select(-Run, -BioSample, -Organism) %>% distinct() %>%
    write_tsv("Arabidopsis_TPJ_2016_refextable_grouped_sample.tsv")
# Create sampleID mapping
df_select_refexsampleid %>% select(RefexSampleId, BioSample, Run) %>% distinct() %>%
    rename(BiosampleId = BioSample, ProjectSampleId = Run) %>%
    write_tsv("Arabidopsis_TPJ_2016_refextable_sampleID_mapping.tsv")

sessionInfo()

