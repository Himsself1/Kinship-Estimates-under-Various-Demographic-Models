install.packages('vcfR')
library( 'vcfR' )

test.data <- read.vcfR( file = "vcfs/big_bottle/big_bottleneck_output_249.vcf" )

find_CM <- function( vcf_data, recomb_rate ){
    
    start <- as.numeric(vcf_data@fix[1,2])
    temp <- as.numeric(vcf_data@fix[,2]) - start
    return( temp*recomb_rate )
    
}

make_gen_map <- function( vcf_data, recomb_rate ){
    centimorgans <- find_CM( vcf_data, recomb_rate )
        gen_map <- data.frame(
            chr = noquote(vcf_data@fix[,1]),
            pos = as.numeric(vcf_data@fix[,2]),
            rate = centimorgans
        )
    write.table( gen_map, '~/neomatrix/team3/temp_gen_map.txt', quote = FALSE, sep = '\t', row.names = FALSE, col.names = FALSE )
}

?noquote


"ped-sim -d ~/neomatrix/team3/ped6.def --pois -m temp_map "

scenario_names <- c(## "big_bottle",
                    ## "big_bottle_admix",
                    ## "big_bottle_admix_no_recovery",
                    ## "big_bottle_expansion",
                    ## "big_bottle_no_recovery",
                    "constant_size",
                    "small_bottle",
                    "small_bottle_no_recovery"
                    )

scenario <- scenario_names[1]

for( scenario in scenario_names ){    
    input_folder_name <- paste0( c('~/neomatrix/team3/ped_sim_outputs', scenario), collapse = '/' )
    output_folder_name <- paste0( c( '~/neomatrix/team3/ngs_relate_outputs', scenario), collapse = '/' )
    dir.create( output_folder_name, recursive = TRUE )
    files <- list.files( input_folder_name, '*.vcf.ped.vcf' )
    for( file_name in files ){
        full_name <- paste0( c( input_folder_name, file_name), collapse = '/' )
        output_name <- paste0( c( output_folder_name, '/', file_name, '.ped'), collapse = '' )
        ## vcf_data <- read.vcfR( file = full_name )
        ## make_gen_map( vcf_data, 1.2e-8 )
        command <- paste0( c(
            "ngsRelate -l 0.0 -T GT -c 1 -h",
            full_name,
            '-O',
            output_name), collapse = ' '
            )
        ## print( command )
        system( command )
        ## break
    }
    ## break
}

files
scenario
input_folder_name <- paste0( c('~/neomatrix/team3/vcfs', scenario_names[1]), collapse = '/' )

