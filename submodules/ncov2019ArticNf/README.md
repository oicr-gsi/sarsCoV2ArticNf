# ncov2019ArticNf

ncov2019ArticNf workflow executes the ncov2019-artic-nf Nextflow workflow from connor-lab (https://github.com/connor-lab/ncov2019-artic-nf).

## Overview

## Dependencies

* [ncov2019-artic-nf-illumina 20200910](https://github.com/oicr-gsi/ncov2019-artic-nf)
* [artic-ncov2019 2](https://github.com/oicr-gsi/artic-ncov2019)
* [hg38-sars-covid-2 20200714](https://gitlab.oicr.on.ca/ResearchIT/modulator)


## Usage

### Cromwell
```
java -jar cromwell.jar run ncov2019ArticNf.wdl --inputs inputs.json
```

### Inputs

#### Required workflow parameters:
Parameter|Value|Description
---|---|---
`fastqR1`|File|Read 1 fastq file.
`fastqR2`|File|Read 2 fastq file.
`outputFileNamePrefix`|String|Output prefix to prefix output file names with.
`schemeVersion`|String|The Artic primer scheme version that was used.


#### Optional workflow parameters:
Parameter|Value|Default|Description
---|---|---|---


#### Optional task parameters:
Parameter|Value|Default|Description
---|---|---|---
`renameInputs.mem`|Int|1|Memory (in GB) to allocate to the job.
`renameInputs.timeout`|Int|1|Maximum amount of time (in hours) the task can run for.
`illumina_ncov2019ArticNf.viralContigName`|String|"MN908947.3"|Viral contig name to retain during non-human filtering step.
`illumina_ncov2019ArticNf.allowNoprimer`|Boolean?|None|Allow reads that don't have primer sequence? Ligation prep = false, nextera = true.
`illumina_ncov2019ArticNf.illuminaKeepLen`|Int?|None|Length of illumina reads to keep after primer trimming.
`illumina_ncov2019ArticNf.illuminaQualThreshold`|Int?|None|Sliding window quality threshold for keeping reads after primer trimming (illumina).
`illumina_ncov2019ArticNf.mpileupDepth`|Int?|None|Mpileup depth for ivar.
`illumina_ncov2019ArticNf.ivarFreqThreshold`|Float?|None|ivar frequency threshold for variant.
`illumina_ncov2019ArticNf.ivarMinDepth`|Float?|None|Minimum coverage depth to call variant.
`illumina_ncov2019ArticNf.additionalParameters`|String?|None|Additional parameters to add to the nextflow command.
`illumina_ncov2019ArticNf.mem`|Int|8|Memory (in GB) to allocate to the job.
`illumina_ncov2019ArticNf.timeout`|Int|5|Maximum amount of time (in hours) the task can run for.
`illumina_ncov2019ArticNf.modules`|String|"ncov2019-artic-nf-illumina/20200910 artic-ncov2019/2 hg38-sars-covid-2/20200714"|Environment module name and version to load (space separated) before command execution.
`illumina_ncov2019ArticNf.ncov2019ArticNextflowPath`|String|"$NCOV2019_ARTIC_NF_ILLUMINA_ROOT"|Path to the ncov2019-artic-nf-illumina repository directory.
`illumina_ncov2019ArticNf.ncov2019ArticPath`|String|"$ARTIC_NCOV2019_ROOT"|Path to the artic-ncov2019 repository directory or url
`illumina_ncov2019ArticNf.compositeHumanVirusReferencePath`|String|"$HG38_SARS_COVID_2_ROOT/composite_human_virus_reference.fasta"|Path to the composite reference to use during non-human filtering step.


### Outputs

Output | Type | Description
---|---|---
`readTrimmingFastqR1`|File|Fastq R1 from readTrimming step.
`readTrimmingFastqR2`|File|Fastq R1 from readTrimming step.
`readMappingBam`|File|Sorted bam from readMapping step.
`trimPrimerSequencesBam`|File|Mapped bam from trimPrimerSequences step.
`trimPrimerSequencesPrimerTrimmedBam`|File|Mapped + primer trimmer bam from trimPrimerSequences step.
`makeConsensusFasta`|File|Consensus fasta from makeConsensus step.
`qcPlotsPng`|File|Qc plot (depth) png from qcPlots step.
`callVariantsTsv`|File|Variants tsv from callVariants step.
`qcCsv`|File|Qc csv from qc step.
`nextflowLogs`|File|All nextflow workflow task stdout and stderr logs gzipped and named by task.


## Niassa + Cromwell

This WDL workflow is wrapped in a Niassa workflow (https://github.com/oicr-gsi/pipedev/tree/master/pipedev-niassa-cromwell-workflow) so that it can used with the Niassa metadata tracking system (https://github.com/oicr-gsi/niassa).

* Building
```
mvn clean install
```

* Testing
```
mvn clean verify \
-Djava_opts="-Xmx1g -XX:+UseG1GC -XX:+UseStringDeduplication" \
-DrunTestThreads=2 \
-DskipITs=false \
-DskipRunITs=false \
-DworkingDirectory=/path/to/tmp/ \
-DschedulingHost=niassa_oozie_host \
-DwebserviceUrl=http://niassa-url:8080 \
-DwebserviceUser=niassa_user \
-DwebservicePassword=niassa_user_password \
-Dcromwell-host=http://cromwell-url:8000
```

## Support

For support, please file an issue on the [Github project](https://github.com/oicr-gsi) or send an email to gsi@oicr.on.ca .

_Generated with generate-markdown-readme (https://github.com/oicr-gsi/gsi-wdl-tools/)_
