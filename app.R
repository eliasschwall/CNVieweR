library(shiny)
library(bslib)
library(DT)

# Source the Quarto document with the CNVieweR modules
knitr::knit("CNVieweR_modules.qmd", output = tempfile()) 

# Home page
ui <- fluidPage(
    theme = shinythemes::shinytheme("flatly"),
    tags$style(HTML("
    .radio label {
      display: block;
      margin-bottom: 10px;
    }
  ")),
    titlePanel("CNVieweR"),
    p("With this app you can look into your CNV data and get a feel for your data before performing downstream analysis."),
    tabsetPanel(
        id = "tabs",  
        tabPanel("Data Copy number variation of NLR genes", 
                 upload_data_ui("data"),
                 plot_data_ui("plot")),
                
        tabPanel("Orthocluster Visualization", 
                 upload_advanced_data_ui("fisnacht_data"),
                 plot_fisnacht_ui("fisnacht_plot")),
        
        tabPanel("Contig Counts",
                 upload_contig_counts_data_ui("contig_data"),
                 plot_contig_counts_ui("contig_counts_plot")),
        
        tabPanel("Contig Length",
                 upload_contig_length_data_ui("contig_length_data"),
                 plot_contig_length_ui("contig_length_plot")),
        
        tabPanel("Mapping Ratios",
                 upload_mapping_ratios_ui("mapping_ratios_data"),
                 plot_mapping_ratios_ui("mapping_ratios_plot")),
        
        tabPanel("Mapping Stats",
                 upload_mapping_stats_ui("mapping_stats_data"),
                 plot_mapping_stats_ui("mapping_stats_plot")),
        
        tabPanel("pan-NLRome",
                 upload_pan_NLRome_ui("pan_NLRome_data"),
                 plot_pan_NLRome_ui("pan_NLRome_plot"))
    )
)

# Server logic
server <- function(input, output, session) {
    # Call the data upload server module and store the returned reactive data
    uploaded_data <- callModule(upload_data_server, "data")
    
    # Pass the uploaded data to the plot module
    callModule(plot_data_server, "plot", data = uploaded_data)
    
    # Call the new advanced data upload and plot modules
    fisnacht_data <- callModule(upload_advanced_data_server, "fisnacht_data")
    callModule(plot_fisnacht_server, "fisnacht_plot", data = fisnacht_data)
    
    contig_data <- callModule(upload_contig_counts_data_server, "contig_data")
    callModule(plot_contig_counts_server, "contig_counts_plot", data = contig_data)
    
    contig_length_data <- callModule(upload_contig_length_data_server, "contig_length_data")
    callModule(plot_contig_length_server, "contig_length_plot", data = contig_length_data)
    
    mapping_ratios_data <- callModule(upload_mapping_ratios_server, "mapping_ratios_data")
    callModule(plot_mapping_ratios_server, "mapping_ratios_plot", data = mapping_ratios_data)
    
    mapping_stats_data <- callModule(upload_mapping_stats_server, "mapping_stats_data")
    callModule(plot_mapping_stats_server, "mapping_stats_plot", data = mapping_stats_data)
    
    pan_NLRome_data <- callModule(upload_pan_NLRome_server, "pan_NLRome_data")
    callModule(plot_pan_NLRome_server, "pan_NLRome_plot", data = pan_NLRome_data)
}

# Run the application
shinyApp(ui = ui, server = server)