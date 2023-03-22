#!/bin/Rscript

library(tidyverse)
df <- read_csv("SraRunTable_PRJEB32665.csv")

df_select <- df %>% select(Run, Age, BioSample, Developmental_stage, Ecotype, `Experimental_Factor:_developmental_stage (exp)`, `Experimental_Factor:_organism_part (exp)`, `Experimental_Factor:_sampling_site (exp)`, External_Id, Genotype, organism_part, Organism, Sampling_site)

# To check identical columns
# df_select %>% mutate(check1 = if_else(Developmental_stage == `Experimental_Factor:_developmental_stage (exp)`, "TRUE", "FALSE")) %>% select(check1) %>% distinct()
# # A tibble: 1 × 1
#   check1
#   <chr> 
# 1 TRUE
# df_select %>% mutate(check2 = if_else(`Experimental_Factor:_organism_part (exp)` == organism_part, # "TRUE", "FALSE")) %>% select(check2) %>% distinct()
# # A tibble: 2 × 1
#   check2
#   <chr> 
# 1 TRUE  
# 2 FALSE
# check2 == FALSE:
# ERR3333411: "mixed shoot apical meristem, cotyledon and first leaves", "mixed shoot apical meristem\, cotyledon and first leaves"
# df_select %>% mutate(check3 = if_else(`Experimental_Factor:_sampling_site (exp)` == Sampling_site, # "TRUE", "FALSE")) %>% select(check3) %>% distinct()
# # A tibble: 2 × 1
#   check3
#   <chr> 
# 1 NA    
# 2 TRUE
# df_select %>% mutate(check3 = if_else(`Experimental_Factor:_sampling_site (exp)` == Sampling_site, # "TRUE", "FALSE")) %>% filter(is.na(check3)) %>% select(`Experimental_Factor:_sampling_site (exp)`, # Sampling_site) %>% distinct()
# # A tibble: 1 × 2
#   `Experimental_Factor:_sampling_site (exp)` Sampling_site
#   <chr>                                      <chr>        
# 1 not applicable                             NA  

# Remove duplicated rows
df_select <- df_select %>% select(-Developmental_stage, -organism_part, -Sampling_site)
# Order by BioSample ID
df_select <- df_select %>% arrange(BioSample)
# Rename row names
df_select <- df_select %>% rename(DevelopmentalStage = `Experimental_Factor:_developmental_stage (exp)`) %>% rename(OrganismPart = `Experimental_Factor:_organism_part (exp)`) %>% rename(SamplingSite = `Experimental_Factor:_sampling_site (exp)`)
# Create new row "Description"
df_select <- df_select %>% mutate(Description = str_c(DevelopmentalStage, OrganismPart, SamplingSite, sep = ", "))
# Replace "Description" ended with ", not applicable"
df_select <- df_select %>% mutate(Description = str_replace(Description, pattern = ", not applicable", replacement = ""))

# Check the uniqueness of "Description" row
# df_select %>% group_by(Description) %>% filter(n() > 1) %>% select(Run)
# Adding missing grouping variables: `Description`
# # A tibble: 4 × 2
# # Groups:   Description [2]
#   Description          Run       
#   <chr>                <chr>     
# 1 callus, plant callus ERR3333402
# 2 callus, plant callus ERR3333403
# 3 cell culture, root   ERR3333404
# 4 cell culture, root   ERR3333405

# To distinguish ERR3333404 and ERR3333405
df_select <- df_select %>%
     mutate(Description = if_else(Description == "cell culture, root",
                                  str_c(Description, ", Age ", Age),
                                  Description))
# Metadata for ERR3333402 and ERR3333403 are the same, however, based on the paper, two types of callus were generated.
# As these cannot be distinguishable, these two entries should be removed.
df_select <- df_select %>% filter(Run != "ERR3333402" & Run != "ERR3333403")

# Replace "not available" and "not applicable" with NA
df_select <- df_select %>% mutate_all(~ if_else(. == "not available", NA, .)) %>% mutate_all(~ if_else(. == "not applicable", NA, .))

# Check the number of available samples
# df_select %>% group_by(Description)
# # A tibble: 54 × 11
# # Groups:   Description [54]


# Extract BioSample
df_biosample <- df_select %>% select(BioSample) %>% distinct()
# Create RefexSampleId
df_refexsampleid <- paste("RES0000", seq(3791, 3791 + 53), sep = "") %>% as_tibble_col(column_name = "RefexSampleId")
# Join two columns
df_biosample <- bind_cols(df_biosample, df_refexsampleid)

# Add RefexSampleId to the sample table
df_select_refexsampleid <- df_select %>% left_join(df_biosample, by = "BioSample") %>% relocate(RefexSampleId)
# Count NumberOfSamples
df_count <- df_select_refexsampleid %>% count(RefexSampleId)
# Add NumberOfSamples
df_select_refexsampleid <- df_select_refexsampleid %>% left_join(df_count, by = "RefexSampleId") %>% rename(NumberOfSamples = n) %>% relocate(RefexSampleId, Description, NumberOfSamples)

# Create grouped sample table
df_select_refexsampleid %>% select(-Run, -BioSample, -External_Id, -Organism) %>% distinct() %>%
    write_tsv("Arabidopsis_Nat_2020_refextable_grouped_sample.tsv")
# Create sampleID mapping (Run ID was used as ProjectSampleId)
df_select_refexsampleid %>% select(RefexSampleId, BioSample, Run) %>% distinct() %>%
    rename(BiosampleId = BioSample, ProjectSampleId = Run) %>%
    write_tsv("Arabidopsis_Nat_2020_refextable_sampleID_mapping.tsv")


sessionInfo()

