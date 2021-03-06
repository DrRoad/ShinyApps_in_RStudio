## cpt_3a_column -- eCPT for Reach & CPT

ecpt_reach_cptUI <- function(id){
  ns <- NS(id)
  tabPanel("a. eCPT (Reach/CPT)", plotlyOutput(ns("cpt_3a_column")))
}

ecpt_reach_cptSERVER <- function(input,output,session,country){
  
  data_column <- reactive({mrr_ecpt %>%
      filter(country %in% country()) %>%
      group_by(month,type) %>%
      summarise(ecpt = round(sum(mrr)/sum(transactions),1))})
  
  data_line <- reactive({mrr_ecpt %>%
      filter(country %in% country()) %>%
      group_by(month) %>%
      summarise(ecpt = round(sum(mrr)/sum(transactions),1)) %>%
      mutate(type = 'Overall')})
  
  output$cpt_3a_column <- renderPlotly({
    p <- (ggplot() +
            geom_bar(data = data_column(),
                     aes(x=month, y=ecpt, fill=type),
                     stat = "identity", position = "dodge") +
            
            geom_line(data = data_line(),
                      aes(x=month, y=ecpt, group=type), size = 0.5) +
            
            scale_x_date(date_breaks = "1 months", date_labels = "%b-%y") +
            theme_gdocs() + scale_fill_wsj() + scale_colour_hue() +
            
            theme(axis.text.x = element_text(size = 10),
                  axis.text.y = element_text(size = 10),
                  axis.title = element_text(size = 12),
                  legend.text = element_text(size = 10),
                  legend.position = "bottom",
                  legend.justification = "center",
                  # legend.direction = "horizontal",
                  legend.title = element_blank(),
                  text = element_text(family = "Palatino Linotype")))
    
    ggplotly(p, width = 900, height = 400, tooltip = c("x", "y"))
  })
}