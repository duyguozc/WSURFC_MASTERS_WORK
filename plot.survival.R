plot.survival <- function(outputFileDir, outputFileName, matFileDir, k){
  
  library(cluster)
  library(R.matlab)
  library(survival)
  
  cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
  
  fileDir <- paste0(matFileDir,"allInfo",k,'.mat', collapse = NULL)
  
  surv.data <- readMat(fileDir);
  
  labels <- surv.data$clusterLabels # herhangi bir clustering algoritmasýndan elde ettiðimiz cluster labellarý
  surv.time <- surv.data$overall/30 # overall survival rates
  vital.status <- surv.data$vital.status # vital status of each patient, alive=0 dead=1
  
  # open empty pdf file
  
  pdf(paste0(outputFileDir,outputFileName, collapse = NULL),family="ArialMT", height=10,width=13)
  
  #par(mfrow=c(1,2),cex=2) 
  par(cex=2) 
  
  fit <- survdiff(formula = Surv(surv.time,  vital.status) ~ labels) # survival distribution denklemini oluþtur
  
  legendSet = c() # her bir subplot için legendleri oluþturup topladýðým array
  
  for (i in 1:k){ # i, k cluterdaki her bir clusterý iterate ediyor
    clustName = paste0("Cluster ",i," (%d)", collapse = NULL)
    legendSet[i] = sprintf(clustName,fit[1]$n[i]) # fit[1]$n[i] cluster i de ne kadar hasta var onu verir
    
  }
  
  plot(survfit(formula = Surv(surv.time,  vital.status) ~ labels),mark.time=TRUE,col=cbbPalette[2:(k+1)],
       xlab='Time (months)',ylab='Survival Probability',lwd=3) #cex li þeyler grafikteki x-y axislerinin labellarýnýn kalýnlýðýný düzenliyor
  
  legend("topright",legendSet,col=cbbPalette[2:(k+1)],lty=1,lwd=2, cex=1.3)
  
  p.val <- pchisq(fit$chisq, length(fit$n) - 1, lower.tail = FALSE) # burda clusterlarýn survival graphiclerinin log-rank testini yapýp p-value buluyoruz
  legend("bottomleft",c(sprintf('p = %g',p.val) ),bty = "n", cex=1.3)
  mytitle <- paste0("k=",k,collapse = NULL)
  title(main = mytitle, , cex=1.3)
  
  dev.off() 
}