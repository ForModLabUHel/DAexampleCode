library(devtools)

#extract data
pMvNorm$varNam <- rep(
  c("Hm2019","Dm2019","Bm2019","perPm2019","perSPm2019","perBm2019",rep("varcov1",36),
    "Hs2019","Ds2019","Bs2019","perPs2019","perSPs2019","perBs2019",rep("varcov2",36),
    "HDA2019","DDA2019","BDA2019","perPDA2019","perSPDA2019","perBDA2019",rep("varcov3",36)),
  times = nrow(pMvNorm)/126)

XYsegID <- data.all[,.(x,y,segID)]

HDA2019 <- merge(XYsegID, pMvNorm[varNam=="HDA2019",1:2], by.x = "segID", 
      by.y = "segID", all.x = TRUE, all.y = FALSE)
DDA2019 <- merge(XYsegID, pMvNorm[varNam=="DDA2019",1:2], by.x = "segID", 
                 by.y = "segID", all.x = TRUE, all.y = FALSE)
BDA2019 <- merge(XYsegID, pMvNorm[varNam=="BDA2019",1:2], by.x = "segID", 
                 by.y = "segID", all.x = TRUE, all.y = FALSE)

#create rasters
HDA2019rast <- rasterFromXYZ(HDA2019[,.(x,y,V1)])
DDA2019rast <- rasterFromXYZ(DDA2019[,.(x,y,V1)])
BDA2019rast <- rasterFromXYZ(BDA2019[,.(x,y,V1)])



plot(HDA2019rast)
