library(reticulate)
#use_python("~/anaconda/lib/python2.7")
os <- import("os")
os$getcwd()
#py_install("requests")
#py_install("beautifulsoup4")

#import(requests)
use_condaenv("r-reticulate")
conda_install("r-reticulate","requests")
conda_install("r-reticulate","beautifulsoup4")
#requests<-import("requests")

py_run_file("../../Python/downloader.py")

    
    
