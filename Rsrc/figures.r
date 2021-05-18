library(rgdal)
library(rasterVis)
library(RColorBrewer)
library(raster)
library(ggpubr)
library(ggplot2)
library(devtools)
library(data.table)
library(ggridges)
devtools::source_url("https://raw.githubusercontent.com/ForModLabUHel/utilStuff/master/ErrorDecomposition/ErrorDecomposition.R")
# source("runSettings.r")
print("define tileX. example: tileX <- '35VLJ'")
tiles <- c("35VLJ", "34VEQ", "35WMN")
pathX <- "~/research/assessCarbon/results/"
# CSCrun=TRUE
# if(CSCrun==TRUE){
#   pathX <- "/scratch/project_2000994/PREBASruns/assessCarbon/"
# }

MSEall <- data.table()
stAll <- data.table()
pRMSE <- list()
nSample <- 100000
colX <- c("#0E95A5","#28B209","#DFB021","#ff8533")
for(i in 1:length(tiles)){
  tileX <- tiles[i]
  
  #####Figure 1 reseults 
  load(paste0(pathX,"data2019res_",tileX,".rdata"))
  data2019res
  plot(data2019res$G.est,data2019res$G.mea)
  points(data2019res$BDA2019,data2019res$G.mea,col=2,pch=20)
  points(data2019res$Bs2019,data2019res$G.mea,col=3,pch=20)
  points(data2019res$Bm2019,data2019res$G.mea,col=4,pch=20)
  abline(0,1)
  p_rmse <- function(sim,obs) sqrt( mean( (sim-obs)^2) ) / ( max(obs)-min(obs) )*100
  
  MSEs <- data.table(value=as.numeric(unlist(MSEdec("B_est", data2019res$G.est,data2019res$G.mea,method=1))[2:5]),
                     run="est",variable="B",components=c("sb","sdsd","lc","mse"),
                     rangeObs = max(data2019res$G.mea,na.rm=T)-min(data2019res$G.mea,na.rm=T))
  MSEs <- rbind(MSEs,data.table(value=as.numeric(unlist(MSEdec("B", data2019res$Bm2019,data2019res$G.mea,method=1))[2:5]),
                                run="m2019",variable="B",components=c("sb","sdsd","lc","mse"),
                                rangeObs = max(data2019res$G.mea,na.rm=T)-min(data2019res$G.mea,na.rm=T)))
  MSEs <- rbind(MSEs,data.table(value=as.numeric(unlist(MSEdec("B", data2019res$Bs2019,data2019res$G.mea,method=1))[2:5]),
                                run="s2019",variable="B",components=c("sb","sdsd","lc","mse"),
                                rangeObs = max(data2019res$G.mea,na.rm=T)-min(data2019res$G.mea,na.rm=T)))
  MSEs <- rbind(MSEs,data.table(value=as.numeric(unlist(MSEdec("B", data2019res$BDA2019,data2019res$G.mea,method=1))[2:5]),
                                run="DA2019",variable="B",components=c("sb","sdsd","lc","mse"),
                                rangeObs = max(data2019res$G.mea,na.rm=T)-min(data2019res$G.mea,na.rm=T)))
  
  MSEs <- rbind(MSEs,data.table(value=as.numeric(unlist(MSEdec("D", data2019res$D.est,data2019res$D.mea,method=1))[2:5]),
                                run="est",variable="D",components=c("sb","sdsd","lc","mse"),
                                rangeObs = max(data2019res$D.mea,na.rm=T)-min(data2019res$D.mea,na.rm=T)))
  MSEs <- rbind(MSEs,data.table(value=as.numeric(unlist(MSEdec("D", data2019res$Dm2019,data2019res$D.mea,method=1))[2:5]),
                                run="m2019",variable="D",components=c("sb","sdsd","lc","mse"),
                                rangeObs = max(data2019res$D.mea,na.rm=T)-min(data2019res$D.mea,na.rm=T)))
  MSEs <- rbind(MSEs,data.table(value=as.numeric(unlist(MSEdec("D", data2019res$Ds2019,data2019res$D.mea,method=1))[2:5]),
                                run="s2019",variable="D",components=c("sb","sdsd","lc","mse"),
                                rangeObs = max(data2019res$D.mea,na.rm=T)-min(data2019res$D.mea,na.rm=T)))
  MSEs <- rbind(MSEs,data.table(value=as.numeric(unlist(MSEdec("D", data2019res$DDA2019,data2019res$D.mea,method=1))[2:5]),
                                run="DA2019",variable="D",components=c("sb","sdsd","lc","mse"),
                                rangeObs = max(data2019res$D.mea,na.rm=T)-min(data2019res$D.mea,na.rm=T)))
  
  MSEs <- rbind(MSEs,data.table(value=as.numeric(unlist(MSEdec("H", data2019res$H.est/10,data2019res$H.mea/10,method=1))[2:5]),
                                run="est",variable="H",components=c("sb","sdsd","lc","mse"),
                                rangeObs = max(data2019res$H.mea/10,na.rm=T)-min(data2019res$H.mea/10,na.rm=T)))
  MSEs <- rbind(MSEs,data.table(value=as.numeric(unlist(MSEdec("H", data2019res$Hm2019,data2019res$H.mea/10,method=1))[2:5]),
                                run="m2019",variable="H",components=c("sb","sdsd","lc","mse"),
                                rangeObs = max(data2019res$H.mea/10,na.rm=T)-min(data2019res$H.mea/10,na.rm=T)))
  MSEs <- rbind(MSEs,data.table(value=as.numeric(unlist(MSEdec("H", data2019res$Hs2019,data2019res$H.mea/10,method=1))[2:5]),
                                run="s2019",variable="H",components=c("sb","sdsd","lc","mse"),
                                rangeObs = max(data2019res$H.mea/10,na.rm=T)-min(data2019res$H.mea/10,na.rm=T)))
  MSEs <- rbind(MSEs,data.table(value=as.numeric(unlist(MSEdec("H", data2019res$HDA2019,data2019res$H.mea/10,method=1))[2:5]),
                                run="DA2019",variable="H",components=c("sb","sdsd","lc","mse"),
                                rangeObs = max(data2019res$H.mea/10,na.rm=T)-min(data2019res$H.mea/10,na.rm=T)))
  
  MSEs[components=="mse", RMSE:=sqrt(value)]
  
  for(runX in unique(MSEs$run)){
    for(vX in unique(MSEs$variable)){
      MSEs[run==runX & variable==vX & !components%in%"mse",RMSE:=value/sum(value)]
      MSEs[run==runX & variable==vX & !components%in%"mse",]$RMSE <- MSEs[run==runX & variable==vX & !components%in%"mse",]$RMSE * MSEs[run==runX & variable==vX & components%in%"mse",]$RMSE
    }
  }
  
  MSEs$pRMSE <- MSEs$RMSE/MSEs$rangeObs*100
  
  
  MSEs$run <- factor(MSEs$run, levels = c("m2019","s2019","est","DA2019"))
  MSEs$components <- factor(MSEs$components, levels = c("sb","sdsd","lc","mse"))
  varX = "B"
  MSEs$Tile <- tileX
  
  MSEall <- rbind(MSEall,MSEs)

  
  
  #####start proc data Figure 2 results 
  load(paste0("C:/Users/checcomi/Documents/research/assessCarbon/results/",tileX,"/stProbMod1.rdata"))

  xxAll <-  data.table(year=2019,value=rep(1:5,nSample*colMeans(stProb[,2:6])),
                       run="DA2019")
  xxAll <- rbind(xxAll,data.table(year=2019,value=rep(1:5,nSample*colMeans(stProbMod[,2:6])),
                                  run="m2019"))
  xxAll <- rbind(xxAll,data.table(year=2016,value=rep(1:5,nSample*colMeans(probit1[,1:5])),
                                  run="s2016"))
  xxAll <- rbind(xxAll,data.table(year=2019,value=rep(1:5,nSample*colMeans(probit2[,1:5])),
                                  run="s2019"))
  
  probit1 <- data.table(probit1)
  aa <- 1:1e5
  xyAll <- data.table(melt(probit1[aa,],variable.name = "siteClass",measure.vars = 1:5)
                      ,run="s2016")
  setnames(stProbMod,c("segID",1:5))
  ii <- data.table(melt(stProbMod[aa,2:6],measure.vars = 1:5,variable.name = "siteClass"),
             run="m2019")
  xyAll <- rbind(xyAll,ii)
  probit2 <- data.table(probit2)
  ii <- data.table(melt(probit2[aa,],variable.name = "siteClass",measure.vars = 1:5)
             ,run="s2019")
  xyAll <- rbind(xyAll,ii)
  stProb <- data.table(stProb)
  setnames(stProb,c("segID",1:5))
  ii <- data.table(melt(stProb[aa,2:6],measure.vars = 1:5,variable.name = "siteClass"),
                   run="DA2019")
  xyAll <- rbind(xyAll,ii)
  xyAll$run <- factor(xyAll$run,levels = c("s2016","m2019","s2019","DA2019"))
  xyAll$siteClass <- factor(xyAll$siteClass)
  
  ciao <- xyAll[,median(value),by=.(siteClass,run)]
  
  oo <- ciao[,spline(siteClass,V1),by=run]

  # ggplot(oo) + 
  #   geom_line(aes(x = x, y = y, colour = run)) +
  #   coord_cartesian(ylim = c(0, 1.)) + theme(legend.title=element_blank())
  oo$tile <- tileX
  ciao$tile <- tileX
  xyAll$tile <- tileX

  stAll <- rbind(stAll,xyAll)
}


