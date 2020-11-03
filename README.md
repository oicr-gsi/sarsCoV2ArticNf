# sarsCoV2ArticNf

Calls the sarsCov2Ncov workflow after running through bcl2fastq

## Overview

## Dependencies

* [bcl2fastq](https://emea.support.illumina.com/sequencing/sequencing_software/bcl2fastq-conversion-software.html)
* [ncov2019-artic-nf-illumina 20200910](https://github.com/oicr-gsi/ncov2019-artic-nf)


## Usage

### Cromwell
```
java -jar cromwell.jar run sarsCoV2ArticNf.wdl --inputs inputs.json
```

### Inputs

#### Required workflow parameters:
Parameter|Value|Description
---|---|---
`bcl2fastqMetas`|Array[bcl2fastqMeta]|Samples, lanes, and runDirectory for bcl2fastq
`schemeVersionInput`|String|Version for primer
`bedInput`|File|Bed file for primer
`bcl2fastq.mismatches`|Int|Number of mismatches to allow in the barcodes (usually, 1)
`bcl2fastq.modules`|String|The modules to load when running the workflow. This should include bcl2fastq and the helper scripts.


#### Optional workflow parameters:
Parameter|Value|Default|Description
---|---|---|---


#### Optional task parameters:
Parameter|Value|Default|Description
---|---|---|---
`bcl2fastq.process_threads`|Int|8|The number of processing threads to use when running BCL2FASTQ
`bcl2fastq.process_temporaryDirectory`|String|"."|A directory where bcl2fastq can dump massive amounts of garbage while running.
`bcl2fastq.process_memory`|Int|32|The memory for the BCL2FASTQ process in GB.
`bcl2fastq.process_ignoreMissingPositions`|Boolean|false|Flag passed to bcl2fastq, allows missing or corrupt positions files.
`bcl2fastq.process_ignoreMissingFilter`|Boolean|false|Flag passed to bcl2fastq, allows missing or corrupt filter files.
`bcl2fastq.process_ignoreMissingBcls`|Boolean|false|Flag passed to bcl2fastq, allows missing bcl files.
`bcl2fastq.process_extraOptions`|String|""|Any other options that will be passed directly to bcl2fastq.
`bcl2fastq.process_bcl2fastqJail`|String|"bcl2fastq-jail"|The name ro path of the BCL2FASTQ wrapper script executable.
`bcl2fastq.process_bcl2fastq`|String|"bcl2fastq"|The name or path of the BCL2FASTQ executable.
`bcl2fastq.basesMask`|String?|None|An Illumina bases mask string to use. If absent, the one written by the instrument will be used.
`bcl2fastq.timeout`|Int|40|The maximum number of hours this workflow can run for.
`ncov2019ArticNf.illumina_ncov2019ArticNf_compositeHumanVirusReferencePath`|String|"$HG38_SARS_COVID_2_ROOT/composite_human_virus_reference.fasta"|Path to the composite reference to use during non-human filtering step.
`ncov2019ArticNf.illumina_ncov2019ArticNf_ncov2019ArticPath`|String|"$ARTIC_NCOV2019_ROOT"|Path to the artic-ncov2019 repository directory or url
`ncov2019ArticNf.illumina_ncov2019ArticNf_ncov2019ArticNextflowPath`|String|"$NCOV2019_ARTIC_NF_ILLUMINA_ROOT"|Path to the ncov2019-artic-nf-illumina repository directory.
`ncov2019ArticNf.illumina_ncov2019ArticNf_modules`|String|"ncov2019-artic-nf-illumina/20200910 artic-ncov2019/2 hg38-sars-covid-2/20200714"|Environment module name and version to load (space separated) before command execution.
`ncov2019ArticNf.illumina_ncov2019ArticNf_timeout`|Int|5|Maximum amount of time (in hours) the task can run for.
`ncov2019ArticNf.illumina_ncov2019ArticNf_mem`|Int|8|Memory (in GB) to allocate to the job.
`ncov2019ArticNf.illumina_ncov2019ArticNf_additionalParameters`|String?|None|Additional parameters to add to the nextflow command.
`ncov2019ArticNf.illumina_ncov2019ArticNf_ivarMinDepth`|Float?|None|Minimum coverage depth to call variant.
`ncov2019ArticNf.illumina_ncov2019ArticNf_ivarFreqThreshold`|Float?|None|ivar frequency threshold for variant.
`ncov2019ArticNf.illumina_ncov2019ArticNf_mpileupDepth`|Int?|None|Mpileup depth for ivar.
`ncov2019ArticNf.illumina_ncov2019ArticNf_illuminaQualThreshold`|Int?|None|Sliding window quality threshold for keeping reads after primer trimming (illumina).
`ncov2019ArticNf.illumina_ncov2019ArticNf_illuminaKeepLen`|Int?|None|Length of illumina reads to keep after primer trimming.
`ncov2019ArticNf.illumina_ncov2019ArticNf_allowNoprimer`|Boolean?|None|Allow reads that don't have primer sequence? Ligation prep = false, nextera = true.
`ncov2019ArticNf.illumina_ncov2019ArticNf_viralContigName`|String|"MN908947.3"|Viral contig name to retain during non-human filtering step.
`ncov2019ArticNf.renameInputs_timeout`|Int|1|Maximum amount of time (in hours) the task can run for.
`ncov2019ArticNf.renameInputs_mem`|Int|1|Memory (in GB) to allocate to the job.
`kraken2.modules`|String|"kraken2/2.0.8 kraken2-database/1"|Environment module name and version to load (space separated) before command execution.
`kraken2.kraken2DB`|String|"$KRAKEN2_DATABASE_ROOT/"|Database for kraken2 data
`kraken2.mem`|Int|8|Memory (in GB) to allocate to the job.
`kraken2.timeout`|Int|72|Maximum amount of time (in hours) the task can run for.
`qcStats.modules`|String|"bedtools samtools/1.9"|Environment module name and version to load (space separated) before command execution.
`qcStats.mem`|Int|8|Memory (in GB) to allocate to the job.
`qcStats.timeout`|Int|72|Maximum amount of time (in hours) the task can run for.


### Outputs

Output | Type | Description
---|---|---
Traceback (most recent call last):
  File "/.mounts/labs/gsiprojects/gsi/rshah/gsi-wdl-tools/bin/../scripts/generate_markdown_readme.py", line 69, in <module>
    for output in info.outputs:
  File "/.mounts/labs/gsiprojects/gsi/rshah/gsi-wdl-tools/gsi_wdl_tools/workflow_info.py", line 67, in outputs
    raise Exception(f"output description is missing for {name}")
Exception: output description is missing for bclFastqR1
rshah@ucn101-68:~$ vim /.mounts/labs/gsiprojects/gsi/rshah/workflows/sarsCoV2ArticNf/sarsCoV2ArticNf.wdl 
rshah@ucn101-68:~$ /.mounts/labs/gsiprojects/gsi/rshah/gsi-wdl-tools/bin/generate-markdown-readme --input-wdl-path /.mounts/labs/gsiprojects/gsi/rshah/workflows/sarsCoV2ArticNf/sarsCoV2ArticNf.wdl 
# sarsCoV2ArticNf

Calls the sarsCov2Ncov workflow after running through bcl2fastq

## Overview

## Dependencies

* [bcl2fastq](https://emea.support.illumina.com/sequencing/sequencing_software/bcl2fastq-conversion-software.html)
* [ncov2019-artic-nf-illumina 20200910](https://github.com/oicr-gsi/ncov2019-artic-nf)


## Usage

### Cromwell
```
java -jar cromwell.jar run sarsCoV2ArticNf.wdl --inputs inputs.json
```

### Inputs

#### Required workflow parameters:
Parameter|Value|Description
---|---|---
`bcl2fastqMetas`|Array[bcl2fastqMeta]|Samples, lanes, and runDirectory for bcl2fastq
`schemeVersionInput`|String|Version for primer
`bedInput`|File|Bed file for primer
`bcl2fastq.mismatches`|Int|Number of mismatches to allow in the barcodes (usually, 1)
`bcl2fastq.modules`|String|The modules to load when running the workflow. This should include bcl2fastq and the helper scripts.


#### Optional workflow parameters:
Parameter|Value|Default|Description
---|---|---|---


#### Optional task parameters:
Parameter|Value|Default|Description
---|---|---|---
`bcl2fastq.process_threads`|Int|8|The number of processing threads to use when running BCL2FASTQ
`bcl2fastq.process_temporaryDirectory`|String|"."|A directory where bcl2fastq can dump massive amounts of garbage while running.
`bcl2fastq.process_memory`|Int|32|The memory for the BCL2FASTQ process in GB.
`bcl2fastq.process_ignoreMissingPositions`|Boolean|false|Flag passed to bcl2fastq, allows missing or corrupt positions files.
`bcl2fastq.process_ignoreMissingFilter`|Boolean|false|Flag passed to bcl2fastq, allows missing or corrupt filter files.
`bcl2fastq.process_ignoreMissingBcls`|Boolean|false|Flag passed to bcl2fastq, allows missing bcl files.
`bcl2fastq.process_extraOptions`|String|""|Any other options that will be passed directly to bcl2fastq.
`bcl2fastq.process_bcl2fastqJail`|String|"bcl2fastq-jail"|The name ro path of the BCL2FASTQ wrapper script executable.
`bcl2fastq.process_bcl2fastq`|String|"bcl2fastq"|The name or path of the BCL2FASTQ executable.
`bcl2fastq.basesMask`|String?|None|An Illumina bases mask string to use. If absent, the one written by the instrument will be used.
`bcl2fastq.timeout`|Int|40|The maximum number of hours this workflow can run for.
`ncov2019ArticNf.illumina_ncov2019ArticNf_compositeHumanVirusReferencePath`|String|"$HG38_SARS_COVID_2_ROOT/composite_human_virus_reference.fasta"|Path to the composite reference to use during non-human filtering step.
`ncov2019ArticNf.illumina_ncov2019ArticNf_ncov2019ArticPath`|String|"$ARTIC_NCOV2019_ROOT"|Path to the artic-ncov2019 repository directory or url
`ncov2019ArticNf.illumina_ncov2019ArticNf_ncov2019ArticNextflowPath`|String|"$NCOV2019_ARTIC_NF_ILLUMINA_ROOT"|Path to the ncov2019-artic-nf-illumina repository directory.
`ncov2019ArticNf.illumina_ncov2019ArticNf_modules`|String|"ncov2019-artic-nf-illumina/20200910 artic-ncov2019/2 hg38-sars-covid-2/20200714"|Environment module name and version to load (space separated) before command execution.
`ncov2019ArticNf.illumina_ncov2019ArticNf_timeout`|Int|5|Maximum amount of time (in hours) the task can run for.
`ncov2019ArticNf.illumina_ncov2019ArticNf_mem`|Int|8|Memory (in GB) to allocate to the job.
`ncov2019ArticNf.illumina_ncov2019ArticNf_additionalParameters`|String?|None|Additional parameters to add to the nextflow command.
`ncov2019ArticNf.illumina_ncov2019ArticNf_ivarMinDepth`|Float?|None|Minimum coverage depth to call variant.
`ncov2019ArticNf.illumina_ncov2019ArticNf_ivarFreqThreshold`|Float?|None|ivar frequency threshold for variant.
`ncov2019ArticNf.illumina_ncov2019ArticNf_mpileupDepth`|Int?|None|Mpileup depth for ivar.
`ncov2019ArticNf.illumina_ncov2019ArticNf_illuminaQualThreshold`|Int?|None|Sliding window quality threshold for keeping reads after primer trimming (illumina).
`ncov2019ArticNf.illumina_ncov2019ArticNf_illuminaKeepLen`|Int?|None|Length of illumina reads to keep after primer trimming.
`ncov2019ArticNf.illumina_ncov2019ArticNf_allowNoprimer`|Boolean?|None|Allow reads that don't have primer sequence? Ligation prep = false, nextera = true.
`ncov2019ArticNf.illumina_ncov2019ArticNf_viralContigName`|String|"MN908947.3"|Viral contig name to retain during non-human filtering step.
`ncov2019ArticNf.renameInputs_timeout`|Int|1|Maximum amount of time (in hours) the task can run for.
`ncov2019ArticNf.renameInputs_mem`|Int|1|Memory (in GB) to allocate to the job.
`kraken2.modules`|String|"kraken2/2.0.8 kraken2-database/1"|Environment module name and version to load (space separated) before command execution.
`kraken2.kraken2DB`|String|"$KRAKEN2_DATABASE_ROOT/"|Database for kraken2 data
`kraken2.mem`|Int|8|Memory (in GB) to allocate to the job.
`kraken2.timeout`|Int|72|Maximum amount of time (in hours) the task can run for.
`qcStats.modules`|String|"bedtools samtools/1.9"|Environment module name and version to load (space separated) before command execution.
`qcStats.mem`|Int|8|Memory (in GB) to allocate to the job.
`qcStats.timeout`|Int|72|Maximum amount of time (in hours) the task can run for.


### Outputs

Output | Type | Description
---|---|---
`bclFastqR1`|File|Fastq 1 from bcl2fastq
`bclFastqR2`|File|Fastq 2 from bcl2fastq
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
`outputKrakenTxt`|File|Taxonomic Classification from Kraken2
`outCvgHist`|File?|Coverage history from QC Stats
`outGenomecvgHist`|File|Genome Coverage history from QC Stats
`outGenomecvgPerBase`|File|Genome Coverage per base from QC Stats
`outHostMappedAlignmentStats`|File|Host mapped alignment stats from QC Stats
`outHostDepletedAlignmentStats`|File|Host depleted alignment stats from QC Stats


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

