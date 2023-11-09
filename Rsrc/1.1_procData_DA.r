
# Run settings 
library(devtools)
source_url("https://raw.githubusercontent.com/ForModLabUHel/DAexampleCode/master/Rsrc/settings.r")
if(file.exists("localSettings.r")) {source("localSettings.r")} # use settings file from local directory if one exists

####load error models
load(url("https://raw.githubusercontent.com/ForModLabUHel/DAexampleCode/master/data/inputUncer.rdata"))
load(url("https://raw.githubusercontent.com/ForModLabUHel/DAexampleCode/master/data/logisticPureF.rdata"))
load(url("https://raw.githubusercontent.com/ForModLabUHel/DAexampleCode/master/data/step.probit.rdata"))


# Create folders for outputs.
# setwd(generalPath)
  
mkfldr <- paste0("procData/",paste0("init",startingYear,"/DA",year2))
if(!dir.exists(file.path(mkfldr))) {
  dir.create(file.path(mkfldr), recursive = TRUE)
}



###extract CurrClim IDs
# rastX <- raster(baRast)
# if(testRun){
#   extNew <- extent(rastX)
#   extNew[2]   <- (extent(rastX)[1] + (extent(rastX)[2] - extent(rastX)[1])*fracTest)
#   extNew[4]   <- (extent(rastX)[3] + (extent(rastX)[4] - extent(rastX)[3])*fracTest)
#   rastX <- crop(rastX,extNew)
#   maxSitesRun <- maxSitesRunTest
# }
# 
# climID <- raster(climIDpath)
# 
# rm(rastX)
# gc()
# 

fileNames <- c(baRast,
               blPerRast,
               dbhRast,
               vRast,
               hRast,
               pinePerRast,
               sprucePerRast,
               siteTypeRast,
               siteTypeRast2,
               vRast2,
               baRast2,
               dbhRast2,
               hRast2,
               pinePerRast2,
               sprucePerRast2,
               blPerRast2,
               if (mgmtmask==T) mgmtmaskRast)


for(i in 1:length(fileNames)){
  rastX <- raster(fileNames[i])
  dataX <- data.table(rasterToPoints(rastX))
  if(i==1){
    data.all <- dataX 
  }else{
    data.all <- merge(data.all,dataX)
  }
  print(fileNames[i])
}


###attach weather ID
data.all$climID <- c(rep(1,nrow(data.all)/2),rep(2,nrow(data.all)/2))
# dataX <- data.table(rasterToPoints(climIDs))
# data.all <- merge(data.all,dataX)
setnames(data.all,c("x","y","ba","blp","dbh","v","h","pineP","spruceP",
                    "siteType1","siteType2","v2","ba2","dbh2","h2",
                    "pineP2","spruceP2","blp2", "climID"))

