**Note: ** The 'Main Code' file only contains code generated to make the in-manuscript figures and supplemental figures.

# scAlxMApps

Both of these apps provide an interactive environment for engaging feature plots from Seurat (the "Seurat app") and similar feature maps from analyses using monocle3 (the "monocle3 app").

The dataset the Seurat app uses comes from transgenic (fli1a:EGFP;sox10:mRFP), post-migratory zebrafish neural crest cells (NCCs). Double-positive transgenic cells from sorting were transcriptomically analyzed at the single-cell level. In the app, you can see that these analyses resolved NCCs segregating into four distinct populations.

https://apulvino.shinyapps.io/sAlxMapp/

The dataset the monocle3 app uses comes from the same set of neural crest cells as the Seurat app. This data however is made up of only cells subset from the frontonasal cluster. In the app, you can also see the lineage hierarchies that were traced using monocle3. When searching for Alx3 or Alx4a, you can see enrichment along a single branching trajectory. From this observation, we have hypothesized these genes may contribute to specifying medial versus lateral cell identity in frontonasal NCCs.

https://apulvino.shinyapps.io/mAlxMapp/

When searching for particular genes of interest, the feature plots will update live. Plots can also be generated in side-by-side views for making comparisons between different gene's expression patterns.
