
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


###Read the raster files
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
#rename the database
setnames(data.all,c("x","y","ba","blp","dbh","v","h","pineP","spruceP",
                    "siteType1","siteType2","v2","ba2","dbh2","h2",
                    "pineP2","spruceP2","blp2", "climID"))


#######Process data
####convert data to prebas units H from decimeters to meters
data.all <- data.all[, h := h * hConv]
data.all <- data.all[, h2 := h2 * hConv]

###site fertility class 
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


#####Exclude from the runs the areas that have been clearcutted and have ba=0 or non forested areas
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


####calculate dV, dBA, dH, dDBH
data.all[,dVy := (v2-v)/(year2 - startingYear)]
data.all[,dBAy := (ba2-ba)/(year2 - startingYear)]
data.all[,dHy := (h2-h)/(year2 - startingYear)]
data.all[,dDBHy := (dbh2-dbh)/(year2 - startingYear)]

####assign an ID to each pixel
data.all$segID <- 1:nrow(data.all)

save(data.all,file=paste0(procDataPath,"init",startingYear,"/DA",year2,"/allData.rdata"))         ### All data
