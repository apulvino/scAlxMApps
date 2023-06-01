#library(rsconnect)
#rsconnect::deployApp('/Users/anthonypulvino/NicholsLabwork/scAlxMApps/mAlxMApp/')

#options(repos = c(CRAN = "https://cran.rstudio.com"))
options(repos = BiocManager::repositories())
#if (!requireNamespace("BiocManager", quietly = TRUE))
#  install.packages("BiocManager")
#BiocManager::install()
library(BiocManager)
#BiocManager::install("BiocNeighbors", update = TRUE)
library(BiocNeighbors)
library(ggplot2)
library(monocle3)
#added these libraries after installing the above packages to make sure I have everything I need in running the succeeding code -ATP 
#library(Seurat)
library(gridExtra)
library(shiny)
#install.packages("shinydashboard")
library(shinydashboard)
library(data.table)
#runExample("01_hello")
#install.packages("shinyWidgets")
library(shinyWidgets)
#install.packages("Rhdf5lib")
#library(Rhdf5lib)
library(hdf5r)
library(S4Vectors)

#nichols_dr_seurat <- readRDS("/Users/anthonypulvino/NicholsLabwork/scAlxWork/nichols_dr_seurat_2019.rds") 
#whatever the location of the file download

#monocle_gene_names <- rownames(cds_from_seurat@assays@data$counts)
#saveRDS(monocle_gene_names, "/Users/anthonypulvino/NicholsLabwork/scAlxWork/mAlxMapp/monocle_gene_names.rds")
#gene_name <- readRDS("monocle_gene_names.rds")
#setwd("/Users/anthonypulvino/NicholsLabwork/scAlxMApps/mAlxMApp")
#Nichols_cds_subset <- readRDS("Nichols_cds_subset.rds")
#gene_name <- readRDS("monocle_gene_names.rds")

FNcds_URL <- url("https://github.com/apulvino/scAlxMApps/blob/main/mAlxMApp/Nichols_cds_subset.rds?raw=true")
Nichols_cds_subset <- readRDS(FNcds_URL)
gene_nameURL <- url("https://github.com/apulvino/scAlxMApps/blob/main/mAlxMApp/monocle_gene_names.rds?raw=true")
gene_name <- readRDS(gene_nameURL)

ui <- fluidPage(
  tags$head(includeHTML(("google-analytics.html"))),
  
  <!-- Google tag (gtag.js) -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-PKTJRJS81W"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'G-PKTJRJS81W');
</script>
  
  titlePanel("Frontonasal Feature Map Generator (from monocle3 analysis)"),
  
  
    #Precursor cartilage and bone cells are required to move to specific locations over the course of craniofacial development in vertebrates. 
    #These 'precursors' in question, cranial neural crest cells (NCCs), arrive at their final destinations in the skeleton of the 
  
  
  
  
  to specify unique cell types.
    #One of these specialized cell types, frontonasal cells, are represented in the feature maps you can generate below.
  
    #Using the Monocle3 software, we were able to chart a lineage hierarchy across our frontonasal cells. Here, black nodes represent an undifferentiated
    #cell state while the gray nodes represent a decided cell fate decision. These trajectories are especially useful in context with knowledge
    #about a gene's expression pattern. For example, searching for alx3 or alx4a, we see enrichment along the trajectory connecting nodes 1 and 3. This indicates that both of these
    #genes may be playing a role in determining the fate of a particular frontonasal cell subtype from a less differentiated state to one that is more derived.  
  
  tags$p("Analyses employing the monocle3 software predict a branching lineage trajectory across double transgenic (fli1a:EGFP;sox10:mRFP), post-migratory frontonasal NCCs at 24 hpf.
         From a principal black colored node (representing the most immature cell), three alternative trajectories branch toward gray colored nodes (representing mature, late cell states)."),
  
  tags$p("alx3 and alx4a expression are strongly enriched along a single trajectory.
         We propose that alx3 functions in post-migratory, frontonasal NCCs to specify medial versus lateral identity in the zebrafish upper face skeleton.
         Keep in mind that the genes you search here will be only from the frontonasal cells in our dataset."),
  
  tags$p("Explore where your frontonasal-specific gene(s) of interest track along our branching trajectories below."),
  
  
  multiInput(inputId = "gene_name", label = "Select your gene(s)", choices = gene_name, selected = c("alx3")),
  
  tags$p("Generated below is a feature map of the gene you searched based on its log10 expression values per cell across only frontonasal cells."),
  
  #actionBttn(inputId = "Go", label = "Go"),
  
  plotOutput("plot_cells"),
  
  tags$p("Visit us @", tags$a(href = "https://www.nicholslab.org/", "Nichols Lab")),
  tags$p("Code and data on", tags$a(href = "https://github.com/apulvino/scAlxMApps", "GitHub"))
  
)

server <- function(input, output, session) {
  output$plot_cells <- renderPlot({
    gene_list <- input$gene_name
    req(gene_list)

    title <- "plot_cells"
    
    plot_cells(Nichols_cds_subset, genes = gene_list, cell_size = 1.5, graph_label_size = 3, group_label_size = 4) + theme(plot.title = element_text(size = 25))
                  

    
  })
  
  
}

shinyApp(ui, server)




