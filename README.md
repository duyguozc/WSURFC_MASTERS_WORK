# WSURFC
1. Your expression data file should be a dataset in which first row contains patient barcodes or identites or names etc. and 
first column contains variable names. It can be any csv format.
2. Clinical set data is compliant with TCGA format. First column of matrix data contains patient identities and first row contains 
titles of clinical traits.
3. Call train_BRCA_data to 
- read expression dataset and clinical dataset
- calculate upper and lower quartile of patients and filter data by selecting only low and high survivor patients
- select predefined number of features highly correlated with outcome variable
- divide patients as train and test samples
- Generate random forest with training samples

4. Then, call find_sim_mat to generate similarity matrix of training patients. Depth vector keeps depth values 
for each tree that are generated randomly while traversing on that tree.
5. Call find_sim_all to generate similarity matrix of all patients. 
6. Save your similarity matrix as .mat file to a folder you want, then you will read the .mat file with R script.
7. Open R console and example_run_R file. Set fileDir variable to the folder you saved the similarity matrix.
8. Call cluster.sim.mat to cluster similarity matrix by hierarchical clustering and plot heatmaps for k=2..6 to png files.