####calibrated error
# data.all$ba <- (data.all$ba - calErr$y2016[[paste0("t",tileX)]]$errMod$linG$coefficients[1])/
#   calErr$y2016[[paste0("t",tileX)]]$errMod$linG$coefficients[2]
# data.all$dbh <- (data.all$dbh - calErr$y2016[[paste0("t",tileX)]]$errMod$linD$coefficients[1])/
#   calErr$y2016[[paste0("t",tileX)]]$errMod$linD$coefficients[2]
# data.all$v <- (data.all$v - calErr$y2016[[paste0("t",tileX)]]$errMod$linV$coefficients[1])/
#   calErr$y2016[[paste0("t",tileX)]]$errMod$linV$coefficients[2]
# data.all$h <- 10*((data.all$h/10 - calErr$y2016[[paste0("t",tileX)]]$errMod$linH$coefficients[1])/
#   calErr$y2016[[paste0("t",tileX)]]$errMod$linH$coefficients[2])
# 
# data.all$ba2 <- (data.all$ba2 - calErr$y2019[[paste0("t",tileX)]]$errMod$linG$coefficients[1])/
#     calErr$y2019[[paste0("t",tileX)]]$errMod$linG$coefficients[2]
# data.all$dbh2 <- (data.all$dbh2 - calErr$y2019[[paste0("t",tileX)]]$errMod$linD$coefficients[1])/
#     calErr$y2019[[paste0("t",tileX)]]$errMod$linD$coefficients[2]
# data.all$v2 <- (data.all$v2 - calErr$y2019[[paste0("t",tileX)]]$errMod$linV$coefficients[1])/
#     calErr$y2019[[paste0("t",tileX)]]$errMod$linV$coefficients[2]
# data.all$h2 <- 10*((data.all$h2/10 - calErr$y2019[[paste0("t",tileX)]]$errMod$linH$coefficients[1])/
#                     calErr$y2019[[paste0("t",tileX)]]$errMod$linH$coefficients[2])
# data.all$ba <- (data.all$ba - calErr$y2016[[paste0("t",tileX)]]$errMod$linG$coefficients[1])/
#   calErr$y2016[[paste0("t",tileX)]]$errMod$linG$coefficients[2]
# data.all$dbh <- (data.all$dbh - calErr$y2016[[paste0("t",tileX)]]$errMod$linD$coefficients[1])/
#   calErr$y2016[[paste0("t",tileX)]]$errMod$linD$coefficients[2]
# data.all$v <- (data.all$v - calErr$y2016[[paste0("t",tileX)]]$errMod$linV$coefficients[1])/
#   calErr$y2016[[paste0("t",tileX)]]$errMod$linV$coefficients[2]
# data.all$h <- 10*((data.all$h/10 - calErr$y2016[[paste0("t",tileX)]]$errMod$linH$coefficients[1])/
#   calErr$y2016[[paste0("t",tileX)]]$errMod$linH$coefficients[2])
# 
# data.all$ba2 <- (data.all$ba2 - calErr$y2019[[paste0("t",tileX)]]$errMod$linG$coefficients[1])/
#     calErr$y2019[[paste0("t",tileX)]]$errMod$linG$coefficients[2]
# data.all$dbh2 <- (data.all$dbh2 - calErr$y2019[[paste0("t",tileX)]]$errMod$linD$coefficients[1])/
#     calErr$y2019[[paste0("t",tileX)]]$errMod$linD$coefficients[2]
# data.all$v2 <- (data.all$v2 - calErr$y2019[[paste0("t",tileX)]]$errMod$linV$coefficients[1])/
#     calErr$y2019[[paste0("t",tileX)]]$errMod$linV$coefficients[2]
# data.all$h2 <- 10*((data.all$h2/10 - calErr$y2019[[paste0("t",tileX)]]$errMod$linH$coefficients[1])/
#                     calErr$y2019[[paste0("t",tileX)]]$errMod$linH$coefficients[2])

####convert data to prebas units H from decimeters to meters
data.all <- data.all[, h := h * hConv]
data.all <- data.all[, h2 := h2 * hConv]


if(siteTypeX==year2){
  data.all[,siteType:=siteType2]  
}else if(siteTypeX==startingYear){
  data.all[,siteType:=siteType1]  
}else{
  data.all[,siteType:=siteTypeX]  
}
data.all[siteType>5,siteType:=5]
data.all[siteType1>5,siteType1:=5]
data.all[siteType2>5,siteType2:=5]


#####I'm excluding from the runs the areas that have been clearcutted and have ba=0 
# data.all[h==0. & dbh==0 & ba==0,clCut:=1]
data.all[,clCut:=0]
data.all[ba==0,clCut:=1]

####check where H is below minimum initial height and replace
smallH <- intersect(which(data.all$h < initH), which(data.all$clCut==0))
data.all[smallH, h:=initH]
####check where dbh is below minimum initial dbh and replace
smallD <- intersect(which(data.all$dbh < initDBH), which(data.all$clCut==0))
data.all[smallD, dbh:=initDBH]
####check where dbh is below minimum initial dbh and replace
smallB <- intersect(which(data.all$ba < initBA), which(data.all$clCut==0))
data.all[smallB, ba:=initBA]

###calculate tree density
data.all[clCut==0,N:=ba/(pi*(dbh/200)^2)]


###check where density is too high and replace stand variables with initial conditions
tooDens <- intersect(which(data.all$N> maxDens), which(data.all$clCut==0))
data.all[tooDens,h:=initH]
data.all[tooDens,ba:=initBA]
data.all[tooDens,dbh:=initDBH]
data.all[tooDens,N:=initN]


