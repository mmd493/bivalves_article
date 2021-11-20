### AQUACULTURE PRODUCTION STATISTICS
### Megan Davis
### In collaboration with Dr. Sonali McDermid and Dr. Jennifer Jacquet

## Insert brief explanation of code...

#----------------#
##### SET UP #####
#----------------#

## Read in the raw .csv files from the FAO's Global Aquaculture Production Statistical Collection 
#(https://www.fao.org/fishery/statistics/global-aquaculture-production/en).

## Set the working directory.
setwd("~/Documents/r_code/raw_data_files/Aquaculture_Prod")

## Load the aquaculture production statistics.
aquac_prod <- read.csv(file = "AQUACULTURE_QUANTITY.csv", header = TRUE, sep = ",")

## Load the aquaculture production value statistics.
aquac_value <- read.csv(file = "AQUACULTURE_VALUE.csv", header = TRUE, sep = ",")

## Load the country information and filter to only include necessary columns.
countries <- read.csv(file = "CL_FI_COUNTRY_GROUPS.csv", header = TRUE, sep = ",") %>%
  select(UN_Code, "ISO3" = ISO3_Code, "Country" = Name_En, "Continent" = Continent_Group_En, 
         "Development" = EcoClass_Group_En, "Region" = GeoRegion_Group_En)

## Load the production environment information and filter to only include necessary columns.
environ <- read.csv(file = "CL_FI_PRODENVIRONMENT.csv", header = TRUE, sep = ",") %>%
  select(Code, "Aq_Environ" = Name_En)

## Load the species information and filter to only include necessary columns.
species <- read.csv(file = "CL_FI_SPECIES_GROUPS.csv", header = TRUE, sep = ",") %>%
  select(X3A_Code, "Common_Name" = Name_En, Scientific_Name, "Phylum" = Major_Group_En, "ISSCAAP_Class" = ISSCAAP_Group_En)

## Load the symbol information and filter to only include necessary columns.
symbol <- read.csv(file = "CL_FI_SYMBOL.csv", header = TRUE, sep = ",") %>%
  select("Data_Type" = Name_En, Symbol) %>%
  mutate(Symbol = case_when((Symbol %in% "[blank]") == T ~ "",
                            (Symbol %in% "[blank]") == F ~ Symbol))

## Load the water area information and filter to only include necessary columns.
water_area <- read.csv(file = "CL_FI_WATERAREA_GROUPS.csv", header = TRUE, sep = ",") %>%
  select(Code, "Aq_Area" = Name_En, "Ocean" = Ocean_Group_En, "Inland_Marine" = InlandMarine_Group_En, 
         "Aq_Region" = FARegion_Group_En)

## Load the Fish Stat J unit information and filter to only include necessary columns.
units <- read.csv(file = "FSJ_UNIT.csv", header = TRUE, sep = ",") %>%
  select(Code, "Units" = Name_En)

#-----------------------------------------------#
##### CREATE A COMBINED PRODUCTION DATA SET #####
#-----------------------------------------------#

## General info...

## Join the country information to the aquaculture production statistics and remove the first column of the combined data
#set, which contains the information the tables were joined on, as we no longer need it.
aquac_prod <- left_join(aquac_prod, countries, by = c("COUNTRY.UN_CODE" = "UN_Code")) %>%
  select(2:(ncol(aquac_prod) + (ncol(countries) - 1)))

## Join the species information to the aquaculture production statistics and remove the first column of the combined data
#set, which contains the information the tables were joined on, as we no longer need it.
aquac_prod <- left_join(aquac_prod, species, by = c("SPECIES.ALPHA_3_CODE" = "X3A_Code")) %>%
  select(2:16)

## Join the water area information to the aquaculture production statistics and remove the first column of the combined data
#set, which contains the information the tables were joined on, as we no longer need it.
aquac_prod <- left_join(aquac_prod, water_area, by = c("AREA.CODE" = "Code")) %>%
  select(2:(ncol(aquac_prod) + (ncol(water_area) - 1)))

## Join the production environment information to the aquaculture production statistics and remove the first column of the
#combined data set, which contains the information the tables were joined on, as we no longer need it.
aquac_prod <- left_join(aquac_prod, environ, by = c("ENVIRONMENT.ALPHA_2_CODE" = "Code")) %>%
  select(2:(ncol(aquac_prod) + (ncol(environ) - 1)))

## Rename the PERIOD and VALUE columns to Year and Value and move to the end of the combined data set.
aquac_prod <-aquac_prod %>%
  mutate(Year = PERIOD, 
         Value = VALUE) %>%
  select(!c(PERIOD, VALUE))

## Join the Fish Stat J unit information to the aquaculture production statistics and remove the first column of the
#combined data set, which contains the information the tables were joined on, as we no longer need it.
aquac_prod <- left_join(aquac_prod, units, by = c("MEASURE" = "Code")) %>%
  select(2:(ncol(aquac_prod) + (ncol(units) - 1)))

## Join the symbol information to the aquaculture production statistics and remove the first column of the combined data
#set, which contains the information the tables were joined on, as we no longer need it.
aquac_prod <- left_join(aquac_prod, symbol, by = c("STATUS" = "Symbol")) %>%
  select(2:(ncol(aquac_prod) +(ncol(symbol) - 1)))

#----------------------------------------------------#
##### FILTER THE AQUACULTURE PRODUCTION DATA SET #####
#----------------------------------------------------#

## General info...

## Just marine bivalves...
aquac_prod <- aquac_prod %>%
  filter(Aq_Environ %in% "Marine",
         Phylum %in% "PLANTAE AQUATICAE" | 
           Phylum %in% "MOLLUSCA" & ISSCAAP_Class %in% "Oysters" |
           Phylum %in% "MOLLUSCA" & ISSCAAP_Class %in% "Mussels" |
           Phylum %in% "MOLLUSCA" & ISSCAAP_Class %in% "Clams, cockles, arkshells" |
           Phylum %in% "MOLLUSCA" & ISSCAAP_Class %in% "Scallops, pectens" |
           Phylum %in% "MOLLUSCA" & ISSCAAP_Class %in% "Pearls, mother-of-pearl, shells")

