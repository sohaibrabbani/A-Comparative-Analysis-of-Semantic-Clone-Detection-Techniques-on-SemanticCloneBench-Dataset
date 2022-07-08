# A Comparative Analysis of Clone Detection Techniques on SemanticCloneBench (SCB) Dataset

## Files
* **statistical-analysis.ipynb** contains code for: 
⋅⋅1. loading results from NIL, CodeBERT, and FACER-CD on SemanticCloneBench Dataset.
⋅⋅2. the comparative analysis of all three tools on SCB Dataset.
* **scb_processed_results.csv** contains clone detection results from all three tools for each java clone-pair in SemanticCloneBench dataset.
* **SemanticCloneBench Dataset:** https://drive.google.com/file/d/1KicfslV02p6GDPPBjZHNlmiXk-9IoGWl/view (taken from the official SemanticCloneBench paper)

## Folder
* **"exhaustive-count"** has the files containing the names of the clones detected by the three tools. The detection status w.r.t tools can be obtained by observing the files' names. For example, 111.txt means FACER, CodeBERT, and NIL detected the clone. The bits in the file name represent the tool in following order: Facer|CodeBERT|NIL (010.txt)
* **NIL** has the replication pack for recreating and running the NIL tool (taken from https://github.com/kusumotolab/NIL)
