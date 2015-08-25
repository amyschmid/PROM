# PROM
#Integration of regulatory transcription and metabolic networks of Halobacterium salinarum: 

###A pipeline for genome-scale transcriptional and metabolic model of Halobacteirum salinarum.

* This repository contains the code necessary to run:
 * flux balance analysis (FBA) on H. salinarum.
 * integrative FBA model that probabilistically constrains gene states and gene-transcription factor interactions.
 * hit-and-run sampler for analyzing the metabolic flux space of H. salinarum.

### This work utilizes the following models/tools/data:
 * An FBA model of H. salinarum in:
> Gonzalez, O., Gronau, S., Falb, M., Pfeiffer, F., Mendoza, E., Zimmer, R., & Oesterhelt, D. (2008). Reconstruction, modeling & analysis of Halobacterium salinarum R-1 metabolism. Molecular BioSystems, 4(2), 148-159.

 * Probabilistic integration of gene expression levels and gene-transcription interaction network as FBA model constraints in:
> Chandrasekaran, S., & Price, N. D. (2010). Probabilistic integrative modeling of genome-scale metabolic and regulatory networks in Escherichia coli and Mycobacterium tuberculosis. Proceedings of the National Academy of Sciences, 107(41), 17845-17850.

 * Gene-TrmB interaction network in:
> Schmid, A. K., Reiss, D. J., Pan, M., Koide, T., & Baliga, N. S. (2009). A single transcription factor regulates evolutionarily diverse but functionally linked metabolic pathways in response to nutrient availability. Molecular systems biology, 5(1), 282.

 * Gene expression data in:
> The Gene Expression Omnibus database at accession number 13531 and
> The Institute of Systems Biology Gaggle repository (http://gaggle.systemsbiology.net/docs/)

### This repository has several dependencies including:
 * GLPK (GNU Linear Programming Kit) and GLPKMEXm (a MATLAB MEX interface for the GLPK library).
we recommend (https://github.com/blegat/glpkmex)
 * SBMLToolbox (http://sbml.org/Software/SBMLToolbox)
 * libSMBL (http://sbml.org/Software/libSBML)
 * Cobra toolbox (https://opencobra.github.io)
 * MCMCstat (http://helios.fmi.fi/~lainema/mcmc/)
 
### Structure of repository
 * **_model_defintion**: text files for defining the FBA model of Halobacterium salinarum based on the reconstruction by Gonzalez et al. 
  
 * **_fba_only** and **_axu_scripts**: MATLAB FBA model of H. salinarum.
  
 * **_microarray_data**: text files for gene expression data from Gaggle and Gene Expresion Omnibus.
  
* **_regulator_network**: text files for gene-TrmB interaction network based on suppleemental tables in Schmid et al. 
  
* **_main_scripts**: MATLAB scripts for probabilistic integration of gene expression and gene-TrmB interaction network to FBA model of H. salinarum, based on PROM by Chandrasekaran et al. 
 
* **_mcmc_sampler**: MATLAB scripts for sampling and analyzing the metabolic flux space of H. salinarum.  
  
* **_dependencies**: folder including dependencies necessary for this repository.