pRMSE <- ggplot(MSEall[!components %in% "mse"& !run %in% "est"], 
                aes(x=run, y=pRMSE, fill=components)) +
  geom_bar(stat="identity")#, position = position_dodge(0.9)) +
# scale_fill_manual(values = c("#00AFBB", "#E7B800"))
RMSE <- ggplot(MSEall[!components %in% "mse"& !run %in% "est"], 
               aes(x=run, y=RMSE, fill=components)) +
  geom_bar(stat="identity")#, position = position_dodge(0.9)) +
# p + facet_grid(rows = vars(variable))
figRes1a <- pRMSE + facet_grid(rows = vars(variable), cols = vars(Tile)) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
figRes1b <- RMSE + facet_grid(rows = vars(variable), cols = vars(Tile)) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
resFig1 <- ggarrange(figRes1a,figRes1b)
ggsave(resFig1,filename = paste0(pathX,"/figures/resFig1.png"),device = "png")
ggsave(figRes1a,filename = paste0(pathX,"/figures/resFig1a.png"),device = "png")
ggsave(figRes2b,filename = paste0(pathX,"/figures/resFig1b.png"),device = "png")



# stPlot <- ggplot(stAll) + 
#   geom_line(aes(x = as.factor(siteClass), y = V1, colour = as.factor(run),group=as.factor(run))) +
#   # coord_cartesian(ylim = c(-0.10, 1.)) +
#   theme(legend.title=element_blank())

