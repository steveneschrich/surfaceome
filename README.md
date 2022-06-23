# Surfaceome
There is a subset of the genome (or proteome) that lives at the cell surface.
This includes things like receptors, but also includes other types of
proteins. This package uses source data from publications to define the surfaceome and implements some tools for working with it.

Note: Most of this package is at present aspirational other than the data.

## Source Data
There are two sources of surfaceome annotation, CSPA and Surfy. See below for details on each of these. This data will be available via data frames within the package.

### CSPA
The Cell Surface Protein Atlas (CSPA, https://wlab.ethz.ch/cspa/) 
profiled a bunch of cells using mass spec to empirically determine what
proteins are on the cell surface. 

These proteins are annotated in:
https://wlab.ethz.ch/cspa/data/S2_File.xlsx

Note: It appears that the S2_File.xlsx is identical to pone.0121314.s003.xlsx from the publication. The file itself consists of three different sheets. From the publication:
```
S2 File: CSPA validated surfaceome proteins. Excel file containing all human and mouse surfaceome proteins in two tables and an additional table with all identified N-glycopeptides. A. List of 1492 human surfaceome proteins and their annotation. B. List of 1296 mouse surfaceome proteins and their annotation. C. List of 13942 mouse and human derived N-glycopeptides, including identified modified form.
```

The sheet of interest is Sheet A (called 'Table A' in the spreadsheet).

### SURFY
This group also used machine learning to try and predict all of the
cell surface proteins in the proteome, training from the CSPA. It used
information on sequence and domains to do these predictions.

These proteins are annotated in:
http://wlab.ethz.ch/surfaceome/table_S3_surfaceome.xlsx

The "in silico surfaceome only" tab has the information (source can be
machine learning, pos. trainingset or GPI (Uniprot). The total is
2,886 proteins. There is a 'UniProt gene' column with a gene name. There is
also a column 'GeneID' which might be more robust to changes in names
(if it's present).


## Summarization
Although you can use the individual gene/protein measurements as individual members of the surfaceome, you can also summarize these to a single measure. Note this is not always desireable, as the difference in specific markers is what is most important. However, if you are interested in summarizing there are two approaches:

- PCA
- ssgsea

With this, we can score the surfaceome overall or provide individual measures by different categories.

## Visualization
This is not yet implemented, however the goal of this part of the package is to provide visualization functions for gene expression and/or protein data. Look at it like immunophenogram, heatmap of samples for surfaceome but separated out by category (assignment) or class.

Note: from the literature I have seen PCA and heatmap visualizations of the surfaceome hence the thought that this would be appropriate.
