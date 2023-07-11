library(shiny)
#install.packages("Seurat")
library(Seurat)
library(shinyWidgets)
library(ggplot2)
library(gridExtra)


# define some credentials
credentials <- data.frame(
  user = c("apulvino", "shinymanager"), # mandatory
  password = c("icanforgive", "itsmyfault"), # mandatory
  start = c("2019-04-15"), # optinal (all others)
  expire = c(NA, "2019-12-31"),
  admin = c(FALSE, TRUE),
  comment = "Simple and secure authentification mechanism 
  for single ‘Shiny’ applications.",
  stringsAsFactors = FALSE
)

dietUMAPurl <- url("https://github.com/apulvino/scAlxMApps/blob/main/sAlxMApp/nichols_umap_clusters_diet.rds?raw=true")
nichols_umap_clusters_diet <- readRDS(dietUMAPurl)
gene_nameURL <- url("https://github.com/apulvino/scAlxMApps/blob/main/sAlxMApp/WholeGeneList.rds?raw=true")
gene_name <- readRDS(gene_nameURL)

library(shiny)
library(shinymanager)

ui <- fluidPage(
    tags$h2("Thank you for authenticating"),
    #verbatimTextOutput("auth_output"),


    tags$head(includeHTML(("google-analytics.html"))),
    
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

# Wrap your UI with secure_app
ui <- secure_app(ui)


server <- function(input, output, session) {
  
  # call the server part
  # check_credentials returns a function to authenticate users
  res_auth <- secure_server(
    check_credentials = check_credentials(credentials)
  )
  
  output$auth_output <- renderPrint({
    reactiveValuesToList(res_auth)
  })
  
  # your classic server logic
  
}

shinyApp(ui, server)




server <- function(input, output, session) {
    # call the server part
    # check_credentials returns a function to authenticate users
    res_auth <- secure_server(
      check_credentials = check_credentials(credentials)
    )
  
    output$auth_output <- renderPrint({
      reactiveValuesToList(res_auth)
    })
  
    # your classic server logic
  

    output$FeaturePlot <- renderPlot({
      req(input$gene_name)
      
      title <- "FeaturePlot"
      
       FeaturePlot(nichols_umap_clusters_diet, features = input$gene_name,
            reduction = "umap", cols = c("grey","blue"), label = TRUE, 
            label.size = 4.5, pt.size = 1.5, ncol = 3) + xlim(-10, 10) + ylim(-10, 15)
       

    })
  
  
}

shinyApp(ui, server)

