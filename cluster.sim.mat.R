cluster.sim.mat <- function(fileDir){

  library(ComplexHeatmap)
  library(cluster)
  library(R.matlab)
  
  mrna.sim <- readMat(paste0(fileDir,"allInfo.mat",collapse=NULL))
  
  mat <- mrna.sim$simMat
  
  col_vector = c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
  
  distcol = dist(t(mat))
  modelcol <- hclust(distcol,method="average")
  
  for (k in 2:6) # cluster number
  {
  
    clusters_col<- cutree(modelcol, k)
    Clusters = clusters_col
    data_fr = data.frame(Clusters)
    colnames(data_fr) <- "Clusters"
    
    myfile = paste0(fileDir,"hclustk=",k,".txt",collapse=NULL)
    
    write.table(Clusters, file = myfile, sep = "\t")
  
    cvector = c()
    for (i in 1:k){
      cvector[as.character(i)] = (col_vector[i+1])
    }
  
  
    ha = HeatmapAnnotation(df = data_fr,col = list(Clusters = cvector), annotation_legend_param = list(
      Clusters = list(title = "Clusters", title_gp = gpar(fontsize = 16),labels_gp = gpar(fontsize = 14)))
      )
    
    
    png(paste0(fileDir,"heatmapk=", k ,".png", collapse=NULL))
  
    print(
      Heatmap(mat, name = "Similarity", cluster_rows = modelcol,cluster_columns = modelcol,top_annotation = ha, column_title = paste0("k=", k , collapse=NULL),
              show_row_names = FALSE, show_column_names = FALSE, 
              show_column_dend = FALSE,show_row_dend = FALSE,
              heatmap_legend_param = list(title = "Similarity", title_gp = gpar(fontsize = 16), labels_gp = gpar(fontsize = 14)),
              column_title_gp = gpar(fontsize = 20, fontface = "bold")
              )
      )
    
    dev.off()
    
  
  }
}