data.all[pineP == 0 & spruceP == 0 & blp ==0 & siteType ==1, blp:=1  ]
data.all[pineP == 0 & spruceP == 0 & blp ==0 & siteType <= 3 & siteType > 1, spruceP:=1  ]
data.all[pineP == 0 & spruceP == 0 & blp ==0 & siteType >= 4, pineP:=1  ]

###!!!!!!!!!!!!########careful with this part##########!!!!!!!!#########

####calculate dV, dBA, dH, dDBH
# data.all[,dV := v2-v]
data.all[,dVy := (v2-v)/(year2 - startingYear)]
# data.all[,dBA := ba2-ba]
data.all[,dBAy := (ba2-ba)/(year2 - startingYear)]
# data.all[,dH := h2-h]
data.all[,dHy := (h2-h)/(year2 - startingYear)]
# data.all[,dDBH := dbh2-dbh]
data.all[,dDBHy := (dbh2-dbh)/(year2 - startingYear)]

# ####group pixels by same values
# data.all[, segID := .GRP, by = .(ba, blp,dbh, h, pineP, spruceP, 
#                                  siteType1,siteType2, climID,dVy,v2,
#                                  dBAy,ba2,dHy,h2,dDBHy,dbh2,
#                                  pineP2, spruceP2,blp2)]

####Count segID pix
data.all$segID <- 1:nrow(data.all)
# data.all[, npix:=.N, segID]

# # uniqueData <- data.table()
# ####find unique initial conditions
# uniqueData <- unique(data.all[clCut==0,.(segID,npix,climID,ba,blp,dbh,h,pineP,spruceP,
#                                          siteType1,siteType2,dBAy,ba2,dVy,v2,
#                                          dHy,h2,dDBHy,dbh2,pineP2, spruceP2,blp2)])
# 
# uniqueData[,uniqueKey:=1:nrow(uniqueData)]
# setkey(uniqueData, uniqueKey)
# # uniqueData[,N:=ba/(pi*(dbh/200)^2)]
# # range(uniqueData$N)
# 
# uniqueData[,area:=npix*resX^2/10000]

###assign ID to similar pixels
XYsegID <- data.all[,.(x,y,segID)]

###!!!!!!!!!!!!########end careful with this part##########!!!!!!!!#########

# nSamples <- ceiling(dim(uniqueData)[1]/20000)
# sampleID <- 1
# 
# for(sampleID in sampleIDs){
#   set.seed(1)
#   samplesX <- split(uniqueData, sample(1:nSample, nrow(uniqueData), replace=T))
#   sampleX <- ops[[sampleID]]
#   sampleX[,area := N*resX^2/10000]
#   # sampleX[,id:=climID]
# }


# nSamples <- ceiling(dim(uniqueData)[1]/maxSitesRun)
# set.seed(1)
# sampleset <- sample(1:nSamples, nrow(uniqueData),  replace=T)
# samples <- split(uniqueData, sampleset) 
# 
# # adding sampleID, sampleRow (= row within sample) 
# uniqueData[,sampleID:=sampleset]
# uniqueData[,sampleRow:=1:length(h),by=sampleID]
# 
# segID <- numeric(0)
# for(i in 1:nSamples){
#   sampleX <- samples[[i]]
#   segID <- c(segID,sampleX$segID)
# }

save(data.all,XYsegID,file=paste0(procDataPath,"init",startingYear,"/DA",year2,"/allData.rdata"))         ### All data
# save(uniqueData,file=paste0(procDataPath,"init",startingYear,"/DA",year2,"/uniqueData.rdata"))    ### unique pixel combination to run in PREBAS
# save(samples,file=paste0(procDataPath,"init",startingYear,"/DA",year2,"/samples.rdata"))    ### unique pixel combination to run in PREBAS
# save(XYsegID,segID,file=paste0(procDataPath,"init",startingYear,"/DA",year2,"/XYsegID.rdata"))    ### Coordinates and segID of all pixels

#### If needed (splitRun = TRUE), unique data is split to separate tables here to enable 
#    running further scripts in multiple sections. Number of split parts is defined in splitRange variable (in settings).
#    Running in multiple sections reduces processing time

