source("cluster.sim.mat.R")
source("plot.survival.graphics.R")

fileDir = "C:/Users/user/Documents/Research/"

#cluster similarity matrix by hierarchical clustering and plot heatmaps for k=2..6 to pdf
cluster.sim.mat(fileDir)

# plot survival graphics for k=2..6, fileDir is directory of mat file obtained from MATLAB training
plot.survival.graphics("survival_plots.pdf",fileDir)