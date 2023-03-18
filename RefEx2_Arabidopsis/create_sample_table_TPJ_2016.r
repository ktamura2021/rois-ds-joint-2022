#!/bin/Rscript

library(tidyverse)
df1 <- read_csv("SraRunTable_PRJNA314076.csv")
df2 <- read_csv("SraRunTable_PRJNA324514.csv")
df <- bind_rows(df1, df2)

df_select <- df %>% select(Run, BioSample, Ecotype, Organism, `Sample Name`, Tissue, dev_stage, Age, Treatment)
df_select <- df_select %>% arrange(BioSample)

write_csv(df_select, "sample_table_Arabidopsis_TPJ_2016.csv")

sessionInfo()

