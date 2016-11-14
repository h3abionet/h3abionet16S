#!/usr/bin/Rscript

args <- commandArgs(trailingOnly = TRUE)

 if (length(args)!=3) {
   stop("otufile, mapfile, tree arguments must be supplied (input file).n", call.=FALSE)
 }else 
   {
  # default output file
  
  library(phyloseq)
  setwd(".")
  otufile=args[1]
  mapfile=args[2]
  tree=args[3]
  #outputdir=args[4] # This needs to be specified later by using flags
  outputdir="rReports"
  dir.create(outputdir, showWarnings = FALSE) 
  
  #-----------------------------------
  #IMPORT DATA
  phy <-import_biom(otufile,verbose = TRUE)
  ntaxa(phy)
  ntaxa(phy)#5859 (number of OTUs)
  sample_names(phy) <- sub("\\/1","",sample_names(phy))#remove "/1" from filenames
  #-----------------------------------
  #DATA CLEANUP:
  #-----------------------------------
  colnames(tax_table(phy))
  colnames(tax_table(phy)) <-  c("Kingdom", "Phylum" , "Class" , "Order" , "Family" , "Genus", "Species")#e.g. replace "Rank1" with "Kingdom"
  
  #clean taxonomic annotations, at the moment they are for example 'k__Bacteria'; 'p_Firmicutes' - remove k__ and p__ ...
  tax_table(phy)[,"Kingdom"] <- sub("k__","",tax_table(phy)[,"Kingdom"])
  tax_table(phy)[,"Phylum"] <- sub("p__","",tax_table(phy)[,"Phylum"])
  tax_table(phy)[,"Class"] <- sub("c__","",tax_table(phy)[,"Class"])
  tax_table(phy)[,"Order"] <- sub("o__","",tax_table(phy)[,"Order"])
  tax_table(phy)[,"Family"] <- sub("f__","",tax_table(phy)[,"Family"])
  tax_table(phy)[,"Genus"] <- sub("g__","",tax_table(phy)[,"Genus"])
  tax_table(phy)[,"Species"] <- sub("s__","",tax_table(phy)[,"Species"])
  
  length(which(tax_table(phy)[,"Species"]!=""))# 349 (E 0.1) OTUs with species IDs
  species.tax <- tax_table(phy)[,"Species"][which(tax_table(phy)[,"Species"]!="")]#get species taxonomy
  length(unique(species.tax[,"Species"]))#71 unique species
  
  #-----------------------------------
  #IMPORT METADATA
  #-----------------------------------
  
  map <-import_qiime_sample_data(mapfile)
  head(map)
  rownames(map) <- gsub(" ","_",rownames(map))#change the sample names to match those in the .biom file
  head(sample_names(phy))
  length(sample_names(phy))#144
  length(rownames(map))#144 (check if same number of samples in .biom file and metadatafile)
  length(intersect(rownames(map),sample_names(phy)))#144 (check that the sample names match in all cases)
  
  #-------------------------------------------
  #ADD METADATA TO PHYLOSEQ OBJECT
  #-------------------------------------------
  sample_data(phy) <- map#assign the metadata to the phyloseq object 'phy' (phyloseq will put these in the right order)
  nsamples(phy)#144
  ###################################
  #SOME ADDITIONAL ANNOTATIONS (INFO IN SAMPLE NAMES) ARE REQUIRED
  head(sample_data(phy))
  sample_data(phy)$group <- sample_names(phy)
  sample_data(phy)$group <- gsub("[0123456789]","",sample_data(phy)$group)#remove all numbers to create groups based on sample names
  #needs some cleaning (inconsistent use of underscores in metadata file, i.e. "_" vs. "__"
  sample_data(phy)$group
  
  sample_data(phy)$group <- gsub("blank_","blank",sample_data(phy)$group)#replace "blank_" with "blank"
  sample_data(phy)$group <- gsub("preg_ko_nv_","preg_ko_nv",sample_data(phy)$group)#replace "preg_ko_nv_" with "preg_ko_nv"
  sample_data(phy)$group <- gsub("pup__g","pup_g",sample_data(phy)$group)#replace "pup__g" with "pup_g"
  sample_data(phy)$group
  str(sample_data(phy)$group)
  unique(sample_data(phy)$group)#check
  sample_data(phy)$group <- as.factor(sample_data(phy)$group)#convert groups to factors (e.g convert from character to factor)
  levels(sample_data(phy)$group)#levels() shows you the levels of factors created.

  print(phy)
  
  treefile <- read_tree(tree)
  print("Printing Tree....")
  print(treefile)
  run1 <-merge_phyloseq(phy,treefile)

  print(run1)
  #### richness plot
  p1=plot_richness(run1)
  jpeg(paste0(outputdir,'/richness.jpg'))
  print(p1)
  dev.off()
  #### heatmap
  gpt <- subset_taxa(phy, Kingdom=="Bacteria")
  gpt <- prune_taxa(names(sort(taxa_sums(gpt),TRUE)[1:500]), gpt)
  p1=plot_heatmap(gpt)
  jpeg(paste0(outputdir,'/heatmap.jpg'))
  print (p1)
  dev.off()

  ####ordination plot
  wh0 = genefilter_sample(phy, filterfun_sample(function(x) x > 5), A=0.5*nsamples(phy))
  GP1 = prune_taxa(wh0, phy)
  GP1 = transform_sample_counts(GP1, function(x) 1E6 * x/sum(x))
  phylum.sum = tapply(taxa_sums(GP1), tax_table(GP1)[, "Phylum"], sum, na.rm=TRUE)
  top5phyla = names(sort(phylum.sum, TRUE))[1:5]
  GP1 = prune_taxa((tax_table(GP1)[, "Phylum"] %in% top5phyla), GP1)
  GP.ord <- ordinate(GP1, "NMDS", "bray")

  p1 = plot_ordination(GP1, GP.ord, type="taxa", color="Phylum", title="taxa")
  jpeg(paste0(outputdir,'/ordination.jpg'))
  print(p1)
  dev.off()
  ########### bar plots

  gp.ch = subset_taxa(phy, Phylum == "Firmicutes")
  p1=plot_bar(gp.ch, fill="Genus")
  jpeg(paste0(outputdir,'/barplot.jpg'))
  print(p1)
  dev.off()
  
}
  
