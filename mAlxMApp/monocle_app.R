
#library(rsconnect)
#rsconnect::deployApp('/Users/anthonypulvino/NicholsLabwork/scAlxWork/mAlxMapp')



options(repos = BiocManager::repositories())
library(BiocManager)



library(ggplot2)
library(monocle3)
#added these libraries after installing the above packages to make sure I have everything I need in running the succeeding code -ATP 
library(Seurat)



library(shiny)
#install.packages("shinydashboard")
library(shinydashboard)
library(data.table)
#runExample("01_hello")
#install.packages("shinyWidgets")
library(shinyWidgets)


#nichols_dr_seurat <- readRDS("/Users/anthonypulvino/NicholsLabwork/scAlxWork/nichols_dr_seurat_2019.rds") 
#whatever the location of the file download

#monocle_gene_names <- rownames(cds_from_seurat@assays@data$counts)
#saveRDS(monocle_gene_names, "/Users/anthonypulvino/NicholsLabwork/scAlxWork/mAlxMapp/monocle_gene_names.rds")
#gene_name <- readRDS("monocle_gene_names.rds")

#Nichols_cds_subset <- readRDS("NicholsFNsubset.rds")
url_obj <- "https://github.com/apulvino/scAlxMApps/blob/main/mAlxMApp/NicholsFNsubset.rds?raw=true"
Nichols_cds_subset <- readRDS(url(url_obj, method="libcurl"))

#gene_name <- readRDS("monocle_gene_names.rds")
url_names <- "https://github.com/apulvino/scAlxMApps/blob/main/mAlxMApp/monocle_gene_names.rds?raw=true"
gene_name <- readRDS(url(url_names, method="libcurl"))


ui <- fluidPage(
  tags$head(includeHTML(("google-analytics.html"))),
  
  titlePanel("Frontonasal Feature Map Generator (from monocle3 analysis)"),
  
  
    #Precursor cartilage and bone cells are required to move to specific locations over the course of craniofacial development in vertebrates. 
    #These 'precursors' in question, cranial neural crest cells (NCCs), arrive at their final destinations in the skeleton of the head to specify unique cell types.
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
  
  tags$p("Visit us @", tags$a(href = "https://www.nicholslab.org/", "Nichols Lab"))
  
)

server <- function(input, output, session) {
  
  
  output$plot_cells <- renderPlot({
    req(input$gene_name)

    title <- "plot_cells"
    
    plot_cells(Nichols_cds_subset, genes = input$gene_name, cell_size = 1.5, graph_label_size = 3, group_label_size = 4) + theme(plot.title = element_text(size = 25)
)
    
  })
  
  
}

shinyApp(ui, server)




