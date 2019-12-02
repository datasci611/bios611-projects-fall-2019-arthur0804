build-r: Dockerfile.tidyverse
	docker build -t dockerrtidy . -f Dockerfile.tidyverse && \
	touch $@

result/Project3.html:
	Rscript -e "rmarkdown::render('./script/Project3.Rmd','html_document',output_dir = './result/')"
