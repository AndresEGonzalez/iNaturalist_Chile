## iNaturalist explore records from Chile
## Download & clean iNat data 
## Date: Jun-2019


rm(list = ls(all = TRUE))


library(readr)
library(bdvis)

#Download data base directly from https://www.inaturalist.org/observations?place_id=7182
obs <- read_csv("/home/dell/Documents/1_WORKING/DATA/INATURALIST/observations-57399.csv")
summary(obs)

#Clean up the data and set it up to be used in package bdvis
inatc <- list(
  Latitude="latitude",
  Longitude="longitude",
  Date_collected="observed_on",
  Scientific_name="scientific_name"
)

inat <- format_bdvis(obs,config = inatc)

# We still need to rename some more columns for ease in visualizations like rather than 
# ‘taxon_family_name’ it will be easy to have field called ‘Family’

rename_column <- function(dat,old,new){
  if(old %in% colnames(dat)){
    colnames(dat)[which(names(dat) == old)] <- new
  } else {
    print(paste("Error: Fieldname not found...",old))
  }
  return(dat)
}

inat <- rename_column(inat,"taxon_kingdom_name","Kingdom")
inat <- rename_column(inat,'taxon_phylum_name','Phylum')
inat <- rename_column(inat,'taxon_class_name','Class')
inat <- rename_column(inat,'taxon_order_name','Order_')
inat <- rename_column(inat,'taxon_family_name','Family')
inat <- rename_column(inat,'taxon_genus_name','Genus')
inat <- rename_column(inat,'iconic_taxon_name','Group')

# Remove records excess of 100k data
# inat <- inat[1:100000,]

bdsummary(inat)
# Clean very older records 
# Temporal coverage... 
# Date range of the records from  1917-01-01  to  2019-06-23 !! 
inat =
inat[which(inat$Date_collected > "1974-02-15"),]

bdsummary(inat)

#Extract bdsummary data for draw table in the composed plot (Almost manual)
Data <-c("Records", "Families", "Genus", "Species")
Total <-c(dim(inat)[1], 
           length(unique(inat$Family)),
           length(unique(inat$Genus)),
           length(unique(inat$Scientific_name))
           )
d.f<-data.frame(Data, Total)
d.f

text <- paste("Temporal coverage data:", range(as.Date(inat$Date_collected),na.rm = T)[1], " - ", 
              range(as.Date(inat$Date_collected), na.rm = T)[2])

# Object to plot
table.sum <- ggtexttable(d.f, rows = NULL, 
                         theme = ttheme("lBlack"))
text.p <- ggparagraph(text = text, size = 11, color = "black")#not used in plot




