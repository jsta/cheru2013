
data/huc_clipped.shp: code/clip_shp.R ## clipped US HUC shapefile to study are
	Rscript code/clip_shp.R
	
data/icc.csv: code/unconditional_models.R ## compute icc from unconditional models
	Rscript code/unconditional_models.R
	
data/blup.csv: code/unconditional_models.R ## compute BLUP from unconditional models
	Rscript code/unconditional_models.R

.PHONY: help
.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z0-9\./\_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'