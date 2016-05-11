library(sp)
library(raster)
library(rgdal)

# Load data
shp_path <- "/home/jose/R/scripts/cheru2013/data/huc250k_shp"
big_shp <- readOGR(dsn = shp_path, layer = "huc250k", stringsAsFactors = FALSE)
big_shp$HUC_CODE <- as.numeric(big_shp$HUC_CODE)

db_path <- "data/Cheruvelil EPA-NLAPP 6-state lake-landscape database.csv"
db <- read.csv(db_path, stringsAsFactors = FALSE)
db$HUC_CODE <- db$HUC_8

shp <- big_shp[big_shp$HUC_CODE %in% db$HUC_CODE,]
#length(unique(shp$HUC_CODE)) == length(unique(db$HUC_CODE))

# plot(big_shp)
# plot(shp, col = "purple", add = TRUE)

writeOGR(shp, "data", "huc_clipped", driver = "ESRI Shapefile")



