
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Example code to perform data assimilation (DA) of sentinel 2 and process-based model (PREBAS) predictions of forest variables (Minunno et al. 2023)

<!-- badges: start -->

<!-- badges: end -->

DA is used to combine multiple predictions of forest structural variables (FSV). FSV were predicted using sentinel 2 data for two different years (2016 and 2019). PREBAS is a forest growth and ecosystem carbon balance model, that is used to forecast 2016 estimates to 2019. PREBAS emulators were calibrated and used to reduce the compuational load of DA.

## Data processing

Raster files of forest structural variables are read and pre-processed to perform the DA:

``` r
library(devtools)
source_url("https://raw.githubusercontent.com/ForModLabUHel/DAexampleCode/master/Rsrc/1_procData_DA.r")

```

## Data assimilation

Data assimilation is performed running the following script:

``` r
source_url("https://raw.githubusercontent.com/ForModLabUHel/DAexampleCode/master/Rsrc/2_DA_SFC_FSV.r")

```

## DA raster

New rasters based on DA results can be produced running the script:

``` r
source_url("https://raw.githubusercontent.com/ForModLabUHel/DAexampleCode/master/Rsrc/3_DTtoRast.r.r")

```


## References


Minunno, F., et al.. 2023. “Data assimilation of forest status using Sentinel-2 data and a process-based model.” Remote sensing of environment.
<https://doi.org/...>.

## Acknowledgements:

....
