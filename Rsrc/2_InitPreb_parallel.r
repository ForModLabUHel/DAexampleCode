#### NOTICE that argument "par", to indicate parallel processed files, is included in the filepaths here.

### Run settings & functions
source("Rsrc/settings.r")
source("Rsrc/functions.r")

###check and create output directories
setwd(generalPath)
mkfldr <- paste0("initPrebas/","init",startingYear,"/st",siteTypeX, "par")
if(!dir.exists(file.path(generalPath, mkfldr))) {
  dir.create(file.path(generalPath, mkfldr), recursive = TRUE)
}

load(paste0(procDataPath,"init",startingYear,"/","st",siteTypeX,"/samples.rdata"))  

#nSamples <- length(samples)
#sampleIDs <- 1:nSamples

if(testRun){
  sampleID <- 1
  rcpfile="CurrClim"
}

#Processing time is measured with tictoc
tic("total time taken to initialize sample data")

for (rcpfile in weather) { ## ---------------------------------------------
  print(date())
  print(rcpfile)
  if(rcpfile=="CurrClim"){
    load(paste(climatepath, rcpfile,".rdata", sep=""))  
    setnames(dat,"id","climID")
    #####process data considering only current climate###
    # dat <- dat[rday %in% 1:10958] #uncomment to select some years (10958 needs to be modified)
    # maxRday <- max(dat$rday)
    # xday <- c(dat$rday,(dat$rday+maxRday),(dat$rday+maxRday*2))
    # dat = rbind(dat,dat,dat)
    # dat[,rday:=xday]
    
  } else{
    load(paste(climatepath, rcpfile, sep=""))  
  }

  gc()
  
  # Create PREBAS input data from sample data. Process data in parallel with mclapply command.
  # Number of cores used for processing can be defined with mc.cores argument. mc.cores=1 disables 
  # parallel processing. 
  initPrebFiles <- mclapply(seq_along(samples), function(x) {
    ## Prepare the same initial state for all harvest scenarios that are simulated in a loop below
    
    data.sample <- samples[[x]]
    sampleID <- names(samples)[x]
    # nSample <- nrow(sampleX)
    # data.sample = sample_data.f(sampleX, nSample)
    totAreaSample <- sum(data.sample$area)
    
    ###check if climID matches
    allclIDs <- unique(dat$climID)
    samClIds <- unique(data.sample$climID)
    if(!all(samClIds %in% allclIDs)){
      opsClim <- samClIds[which(!samClIds %in% allclIDs)]
      dt = data.table(allclIDs, val = allclIDs) # you'll see why val is needed in a sec
      setnames(dt,c("x","val"))
      # setattr(dt, "sorted", "x")  # let data.table know that w is sorted
      setkey(dt, x) # sorts the data
      # binary search and "roll" to the nearest neighbour
      replX <- dt[J(opsClim), roll = "nearest"]
      data.sample$climID <- mapvalues(data.sample$climID,replX[[1]],replX[[2]])
    }
    
    clim = prep.climate.f(dat, data.sample, startingYear, nYears,startYearWeather)
    
    # Region = nfiareas[ID==r_no, Region]
    
    initPrebas = create_prebas_input.f(r_no, clim, data.sample, nYears = nYears,
                                       startingYear = startingYear,domSPrun=domSPrun)
    
    # if(stXruns){
    save(initPrebas,file=paste0(initPrebasPath,"init",startingYear,"/",
                                "st",siteTypeX,"par","/",
                                rcpfile,"_sample",sampleID,".rdata"))
    # }else{
    # save(initPrebas,file=paste0(initPrebasPath,startingYear,"/",
    # rcpfile,"_sample",sampleID,".rdata"))
    # }
    
    # save(initPrebas,file=paste0(initPrebasPath,startingYear,"/",rcpfile,"_sample",sampleID,".rdata"))
    rm(initPrebas); gc()
    #print(sampleID)
  }, mc.cores = coresN)
   
  
  
}
toc()