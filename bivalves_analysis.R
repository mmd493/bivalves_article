### MARINE BIVALVE AQUCULTURE MASTER SCRIPT
### Megan Davis
### In collaboration with Dr. Sonali McDermid and Dr. Jennifer Jacquet

##### BELOW NEEDS TO BE CLEANED #####

##Insert explanation of project...

#----------------#
##### SET UP #####
#----------------#


library(dplyr)




##Prepare the workspace to run the analysis.

##remotes::install_github("ropensci/rfishbase")


##Clear workspace. --> Should only be in the master script!!
rm(list = ls())

##Load libraries.
library(dplyr)
library(stringr)
library(rfishbase)

require(rfishbase)
sealife <- load_taxa(server="sealifebase")
Ostreoidea
test <- sealife %>% filter(Phylum =="Mollusca")
test1 <- test %>% filter(Class == "Bivalvia")
length_length

fish <- c("Oreochromis niloticus", "Salmo trutta")
fish <- validate_names(c("Oreochromis niloticus", "Salmo trutta"))

kingcrab <- common_to_sci("king crab")
fish <- c("Oreochromis niloticus", "Salmo trutta")
fish <- validate_names(c("Oreochromis niloticus", "Salmo trutta"))

##Set the working directory.
setwd("/Users/MeganDavis/Documents/r_code/bivalves_article")

aqu_prod <- read.csv(file = "data/fao_aquaculture_prod.csv", header = TRUE, sep = ",") %>%
  select("country" = Land.Area, "species" = Species, "scientific_name" = Scientific.name, "production_2018" = X2018)

bivalves <- aqu_prod %>%
  distinct(species, scientific_name) %>%
  mutate(species = case_when((species %in% "..A") == T ~"Pullet carpet shell",
                             (species %in% "..A") == F ~ species))

write.csv(bivalves, "/Users/MeganDavis/Documents/r_code/bivalves_article/data/bivalves.csv")

library(rfishbase)

species_list = c("Mytilus galloprovincialis")

species(species_list, fields="Comments")


------------------

##Notes on general layout

#Keep this script on the shorter end. It will be the script that runs everything else. But for now it will also act as your
#workspace.

