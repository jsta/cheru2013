# Unconditional model fits
suppressPackageStartupMessages(library(lme4))
suppressPackageStartupMessages(library(arm))

db_path <- "data/Cheruvelil EPA-NLAPP 6-state lake-landscape database.csv"
db <- read.csv(db_path, stringsAsFactors = FALSE)

#length(db$ALK_mgLCaCO3[!is.na(db$ALK_mgLCaCO3)])

db$TP_ugL <- log(db$TP_ugL)
db$ALK_mgLCaCO3 <- log(db$ALK_mgLCaCO3 + 0.01)

terrestrial_frameworks <- c("EPA_Regions", "Omernik_L3", "Bailey_Sect", "MLRA")
aquatic_frameworks <- c("Fwater_eco", "HUC_6", "EDU")


lmer_fit <- function(y, framework, db){
  cur_f <- as.formula(paste0(y," ~ 1 + (1 |", framework, ")"))
  return(lmer(cur_f, data = db))
}

icc_fit <- function(fit){  
  fit_df <- data.frame(VarCorr(fit))  
  sigma_1 <- fit_df$sdcor[1]
  sigma_2 <- fit_df$sdcor[2]
  round(sigma_1^2 / (sigma_1^2 + sigma_2^2), 3) * 100
}

BLUP_fit <- function(fit){
  ranef(fit)
}

tp_fits <- sapply(c(terrestrial_frameworks, aquatic_frameworks), function(x) lmer_fit("TP_ugL", x, db))
tp_fits_icc <- sapply(tp_fits, function(x) icc_fit(x))
tp_fits_blup <- sapply(tp_fits, function(x) BLUP_fit(x))

alk_fits <- sapply(c(terrestrial_frameworks, aquatic_frameworks), function(x) lmer_fit("ALK_mgLCaCO3", x, db))
alk_fits_icc <- sapply(alk_fits, function(x) icc_fit(x))
alk_fits_blup <- sapply(alk_fits, function(x) BLUP_fit(x))

icc <- data.frame(cbind(tp_fits_icc, alk_fits_icc))
icc[1,] <- NA
names(icc) <- c("TP_ugL", "ALK_mgLCaCO3")
write.csv(icc, "data/icc.csv", row.names = FALSE)

blup <- cbind(tp_fits_blup[length(tp_fits_blup)][[1]], alk_fits_blup[length(alk_fits_blup)][[1]])
names(blup) <- c("TP_ugL", "ALK_mgLCaCO3")
blup$EDU_code <- row.names(blup)
write.csv(blup, "data/blup.csv", row.names = FALSE)

# null_f <- as.formula(paste0(y," ~ 1"))
# null_fit <- lm(null_f, data = db)
# lik_ratio <- (AIC(null_fit) - AIC(fit)) * log2(exp(1))