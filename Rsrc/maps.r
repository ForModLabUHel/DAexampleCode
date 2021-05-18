library(rgdal)
library(rasterVis)
library(RColorBrewer)
library(raster)
library(ggpubr)
library(ggplot2)
library(devtools)
library(data.table)
library(ggridges)
library(parallel)

devtools::source_url("https://raw.githubusercontent.com/ForModLabUHel/utilStuff/master/ErrorDecomposition/ErrorDecomposition.R")
# source("runSettings.r")
print("define tileX. example: tileX <- '35VLJ'")
tiles <- c("35VLJ", "34VEQ", "35WMN")
pathX <- "~/research/assessCarbon/results/"
# CSCrun=TRUE
# if(CSCrun==TRUE){
#   pathX <- "/scratch/project_2000994/PREBASruns/assessCarbon/"
# }
coresN <- 3
MSEall <- data.table()
stAll <- data.table()
pRMSE <- list()
nSample <- 100000
colX <- c("#0E95A5","#28B209","#DFB021","#ff8533")

createMaps <- function(rastDA,rastS,rastM,varX,unitsX){
  # rast_df <- as.data.frame(rastDA, xy = TRUE)
  rast_df <- data.table(rasterToPoints(rastDA))
  fillX <- names(rast_df)[3]
  mapX <- ggplot() +
    geom_raster(data = rast_df, 
                aes_string(x = "x", y = "y", 
                           fill = fillX)) + 
    geom_raster(data = rast_df, 
                aes_string(x = "x", y = "y", 
                           alpha = fillX)) +  
    scale_fill_viridis_c() +  
    scale_alpha(range = c(0.15, 0.65), guide = "none") +  
    ggtitle(varX) + labs(fill = paste(varX, unitsX))
  coord_quickmap()
  
  f1 <- getValues(rastDA - rastS)
  f2 <- getValues(rastDA - rastM)
  dat1 <- data.table(counts= f1,difX="f1")
  dat2 <- data.table(counts= f2,difX="f2")
  dat <- rbind(dat1,dat2)
  dat$difX <- as.factor(dat$difX)
  
  histX <- ggplot(dat[sample(1:nrow(dat),1e5)], aes(x=counts, fill=difX)) + 
    geom_histogram() + ylab(NULL) + xlab(paste0(varX," deviation ",unitsX))
  plotX <- list(map = mapX,hist=histX)
  return(plotX)
}


mclapply(1:length(tiles),function(i){
  tileX <- tiles[i]
  pathLap <- paste0("C:/Users/checcomi/Documents/research/assessCarbon/results/",tileX,"/rasters/")
  pathCSC <- paste0("/scratch/project_2000994/PREBASruns/assessCarbon/rasters/Finland/AC_training_FI_",tileX,"/outRast/init2016/")
  pathX <- pathCSC
  
  Dda <- raster(paste0(pathX,"Dda2019.tif"))
  Dm <- raster(paste0(pathX,"Dm2019.tif"))
  Ds <- raster(paste0(pathX,"Ds2019.tif"))
  Bda <- raster(paste0(pathX,"Bda2019.tif"))
  Bm <- raster(paste0(pathX,"Bm2019.tif"))
  Bs <- raster(paste0(pathX,"Bs2019.tif"))
  Hda <- raster(paste0(pathX,"Hda2019.tif"))
  Hm <- raster(paste0(pathX,"Hm2019.tif"))
  Hs <- raster(paste0(pathX,"Hs2019.tif"))
  
  mapD <- createMaps(Dda,Ds,Dm,"D","(cm)")
  mapH <- createMaps(Dda,Ds,Dm,"H","(m)")
  mapB <- createMaps(Dda,Ds,Dm,"B","(m2/ha)")
  
  save(mapD,file = paste0(pathX,"/mapsD.rdata"))
  save(mapH,file = paste0(pathX,"/mapsH.rdata"))
  save(mapB,file = paste0(pathX,"/mapsB.rdata"))
  # ggsave(mapH,filename = paste0(pathX,"/mapH.png"),device = "png")
  # ggsave(mapB,filename = paste0(pathX,"/mapB.png"),device = "png")
  print(tileX)
},mc.cores = coresN)


# mapX <- list()
# for(i in 1:length(tiles)){
#   tileX <- tiles[i]
#   pathLap <- paste0("C:/Users/checcomi/Documents/research/assessCarbon/results/",tileX,"/rasters/")
#   pathCSC <- paste0("/scratch/project_2000994/PREBASruns/assessCarbon/rasters/Finland/AC_training_FI_",tileX,"/outRast/init2016/")
#   pathX <- pathSC
#   load(paste0(pathX,"/mapsD.rdata"))
#   mapX[[tileX]] <- mapD
# }
# plotX <- ggarrange(mapX[[tiles[1]]]$map,
#           mapX[[tiles[2]]]$map,
#           mapX[[tiles[3]]]$map,
#           mapX[[tiles[1]]]$hist,
#           mapX[[tiles[2]]]$hist,
#           mapX[[tiles[3]]]$hist,ncol=3,nrow=3
#           ) 
#  ggsave(Dx,filename = "/scratch/project_2000994/PREBASruns/assessCarbon/Dmaps.png",device = "png")