stPlot <- ggplot(stAll, aes(x=siteClass, y=value, fill=run,color=run)) +
    geom_boxplot() + scale_fill_manual(values=alpha(colX,0.3)) +
    scale_color_manual(values=colX)+ ylab(NULL) +
  theme(legend.title=element_blank())

####Figure 2
figRes2 <- stPlot + facet_grid( cols = vars(tile)) 
figRes2

ggsave(figRes2,filename = paste0(pathX,"/figures/resFig2.png"),device = "png")

xpX <- dataPlot <- list()

####Figure 2.1
nX <- 123
xy <- data.table(siteClass=1:5,prob=as.numeric(probit1[nX,1:5]),run="s2016")
xy <- rbind(xy,data.table(siteClass=1:5,prob=as.numeric(stProbMod[nX,2:6]),run="m2019"))
xy <- rbind(xy,data.table(siteClass=1:5,prob=as.numeric(probit2[nX,1:5]),run="s2019"))
xy <- rbind(xy,data.table(siteClass=1:5,prob=as.numeric(stProb[nX,2:6]),run="DA2019"))
xy$run <- factor(xy$run,levels = c("s2016","m2019","s2019","DA2019"))

pSC1 <- ggplot(data=xy, aes(x=siteClass, y=prob, color=run,group=run)) +
  geom_line() + theme(legend.title=element_blank())+
  scale_color_manual(values=colX) + ylab(NULL) + ggtitle("A")
pSC1

nX <- 12333
xy <- data.table(siteClass=1:5,prob=as.numeric(probit1[nX,1:5]),run="s2016")
xy <- rbind(xy,data.table(siteClass=1:5,prob=as.numeric(stProbMod[nX,2:6]),run="m2019"))
xy <- rbind(xy,data.table(siteClass=1:5,prob=as.numeric(probit2[nX,1:5]),run="s2019"))
xy <- rbind(xy,data.table(siteClass=1:5,prob=as.numeric(stProb[nX,2:6]),run="DA2019"))
xy$run <- factor(xy$run,levels = c("s2016","m2019","s2019","DA2019"))

pSC2 <- ggplot(data=xy, aes(x=siteClass, y=prob, color=run,group=run)) +
  geom_line() + theme(legend.title=element_blank()) +
  scale_color_manual(values=colX) + ylab(NULL) + ggtitle("B")
pSC2
figRes2.1 <- ggarrange(pSC1,pSC2,common.legend = T)

