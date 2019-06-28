## Plot iNaturalist data from Chile
# Datos de observacion de biodiversidad en Chile
# Date: Jun-2019
rm(list = ls(all = TRUE))

library(ggplot2)
library(cowplot)
library(gridGraphics)#Package `gridGraphics` is required to handle base-R plots. Substituting empty plot.
library(ggpubr)#install.packages('ggpubr', dependencies=TRUE, repos='http://cran.rstudio.com/')


#Store data from mapgrid function for enhance plot
map_inat<-mapgrid(inat, 
                  ptype="records", 
                  bbox=c(-50,-90,-17,-66), #consider to crop the shapefile
                  title = "iNaturalist records from Chile",
                  region = "Chile",
                  legscale = 0, 
                  collow = "blue",
                  colhigh = "red", 
                  gridscale=0.1) 

#Env Var map_inat

title = 
legscale = 0 
collow = "blue"
colhigh = "red" 
gridscale=0.1
mybreaks = map_inat[["plot_env"]][["mybreaks"]]
myleg = map_inat[["plot_env"]][["myleg"]]
legname = map_inat[["plot_env"]][["legname"]]
group = map_inat[["plot_env"]][["mapp"]][["group"]]

##############################PLOT#############################
p1 <- ggplot(data = map_inat[["plot_env"]][["mapp"]], aes(long, lat)) + 
  ggtitle("iNaturalist records from Chile") + 
  geom_raster(data = map_inat[["plot_env"]][["middf"]], 
              aes(long, lat, fill = log10(count)), alpha = 1, 
              hjust = 1, vjust = 1) + coord_fixed(ratio = 1) + 
  scale_fill_gradient2(low = "white", mid = collow, 
                       high = colhigh, name = paste("Density", legname), alpha(0.3), 
                       breaks = mybreaks, labels = myleg, space = "Lab") + 
  labs(x = "", y = "") +
  geom_polygon(data = shp, aes(x = long, y = lat, group = group), colour = "gray30", 
               fill = NA, size = 0.3)+
  theme_bw(base_size = 11) + 
  theme(plot.title = element_text(face = "bold"), 
        legend.justification=c(0,1), 
        legend.position=c(0.05, 0.95),
        legend.background = element_blank(),
        legend.key = element_blank())

#Records activity; cause tempolar plot is a base plot we record on device for combine with ggplot in ggdraw
dev.new()
par(xpd = NA, # switch off clipping, necessary to always see axis labels
    bg = "transparent", # switch off background to avoid obscuring adjacent plots
    # oma = c(2, 2, 0, 0) move plot to the right and up
    ) 

tempolar(inat, color="gray40", title="iNat records activity",         
         plottype="r", timescale="w", avg = F)
p2 <- recordPlot()
dev.off()



m2 <- ggdraw() + 
  draw_plot(p1, x = 0, y = 0, width = .5, height = 1) +
  draw_plot(p2, x = .47, y = .47, width = .5, height = .5) +
  draw_plot(table.sum, x = .32, y = 0, width = .8, height = .8)#table.sum Object created in Script.inaturalist.R
# draw_plot_label(label = c("A", "B", "C"), size = 25,
#                 x = c(0, 0.5, 0), y = c(1, 1, 0.5))


# Compose Figure
tiff(filename = "/home/dell/Documents/1_WORKING/DATA/INATURALIST/inat_total_chile_tempolar2.tiff",
     width = 2500, height = 2500, res = 300, compression = "lzw")
m2
dev.off()





