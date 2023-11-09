library(devtools)

# Run general setting file 
source_url("https://raw.githubusercontent.com/ForModLabUHel/DAexampleCode/master/Rsrc/settings.r")

# load file with functions
source_url("https://raw.githubusercontent.com/ForModLabUHel/DAexampleCode/master/Rsrc/functions.r")

nSample = 1000 ###number of samples from the error distribution

####load input data
load(url("https://raw.githubusercontent.com/ForModLabUHel/DAexampleCode/master/procData/init2016/DA2019/allData.rdata"))

####load error models
load(url("https://raw.githubusercontent.com/ForModLabUHel/DAexampleCode/master/data/inputUncer.rdata"))
load(url("https://raw.githubusercontent.com/ForModLabUHel/DAexampleCode/master/data/logisticPureF.rdata"))
load(url("https://raw.githubusercontent.com/ForModLabUHel/DAexampleCode/master/data/step.probit.rdata"))
###load PREBAS emulators
load(url("https://raw.githubusercontent.com/ForModLabUHel/DAexampleCode/master/data/surMod.rdata"))

####process the input data
data.all <- data.all[ba>0]
data.all[,BAp:= (ba * pineP/(pineP+spruceP+blp))]
data.all[,BAsp:= (ba * spruceP/(pineP+spruceP+blp))]
data.all[,BAb:= (ba * blp/(pineP+spruceP+blp))]
data.all$V <- data.all$v2 - (data.all$dVy*nYears)
data.all[,BAp2:= (ba2 * pineP2/(pineP2+spruceP2+blp2))]
data.all[,BAsp2:= (ba2 * spruceP2/(pineP2+spruceP2+blp2))]
data.all[,BAb2:= (ba2 * blp2/(pineP2+spruceP2+blp2))]
data.all <- data.all[ba>0]
# 
dataSurMod <- data.all[,.(segID,h,dbh,BAp,BAsp,BAb,siteType1,
                          siteType2,v2,ba2,h2,dbh2,
                          BAp2,BAsp2,BAb2,V)]
setnames(dataSurMod,c("segID","H","D","BAp","BAsp","BAb","st1",
                      "st2","V2","ba2","h2","dbh2",
                      "BAp2","BAsp2","BAb2","V"))

dataSurMod[,BApPer:=.(BAp/sum(BAp,BAsp,BAb)*100),by=segID]
dataSurMod[,BAspPer:=.(BAsp/sum(BAp,BAsp,BAb)*100),by=segID]
dataSurMod[,BAbPer:=.(BAb/sum(BAp,BAsp,BAb)*100),by=segID]
dataSurMod[,BAtot:=.(sum(BAp,BAsp,BAb)),by=segID]
dataSurMod[,BApPer2:=.(BAp2/sum(BAp2,BAsp2,BAb2)*100),by=segID]
dataSurMod[,BAspPer2:=.(BAsp2/sum(BAp2,BAsp2,BAb2)*100),by=segID]
dataSurMod[,BAbPer2:=.(BAb2/sum(BAp2,BAsp2,BAb2)*100),by=segID]
dataSurMod[,BAtot2:=.(sum(BAp2,BAsp2,BAb2)),by=segID]


nSeg <- nrow(dataSurMod)  ##200
stProbMod <- matrix(NA,nSeg,6)
colnames(stProbMod) <- c("segID",paste0("pST",1:5))

#calculate the probability for each site fertility class at pixel level based on Bayesian model comparison
system.time({
  for(i in 1:nSeg){
    stProbMod[i,] <- pSTx(dataSurMod[i],nSample,startingYear,year2,tileX)
    # if (i %% 100 == 0) { print(i) }
  }
  stProbMod <- data.table(stProbMod)
})


  # Calculate the probability for each site fertility class at pixel level 
  # based on 2016 s2 data
  dataSurMod[,st:=st1]
  step.probit1 <- step.probit[[paste0("y",startingYear)]][[paste0("t",tileX)]]
  probit1 <- predict(step.probit1,type='p',dataSurMod[1:nSeg,])   ### needs to be changed . We need to calculate with 2016 and 2019 data
  
  # Calculate the probability for each site fertility class at pixel level 
  # based on 2019 s2 data
  dataSurMod[,st:=st2]
  step.probit2 <- step.probit[[paste0("y",year2)]][[paste0("t",tileX)]]
  probit2 <- predict(step.probit2,type='p',dataSurMod[1:nSeg,])   ### needs to be changed . We need to calculate with 2016 and 2019 data
  
  
  ###DA: combine the different sources of information
  stProb <- array(NA, dim=c(nSeg,5,3))
  stProb[,,1] <- probit1
  stProb[,,2] <- probit2
  stProb[,,3] <- as.matrix(stProbMod[,2:6])
  
  stProb <- apply(stProb, c(1,2), mean)
  stProb <- cbind(dataSurMod$segID,stProb)
  colnames(stProb) <- colnames(stProbMod)
  
  dataSurMod <- merge(dataSurMod,stProb)
  
  pMvNorm <- data.table()
  system.time({
    pMvNorm <- dataSurMod[, pSVDA(.SD,nSample = nSample,year1=startingYear,
                                  year2=year2,tileX=tileX), by = segID]
  })

