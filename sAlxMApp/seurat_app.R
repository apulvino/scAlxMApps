install.packages("shinymanager")
library(shinymanager)
library(shiny)
#install.packages("Seurat")
library(Seurat)
library(shinyWidgets)
library(ggplot2)
library(gridExtra)

credentials <- data.frame(
  user = c("shiny", "shinymanager"), # mandatory
  password = c("azerty", "12345"), # mandatory
  start = c("2019-04-15"), # optinal (all others)
  expire = c(NA, "2019-12-31"),
  admin = c(FALSE, TRUE),
  comment = "Simple and secure authentification mechanism 
  for single ‘Shiny’ applications.",
  stringsAsFactors = FALSE
)

#gene_name <- read.csv("/Users/anthonypulvino/NicholsLabwork/scAlxWork/sAlxMapp/nichols_combined_markers.csv")
#gene_name <- gene_name[,2]
#write.csv(gene_name, "/Users/anthonypulvino/NicholsLabwork/scAlxWork/sAlxMapp/nichols_combined_markers.csv")
#nichols_umap_clusters_diet <- DietSeurat(nichols_umap_clusters, 
                                      #   counts = TRUE,
                                       #  data = TRUE,
                                       #  dimreducs = c("umap"))
#saveRDS(nichols_umap_clusters_diet, "/Users/anthonypulvino/NicholsLabwork/scAlxWork/sAlxMapp/nichols_umap_clusters_diet.rds")
#gene_name[,1] <- NULL
#colnames(gene_name) <- "gene_short_name"
#saveRDS(gene_name, "/Users/anthonypulvino/NicholsLabwork/scAlxWork/sAlxMapp/nichols_combined_markers.rds")

#setwd("/Users/anthonypulvino/NicholsLabwork/scAlxMApps/sAlxMApp")
#nichols_umap_clusters_diet <- readRDS("nichols_umap_clusters_diet.rds")
#gene_name <- readRDS("WholeGeneList.rds")

dietUMAPurl <- url("https://github.com/apulvino/scAlxMApps/blob/main/sAlxMApp/nichols_umap_clusters_diet.rds?raw=true")
nichols_umap_clusters_diet <- readRDS(dietUMAPurl)
gene_nameURL <- url("https://github.com/apulvino/scAlxMApps/blob/main/sAlxMApp/WholeGeneList.rds?raw=true")
gene_name <- readRDS(gene_nameURL)

#gene_List <- rownames(nichols_dr_seurat@data)
#View(gene_List)

ui <- fluidPage(
  
  tags$head(includeHTML(("google-analytics.html"))),
  <!-- Google tag (gtag.js) -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-EGDVC7YT5J"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'G-EGDVC7YT5J');
</script>
  tags$h2("My secure application"),
  verbatimTextOutput("auth_output")
  )

# Wrap your UI with secure_app
ui <- secure_app(ui)
  titlePanel("Zebrafish NCC FeaturePlot Generator (from Seurat analysis)"),
  
    #Precursor cartilage and bone cells are required to move to specific locations over the course of craniofacial development in vertebrates. 
    #These 'precursors' in question, cranial neural crest cells (NCCs), arrive at their final destinations in the skeleton of the head to specify unique cell types.
    #Four of these cell types are represented in the feature plots below. We identified each of these populations of single cells by discovering enrichment of 
    #particular genes in each of the four different populations.Searching 'alx3' or 'alx4a' indicates specific enrichment of the gene in the frontonasal cluster of cells.  
    #We can more confidently indicate the group of cells enriched in these genes to all be frontonasal.
  
  tags$p("Double transgenic (fli1a:EGFP;sox10:mRFP), post-migratory zebrafish NCCs were harvested at 24 hpf and dissociated into single-cell suspension for FACS. 
         Double-positive transgenic cells from sorting were transcriptomically analyzed at the single-cell level with Seurat. 
         Analyses resolved NCCs segregating into four distinct populations. Genes enriched in each cluster indicate population identity. "), 
  
        
  tags$p("For example, searching 'alx3' or 'alx4a' indicates an enrichment in a particular group of cells within the frontonasal cluster. This observation
        suggests alx family genes may be important to the developmental regulation of a particular subtype of frontonasal cell."),
 
  tags$p("Explore where your specific gene(s) of interest appear across our cranial neural crest cell populations below."),
  
  
  #selectizeInput(inputId = "gene_name", label = "Search or select your gene(s) of interest:", 
   #             multiple = TRUE, choices = gene_name, selected = "alx3"),
  
  multiInput(inputId = "gene_name", label = "Select your gene(s)", choices = gene_name, selected = c("alx3")),
  
  tags$p("Generated below is a feature map of the gene(s) you selected based on their per-cell log10 expression values across our entire single cell dataset."),

  
  plotOutput("FeaturePlot"),
  
  tags$p("Visit us @", tags$a(href = "https://www.nicholslab.org/", "Nichols Lab")),
  tags$p("Code and data on", tags$a(href = "https://github.com/apulvino/scAlxMApps", "GitHub"))
  
)

server <- function(input, output, session) {
  

    output$FeaturePlot <- renderPlot({
      req(input$gene_name)
      
      title <- "FeaturePlot"
      
       FeaturePlot(nichols_umap_clusters_diet, features = input$gene_name,
            reduction = "umap", cols = c("grey","blue"), label = TRUE, 
            label.size = 4.5, pt.size = 1.5, ncol = 3) + xlim(-10, 10) + ylim(-10, 15)
       

    })
  
  
}

shinyApp(ui, server)
