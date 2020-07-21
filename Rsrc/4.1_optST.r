library(MASS)
### Run settings & functions
source("Rsrc/settings.r")
source("Rsrc/functions.r")

###check and create output directories
setwd(generalPath)

yearX <- 3
load("C:/Users/minunno/GitHub/satRuns/data/inputUncer.rdata")
load(paste0(procDataPath,"init",startingYear,"/","st",siteTypeX,"/XYsegID.rdata"))  
# load("procData/init2016/st2019/XYsegID.rdata")
# load("output/init2016/st2019/CurrClim_sample1.rdata")
load(paste0("output/init",startingYear,"/","st",siteTypeX,"/CurrClim_sample1.rdata"))  
# load("procData/init2016/st2019/uniqueData.rdata")
load(paste0("procData/init",startingYear,"/","st",siteTypeX,"/uniqueData.rdata"))  
# load("outDT/init2016/st2019/V_NoHarv_CurrClimlayerall.rdata")
load(paste0("outDT/init",startingYear,"/","st",siteTypeX,"/V_NoHarv_CurrClimlayerall.rdata"))  
Vmod2019 <- rowSums(out[,yearX,6,])
# load("initPrebas/init2016/st2019/CurrClim_sample1.rdata")
load(paste0("initPrebas/init",startingYear,"/","st",siteTypeX,"/CurrClim_sample1.rdata"))  
dataX <- data.table(cbind(initPrebas$multiInitVar[,3:5,1],initPrebas$multiInitVar[,5,2],
                          initPrebas$multiInitVar[,5,3],initPrebas$siteInfo[,3],Vmod2019))
setnames(dataX,c("H","D","BAp","BAsp","BAb","st","Vmod"))
if(!all(unique(dataX$st) %in% unique(uniqueData$siteType))) stop("not all siteTypes of the tile are in the sample")

## lmod <- lm(Vmod~H+D+BAp+BAsp+BAb+st,data=dataX)  ###Xianglin!!!!
#### Here we use stepwise regression to construct an emulator for volume prediction
dataX$lnVmod<-log(dataX$Vmod)
dataX$st<-dataX$st   ##!!!!Xianglin
dataX$lnBAp<-log(dataX$BAp+1)
dataX$lnBAsp<-log(dataX$BAsp+1)
dataX$lnBAb<-log(dataX$BAb+1)
full.model<-lm(lnVmod~H+D+lnBAp+lnBAsp+lnBAb+st,data=dataX)
step.model <- stepAIC(full.model, direction = "both",
                        trace = FALSE)
#summary(step.model)
#sd(exp(predict(step.model))-dataX$Vmod)
#### 

Vmod3 <- data.table(cbind(segID,V[,3]))
setnames(Vmod3,c("segID","Vpreb3y"))

uniqueData[,BAp:= (ba * pineP/(pineP+spruceP+blp))]
uniqueData[,BAsp:= (ba * spruceP/(pineP+spruceP+blp))]
uniqueData[,BAb:= (ba * blp/(pineP+spruceP+blp))]

dataSurV <- uniqueData[,.(h,dbh,BAp,BAsp,BAb,siteType,v2,segID)] 
setnames(dataSurV,c("H","D","BAp","BAsp","BAb","st","V2","segID"))


dataSurV[,BApPer:=.(BAp/sum(BAp,BAsp,BAb)*100),by=segID]
dataSurV[,BAspPer:=.(BAsp/sum(BAp,BAsp,BAb)*100),by=segID]
dataSurV[,BAbPer:=.(BAb/sum(BAp,BAsp,BAb)*100),by=segID]
dataSurV[,BAtot:=.(sum(BAp,BAsp,BAb)),by=segID]

fixBAper <- function(BApers){
  minBA <- min(BApers)
  if(minBA<0) BApers <- BApers - minBA
  return(BApers)
}

