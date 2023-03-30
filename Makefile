
DOCKERFILES = $(shell find * -type f -name Dockerfile)
#IMAGES =  $(shell sed 's+/Dockerfile++g' $(DOCKERFILES))

MAJOR?=0
MINOR?=1
VERSION=$(MAJOR).$(MINOR)
APP_NAME = "WGAS"



repository ?= app-bio
images = base base-java base-python plink samtools bcftools



.PHONY: shell help build rebuild service login test clean prune


all: $(images)

help:
	@echo ''
	@echo 'Usage: make [Target] [Extra_Arguments]'


#$(echo images | sed 's+build-image-++g'): %:
#	echo "target: " $@
#	docker build -f  $(shell   echo $@ | sed 's+build-image-++g' )/Dockerfile $(shell echo $@ | sed 's+build-image-++g' )

######################### Build Images Section #############################
images_to_build = $(shell  echo $(images) | sed 's/[^ ]* */build-image-&/g')

.PHONY: $(images_to_build)
$(images_to_build): build-image-%: clean-image-%
	@echo "target: " $@
	@echo "context: " ./containers/$(shell   echo $@ | sed 's+build-image-++g' )/Dockerfile
	@docker build \
	-t $(repository)/$(shell   echo $@ | sed 's+build-image-++g'):$(VERSION) \
	-f  ./containers/$(shell   echo $@ | sed 's+build-image-++g' )/Dockerfile \
	./containers/$(shell echo $@ | sed 's+build-image-++g' )
	@docker tag ${repository}/$(shell   echo $@ | sed 's+build-image-++g'):$(VERSION) \
	${repository}/$(shell   echo $@ | sed 's+build-image-++g' ):latest
	@echo 'Done.'
	@docker images --format '{{.Repository}}:{{.Tag}}\t\t Built: {{.CreatedSince}}\t\tSize: {{.Size}}' | \
	grep ${IMAGE_NAME}:${VERSION}


######################### Build Images Section No Cache #############################
images_to_rebuild = $(shell  echo $(images) | sed 's/[^ ]* */rebuild-image-&/g')
images_to_clean = $(shell  echo $(images) | sed 's/[^ ]* */clean-image-&/g')

.PHONY: $(images_to_rebuild)
$(images_to_rebuild): %:
	@echo "target: " $@
	@docker build --no-cache \
	-f  containers/$(shell   echo $@ | sed 's+rebuild-image-++g' )/Dockerfile \
	$(shell echo $@ | sed 's+rebuild-image-++g' )


.PHONY: $(images_to_clean)
$(images_to_clean): %:
	@echo "target: " $@
	@docker rmi $(repository)/$(shell   echo $@ | sed 's+clean-image-++g'):latest  || true



download-reference-data:
		wget --limit-rate=1000k  --directory-prefix=./data/reference/RefAnnotationData/  ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/human_g1k_v37.fasta.gz
		wget --limit-rate=1000k  --directory-prefix=./data/reference/RefAnnotationData/  ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/human_g1k_v37.fasta.fai
		wget --limit-rate=1000k  --directory-prefix=./data/reference/RefAnnotationData/ ftp://ftp.ncbi.nih.gov/snp/organisms/human_9606_b150_GRCh37p13/VCF/All_20170710.vcf.gz
		wget --limit-rate=1000k  --directory-prefix=./data/reference/RefAnnotationData/ ftp://ftp.ncbi.nih.gov/snp/organisms/human_9606_b150_GRCh37p13/VCF/All_20170710.vcf.gz.tbi

download-ref-panel:
		wget --limit-rate=1000k  --directory-prefix=./data/reference/RefPanel/  https://mathgen.stats.ox.ac.uk/impute/1000GP_Phase3.tgz
		wget --limit-rate=1000k  --directory-prefix=./data/reference/RefPanel/  https://mathgen.stats.ox.ac.uk/impute/1000GP_Phase3_chrX.tgz



duild-hisat2-ref-gene-index:
		docker run --rm -v ./data/dataset1/:/data  app-bio/hisat2 hisat2-build -p 6  -f /data/ref-gene/GCF_000001635.27_GRCm39_genomic.fna  /data/ref-gene/hisat2-index-GRCm39/GRCm3


create-pipeline-folder-structure:
		mkdir -p ./data/raw-samples
		mkdir -p ./data/reference/RefPanel
		mkdir -p ./data/reference/RefAnnotationData
		mkdir -p ./data/pipeline/01-01-Rename-Chromosomes
		mkdir -p ./data/pipeline/01-02-Alligne-To-Ref-Annotation
		mkdir -p ./data/pipeline/01-03-Short-Alligned-File
		mkdir -p ./data/pipeline/01-04-Convert-Shorted-File
		mkdir -p ./data/pipeline/01-05-Remove-Duplicates
		mkdir -p ./data/pipeline/02-01-Remove-Low-Quality
		mkdir -p ./data/pipeline/02-02-Split-By-Chromosome
		mkdir -p ./data/pipeline/03-01-Phase-By-Chromosome

clean-pipeline-run-data:
		rm -f ./data/pipeline/01-01-Rename-Chromosomes/*
