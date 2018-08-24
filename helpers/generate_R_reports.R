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
  outputdir="rReports"
  dir.create(outputdir, showWarnings = FALSE) 
  
  phy <-import_biom(otufile,verbose = TRUE) # import BIOM file
  sample_names(phy) <- sub("\\/1","",sample_names(phy)) # remove "/1" from filenames
  
  colnames(tax_table(phy)) <-  c("Kingdom", "Phylum" , "Class" , "Order" , "Family" , "Genus", "Species") #e.g. replace "Rank1" with "Kingdom"
  
  # Clean taxonomic annotations, at the moment they are for example 'k__Bacteria'; 'p_Firmicutes' - remove k__ and p__ ...
  tax_table(phy)[,"Kingdom"] <- sub("k__","",tax_table(phy)[,"Kingdom"])
  tax_table(phy)[,"Phylum"] <- sub("p__","",tax_table(phy)[,"Phylum"])
  tax_table(phy)[,"Class"] <- sub("c__","",tax_table(phy)[,"Class"])
  tax_table(phy)[,"Order"] <- sub("o__","",tax_table(phy)[,"Order"])
  tax_table(phy)[,"Family"] <- sub("f__","",tax_table(phy)[,"Family"])
  tax_table(phy)[,"Genus"] <- sub("g__","",tax_table(phy)[,"Genus"])
  tax_table(phy)[,"Species"] <- sub("s__","",tax_table(phy)[,"Species"])
  
  map <-import_qiime_sample_data(mapfile)  
  sample_data(phy) <- map # assign the metadata to the phyloseq object
  
  treefile <- read_tree(tree)
  phy.tree <-merge_phyloseq(phy,treefile) # add tree file

  #### richness plot
  p1=plot_richness(phy.tree)
  jpeg(paste0(outputdir,'/richness.jpg'))
  print(p1)
  dev.off()
  #### heatmap
  gpt <- subset_taxa(phy.tree, Kingdom=="Bacteria")
  gpt <- prune_taxa(names(sort(taxa_sums(gpt),TRUE)[1:500]), gpt)
  p1=plot_heatmap(gpt)
  jpeg(paste0(outputdir,'/heatmap.jpg'))
  print (p1)
  dev.off()
  #### bar plots
  p1=plot_bar(phy.tree, fill="Genus")
  jpeg(paste0(outputdir,'/barplot.jpg'))
  print(p1)
  dev.off()
}
