# Nematode_R
Project analyzing gene expression data from C. elegans embryos using R

Summary: 

  The scripts in this repository were written to extract data from the .csv output files from the Murray lab's implementation of 
StarryNite, specifically all files output from the perl function ./GetFiles.pl <list of movies> located in the tools3 directory.

  The scripts here will extract and aggregate all SCD files and auxillary info files. Then the blot data (the preferred measure of 
reporter quantification) is aggregated and normalized by two methods: Z axis position and scaling to a reference embryo.
The normalized blot data can then be graphically subsetted for cells with high reporter expression or variability at certain time points in 
embryogenesis.

  Reporter expression can then be plotted either for individual cells or for lineages of cells in the embryo, showing both 
  mean expression and variability over time and through cell divisions.
  
Scripts:

    SCD_pipeline.R  
    
    This script includes functions to import, trim, normalize and subset data for desired characteristics.
            Functions:
                      SCDProcess.R
                      ImportSCD.R
                      trimmingSCD.R
                      GroupEmb.R
                      Cell_Timeline.R
    
    Expression_Analysis.R
    
    This script analyses normalized data generated by SCDProcess.R / SCD_pipeline.R. It subsets data for cells with CV or mean expression
    of desired nature (high / low expression ; high / low variability). Reporter expression can then be plotted for specific cells or
    lineages of cells.
    
            Functions:
                      NormView.R
                      Sortblot2.R
                      PlotAllCells.R
                      PlotCell.R
                      PlotList.R
  
  Function glossary
  
  Filename        Function name (arguments)
  
  SCDProcess.R    SCDProcess(lineage, Rawdir)
                  Wrapper function to perform ImportSCD.R, trimmingSCD.R, GroupEmb.R, and Cell_Timeline.R. Takes two arguments: lineage 
                  (name of worm strain in .csv file names), Rawdir (directory containing data files)
  
  ImportSCD.R     ImportSCD(Directory)
                  ImportSCD extracts all SCD files present inside specified directory and outputs a list of data.frames
                  
                  Argument
                          Directory         Raw directory containing SCD files
                
  trimmingSCD.R   Trimming(df, Rawdir)
                  Trimming takes list of data.frames and trims empty values, aggregates all blot
                  data together, then creates a time column for blot data. Trimming also runs RepAuxInfo.R, a function that
                  extracts aux info .csv files and aggregates them. Specifically Trimming(..) assigns NA to blot values
                  in SCD files where x = 0 and y = 0, OR gweight = 0.
                  
                  Argument
                          df                list of data.frames that is the output of ImportSCD.R
                          Rawdir            directory containing raw data and auxinfo.csv files
                          
  RepAuxInfo.R    RepAuxfiles(Rawdir)
                  RepAuxfiles assembles all files ending in "AuxInfo.csv" and combines them into data frame
                  
                  Argument
                          Rawdir            name of directory containing files
  
  GroupEmb.R      GroupEmb(listdf)
                  GroupEmb groups SCD files by axis orientation (Left and Right) of embryo during imaging. Grouping is
                  specified by data from RepAuxInfo.R (run inside trimmingSCD.R). Outputs two lists of dataframes corresponding
                  to each orientation.
                  
                  Argument
                          listdf            list of data frames, output from trimmingSCD.R

  Cell_Timeline.R BlotTime(listdf, groupdf)
                  BlotTime normalizes blot data to Z-plane, then normalizes it to a reference embryo. All this is done on axis-
                  grouped blot data as well as combined blot data. BlotTime then computes average blot values for each cell,
                  then deletes now un-needed SCD data files from data structure. Output is list of data frames.
                  
                  Argument
                          listdf            list of data frames, output from trimmingSCD.R
                          groupdf           list of data frames, output from GroupEmb.R
                          
  NormView.R      NormView(listdf, dataname)
                  NormView assesses the success of normalization in Cell_Timeline.R. Plots mean versus SD of cell averaged
                  Z-normalized blot data against Z- and reference-embryo normalized blot data. Outputs pdf file
                  
                  Argument
                          listdf            list of data frames, output from Cell_Timeline.R
                          dataname          name of dataset, for plot and file names.
                          
  Sortblot2.R     Sortblot2(listdf,ChangeCVPar = NA, ChangeCVDt = NA, MeanLo = 0, MeanHi = Inf, CVLo = 0, CVHi = Inf,MaxTime= )
                  Sortblot2 is a wrapper that runs Sortblot.R on axis-grouped data. See entry for Sortblot.R for details
                  
                  
                        
  Sortblot.R.     Sortblot(df, CVchangePar = NA, CVchangeDt = NA, LoMean = 0, HiMean = Inf, LoCV = 0,  HiCV = Inf, 
                            TimeMax = Inf, outnames = FALSE)
                            
                  Argument
                          df                data frame of normalized blot data, output from Cell_Timeline.R
                          CVchangePar        Specifies cells with different reporter variability than their parent cells. 
                                            E.g. value of 2.0 finds cells with CV values more than double their parents.
                                            Value of 0.5 finds cells with CV values less than 1/2 their parents.
                          CVchangeDt        Specifies cells with different reporter variability than their daughter cells. 
                                            E.g. value of 2.0 finds cells with CV values less than half their daughters.
                                            Value of 0.5 finds cells with CV values greater than double their daughters.
                          LoMean            Screens cells with mean reporter expression above this threshold.
                          HiMean            Screens cells with mean reporter expressiion below this threshold.
                          LoCV              Screens cells with reporter CV values above this threshold.
                          HiCV              Screens cells with reporter CV values below this threshold.
                          TimMax            Screen cells for those with initial time points before a certain SCD time
                          outnames          logical operator that specifies whether to output vector of cell names that meet                                               above criteria.
                          
  PlotAllCells.R  PlotAllCells(LoCell = 1, HiCell = length(df$ID), df, sdf,  sort = "blot", outnames = FALSE) 
                  PlotAllCells is a function that plots the mean and CV reporter expression from a cell-averaged blot data
                  frame, for cursory visualization to identify cells of interest. The default settings sorts the cells in
                  ascending mean blot value, but can also sort by time, CV, or lineage identity
                  
                  Argument
                          LoCell            Index of first cell to be plotted. Default value plots from first cell.
                          HiCell            Index of last cell to be plotted. Default plots all cells.
                          df                dataframe containing cell averaged blot data, e.g. (output from Sortblot2.R:
                                            Data_C$SortAvCellBlot$Both)
                          sdf               name of data structure containing source data, in above example (Data_C)
                          sort              Specifies method of ordering data. Possible values are "blot", "CV", "time" and
                                            "lineage".
                          outnames          logical operator to suppress plot and output vector of cell names that can be
                                            plotted by PlotList.R
                                            
  Plotcell.R      Plotcell(CellID, df, sdf, namecol = 2, ancestors = FALSE, outdata = FALSE)
                  Function to plot expression of cell over course of its lifespan or entire lineage. Takes single argument of                    cell name in character form and dataframe of normalized blot data to draw from.
                  
                  Argument
                          CellID            name of desired cell to plot
                          df                data frame containing normalized blot data
                          sdf               name of data structure containing all data (e.g. Data_C)
                          namecol           specifies how many columns at left of dataframe to exclude from summary statistics
                          ancestors         specifies whether to plot single cell trajectory or entire lineage.
                          outdata           logical operator that specifies whether to output summary 
                                            statistics for desired cell(s).
                                            
  PlotList.R      PlotList(list, df, sdf, name = NA, Redundant = FALSE)
                  Function to plot lineages of a list of cells, and output to a pdf file.
                  
                  Argument
                          list              character vector of cell names to plot
                          df                source data frame of blot data
                          sdf               name of data structure containing blot data
                          name              filename e.g. ("C lineage reporter expression.pdf")
                          Redundant         logical operator to either remove redundant cell lineages
                          
  That's it! Congratulations for reaching one of the many obscure corners of the internet, where you can be reasonably certain    you're the only person reading this. Spooky. RWT 2015

                          
                   
                    
                      