ggsave(figRes2.1,filename = paste0(pathX,"/figures/resFig2.1.png"),device = "png")








####Figure 3
for(i in 1:length(tiles)){
  tileX <- tiles[i]
  load(paste0("C:/Users/checcomi/Documents/research/assessCarbon/results/",tileX,"/dataForPlots.rdata"))
  
  dataAll$tile <- tileX
  dataPlot <- rbind(dataPlot,dataAll)
}
  
  vars <- unique(dataAll$varNam)
  units <- c("H (m)","D (cm)","BA (m2)", "cover (%)", "cover (%)", "cover (%)",
             "variance (m)","variance (cm)","variance (m2)",
             "variance (%)", "variance (%)", "variance (%)")
  
  ciao <- c("H (m)", "B (m2/ha)", "D (cm)","pine (%)","spruce (%)","birch (%)",
            "variance H", "variance D", "variance B",
            "variance pine (%)","variance spruce (%)","variance birch (%)")
  
  dataPlot$titles <- ciao[match(dataPlot$varNam,unique(dataPlot$varNam))]
  
  pFSV <- ggplot(dataPlot[varNam%in%vars[1:3]],
                                aes(x = value, y = run, fill = stat(x))) + 
    geom_density_ridges_gradient(scale = 3, size = 0.3, rel_min_height = 0.01) +
    scale_fill_viridis_c(name = "", option = "C") +
     xlab(NULL)+ ylab(NULL)
  pvFSV <- ggplot(dataPlot[varNam%in%vars[7:9]],
                 aes(x = value, y = run, fill = stat(x))) + 
    geom_density_ridges_gradient(scale = 3, size = 0.3, rel_min_height = 0.01) +
    scale_fill_viridis_c(name = "", option = "C") +
    xlab(NULL)+ ylab(NULL)
  
  pCover <- ggplot(dataPlot[varNam%in%vars[4:6]],
                 aes(x = value, y = run, fill = stat(x))) + 
    geom_density_ridges_gradient(scale = 3, size = 0.3, rel_min_height = 0.01) +
    scale_fill_viridis_c(name = "", option = "C") +
    xlab(NULL)+ ylab(NULL)
  pvCover <- ggplot(dataPlot[varNam%in%vars[10:12]],
                   aes(x = value, y = run, fill = stat(x))) + 
    geom_density_ridges_gradient(scale = 3, size = 0.3, rel_min_height = 0.01) +
    scale_fill_viridis_c(name = "", option = "C") +
    xlab(NULL)+ ylab(NULL)
  
    
    figRes3a <- pFSV + facet_grid(rows = vars(tile), cols = vars(titles)) +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
    figRes3b <- pCover + facet_grid(rows = vars(tile), cols = vars(titles)) +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
    figRes3c <- pvFSV + facet_grid(rows = vars(tile), cols = vars(titles)) +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
    figRes3d <- pvCover + facet_grid(rows = vars(tile), cols = vars(titles)) +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
    
    figRes3a
    figRes3b
    figRes3c
    figRes3d
    
    ggsave(figRes3a,filename = paste0(pathX,"/figures/resFig3a.png"),device = "png")
    ggsave(figRes3b,filename = paste0(pathX,"/figures/resFig3b.png"),device = "png")
    ggsave(figRes3c,filename = paste0(pathX,"/figures/resFig3c.png"),device = "png")
    ggsave(figRes3d,filename = paste0(pathX,"/figures/resFig3d.png"),device = "png")
    

##Maps and hist
    ####create Maps
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
    
for(i in 1:length(tiles)){
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
}

mapX <- list()
for(i in 1:length(tiles)){
  tileX <- tiles[i]
  pathLap <- paste0("C:/Users/checcomi/Documents/research/assessCarbon/results/",tileX,"/rasters/")
  pathCSC <- paste0("/scratch/project_2000994/PREBASruns/assessCarbon/rasters/Finland/AC_training_FI_",tileX,"/outRast/init2016/")
  pathX <- pathSC
  load(paste0(pathX,"/mapsD.rdata"))
  mapX[[tileX]] <- mapD
}
plotX <- ggarrange(mapX[[tiles[1]]]$map,
          mapX[[tiles[2]]]$map,
          mapX[[tiles[3]]]$map,
          mapX[[tiles[1]]]$hist,
          mapX[[tiles[2]]]$hist,
          mapX[[tiles[3]]]$hist,ncol=3,nrow=3
          ) 
 ggsave(Dx,filename = "/scratch/project_2000994/PREBASruns/assessCarbon/Dmaps.png",device = "png")