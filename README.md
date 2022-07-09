# A Comparative Analysis of Clone Detection Techniques on SemanticCloneBench (SCB) Dataset

## Files
* **statistical-analysis.ipynb** contains code for: 
  * loading results from NIL, CodeBERT, and FACER-CD on SemanticCloneBench Dataset.
  * the comparative analysis of all three tools on SCB Dataset.
* **scb_processed_results.csv** contains clone detection results from all three tools for each java clone-pair in SemanticCloneBench dataset.
* **SemanticCloneBench Results.docx** has: 
  * the number of clones detected by the 8 possible combinations of results from all 3 tools. For example, 111 in the table means FACER, CodeBERT, and NIL detected the clone. (Table 2)
  * the results of the code listings given in the paper. (Table 1)
* **SemanticCloneBench Dataset:** https://drive.google.com/file/d/1KicfslV02p6GDPPBjZHNlmiXk-9IoGWl/view (taken from the official SemanticCloneBench paper)

## Folder
* **"data-analysis/exhaustive-count"** has the files containing the names of the clones detected by the three tools. The detection status w.r.t tools can be obtained by observing the files' names. For example, 111.txt means FACER, CodeBERT, and NIL detected the clone. The bits in the file name represent the tool in following order: Facer|CodeBERT|NIL (010.txt)
* **NIL** has the replication pack for recreating and running the NIL tool (taken from https://github.com/kusumotolab/NIL)


CodeBERT's replication pack can be found on https://doi.org/10.5281/zenodo.6361315

FACER-CD's replication pack is available in the folder FACER_Replication_on_SemanticCloneBench