nSample = 10
pSTx <- function(segIDx,nSample){
    set.seed(123)
    sampleError <- data.table(mvrnorm(nSample*2,mu=errData$all$mu,Sigma=errData$all$sigma))
  # segIDx <- dataSurV[segID==2]
  sampleX <- data.table()
  sampleX$H <- segIDx$H + sampleError$H
  sampleX$D <- segIDx$D + sampleError$D
  sampleX$BAtot <- segIDx$BAtot + sampleError$G
  sampleX$BApPer <- segIDx$BApPer + sampleError$BAp
  sampleX$BAspPer <- segIDx$BAspPer + sampleError$BAsp
  sampleX$BAbPer <- segIDx$BAbPer + sampleError$BAb
  sampleX <- sampleX[H>1.5]
  sampleX <- sampleX[D>0.5]
  sampleX <- sampleX[BAtot>0.045]
  sampleX <- sampleX[1:min(nSample,nrow(sampleX))]
  
  sampleX[, c("BApPer", "BAspPer", "BAbPer"):=
            as.list(fixBAper(unlist(.(BApPer,BAspPer,BAbPer)))), 
          by = seq_len(nrow(sampleX))]
  
  sampleX[,BAp:=BApPer*BAtot/100]
  sampleX[,BAsp:=BAspPer*BAtot/100]
  sampleX[,BAb:=BAbPer*BAtot/100]
  sampleX[,st:=segIDx$st]
  sampleX[,V2:=segIDx$V2]
  sampleX[,segID:=segIDx$segID]
  
  # sampleX$lnVmod<-log(sampleX$Vmod)
  # sampleX$st<-factor(sampleX$st,levels = 1:5)     ##!!!!Xianglin
  sampleX$lnBAp<-log(sampleX$BAp+1)
  sampleX$lnBAsp<-log(sampleX$BAsp+1)
  sampleX$lnBAb<-log(sampleX$BAb+1)
  # full.model<-lm(lnVmod~H+D+lnBAp+lnBAsp+lnBAb+st,data=dataX)
  
  sampleX$st <- 1
  sampleX[,VsurST1 := exp(predict(step.model,newdata=sampleX))]
  sampleX$st <- 2
  sampleX[,VsurST2 := exp(predict(step.model,newdata=sampleX))]
  sampleX$st <- 3
  sampleX[,VsurST3 := exp(predict(step.model,newdata=sampleX))]
  sampleX$st <- 4
  sampleX[,VsurST4 := exp(predict(step.model,newdata=sampleX))]
  sampleX$st <- 5
  sampleX[,VsurST5 := exp(predict(step.model,newdata=sampleX))]
  
  pst1 <- mean(dnorm(sampleX$VsurST1 - segIDx$V2,mean=errData$all$muV,sd=errData$all$sdV))
  pst2 <- mean(dnorm(sampleX$VsurST2 - segIDx$V2,mean=errData$all$muV,sd=errData$all$sdV))
  pst3 <- mean(dnorm(sampleX$VsurST3 - segIDx$V2,mean=errData$all$muV,sd=errData$all$sdV))
  pst4 <- mean(dnorm(sampleX$VsurST4 - segIDx$V2,mean=errData$all$muV,sd=errData$all$sdV))
  pst5 <- mean(dnorm(sampleX$VsurST5 - segIDx$V2,mean=errData$all$muV,sd=errData$all$sdV))
  psum <- pst1 +pst2+pst3 +pst4+pst5
  pst1 <- pst1/psum
  pst2 <- pst2/psum
  pst3 <- pst3/psum
  pst4 <- pst4/psum
  pst5 <- pst5/psum
 return(pST=c(pst1,pst2,pst3,pst4,pst5)) 
}

stProbs <- matrix(NA,nrow(dataSurV),5)
system.time(for(i in 1:200){
  stProbs[i,] <- pSTx(dataSurV[i],nSample)
  if (i %% 100 == 0) { print(i) }
} )

# system.time(ll <- dataSurV[1:200, pSTx(.SDcol,nSample),by=segID])
