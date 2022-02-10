install.packages( 'ggplot2' )
install.packages( 'reshape2' )
library( ggplot2 )

library( reshape2 )

scenario_names <- c("big_bottle",
                    "big_bottle_admix",
                    "big_bottle_admix_no_recovery",
                    "big_bottle_expansion",
                    "big_bottle_no_recovery",
                    "constant_size",
                    "small_bottle",
                    "small_bottle_no_recovery"
                    )

results <- list(grandparent_child = c(),
                sibling = c(),
                parent_child = c(),
                uncle_child = c(),
                cousins = c() )

all_data <- list()

gran <- c(6,7,12,13)
sib <- 20
parent <- c(3,5,9,11,17,23,25,27)
uncle <- c(24,26)
cous <- 28

for( scenario in scenario_names ){
    input_folder_name <- paste0( c('~/neomatrix/team3/ngs_relate_outputs', scenario), collapse = '/' )
    results <- list(grandparent_child = c(),
                sibling = c(),
                parent_child = c(),
                uncle_child = c(),
                cousins = c() )
    files <- list.files( input_folder_name )
    for( file_name in files ){
        full_name <- paste0( c( input_folder_name, file_name), collapse = '/' )
        temp_data <- read.table( full_name, header = TRUE, sep = '\t', quote = '' )
        results$grandparent_child <- c( results$grandparent_child, temp_data[gran,16] )
        results$sibling <- c( results$sibling, temp_data[sib,16] )
        results$parent_child <- c( results$parent_child, temp_data[parent,16] )
        results$uncle_child <- c( results$uncle_child, temp_data[uncle,16] )
        results$cousins <- c( results$cousins, temp_data[cous,16] )
    }
    all_data[[scenario]]  <- results
}

all_data[[1]]

to_plot <- melt( all_data )

colnames(to_plot) <- c( 'theta', 'relationship', 'scenario' )

summary( to_plot )



head(to_plot)

plot <- ggplot( data = to_plot, mapping = aes( y = theta, x = scenario ) )
plot <- plot + geom_boxplot()
plot <- plot + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
## plot <- plot + coord_flip()
plot <- plot + facet_wrap( ~relationship, ncol = 5 )


ggsave( 'test_V2.pdf',plot )

