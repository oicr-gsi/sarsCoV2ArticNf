version 1.0

import "imports/pull_bcl2fastq.wdl" as bcl2fastq
import "imports/pull_ncov2019ArticNf.wdl" as ncov2019ArticNf

struct bcl2fastqMeta {
  Array[Sample]+ samples  # Sample: {Array[String]+, String}
  Array[Int] lanes
  String runDirectory
}

workflow sarsCoV2ArticNf {
    input {
        Array[bcl2fastqMeta] bcl2fastqMetas
        String schemeVersionInput
        File bedInput
        String inputLibrary
        String inputExternal
        String inputRun
    }

    parameter_meta {
        bcl2fastqMetas: "Samples, lanes, and runDirectory for bcl2fastq"
        schemeVersionInput: "Version for primer"
        bedInput: "Bed file for primer"
        inputLibrary: "Library of the run"
        inputExternal: "External name of the run"
        inputRun: "run of the file"
    }

    meta {
        author: "Rishi Shah"
        email: "rshah@oicr.on.ca"
        description: "Calls the sarsCov2Ncov workflow after running through bcl2fastq"
        dependencies: [
        {
            name: "bcl2fastq",
            url: "https://emea.support.illumina.com/sequencing/sequencing_software/bcl2fastq-conversion-software.html"
        },
        {
            name: "ncov2019-artic-nf-illumina/20200910",
            url: "https://github.com/oicr-gsi/ncov2019-artic-nf"
        }
      ]
      output_meta: {
        bclFastqR1: "Fastq 1 from bcl2fastq",
	      bclFastqR2: "Fastq 2 from bcl2fastq",
        readTrimmingFastqR1: "Fastq R1 from readTrimming step.",
        readTrimmingFastqR2: "Fastq R1 from readTrimming step.",
        readMappingBam: "Sorted bam from readMapping step.",
        trimPrimerSequencesBam: "Mapped bam from trimPrimerSequences step.",
        trimPrimerSequencesPrimerTrimmedBam: "Mapped + primer trimmer bam from trimPrimerSequences step.",
        makeConsensusFasta: "Consensus fasta from makeConsensus step.",
        callVariantsTsv: "Variants tsv from callVariants step.",
        qcPlotsPng: "Qc plot (depth) png from qcPlots step.",
        qcCsv: "Qc csv from qc step.",
        nextflowLogs: "All nextflow workflow task stdout and stderr logs gzipped and named by task.",
        outputKrakenTxt: "Taxonomic Classification from Kraken2",
        outCvgHist: "Coverage history from QC Stats",
        outGenomecvgHist: "Genome Coverage history from QC Stats",
        outGenomecvgPerBase: "Genome Coverage per base from QC Stats",
        outHostMappedAlignmentStats: "Host mapped alignment stats from QC Stats",
        outHostDepletedAlignmentStats: "Host depleted alignment stats from QC Stats"
      }
    }

    call bcl2fastq.bcl2fastq {
      input:
        samples = bcl2fastqMetas[0].samples,
        lanes = bcl2fastqMetas[0].lanes,
        runDirectory = bcl2fastqMetas[0].runDirectory
    }

    File fastqR1Bcl = bcl2fastq.fastqs[0].fastqs.left
    File fastqR2Bcl = bcl2fastq.fastqs[1].fastqs.left
    String name = bcl2fastq.fastqs[0].name

    call ncov2019ArticNf.ncov2019ArticNf {
        input:
          fastqR1 = fastqR1Bcl,
          fastqR2 = fastqR2Bcl, 
          outputFileNamePrefix = name,
          schemeVersion = schemeVersionInput
    }

    call kraken2 {
    input:
      fastq1 = ncov2019ArticNf.readTrimmingFastqR1,
      fastq2 = ncov2019ArticNf.readTrimmingFastqR2,
      sample = name,
    
    }

    call variantCalling {
    input:
      sample = name,
      bam = ncov2019ArticNf.readMappingBam
    }

    call qcStats {
    input:
      sample = name,
      bam = ncov2019ArticNf.readMappingBam,
      hostMappedBam = ncov2019ArticNf.trimPrimerSequencesPrimerTrimmedBam,
      panelBed = bedInput
    }

    call createJson {
    input: 
      primerTrimSamstats = qcStats.hostDepletedAlignmentStats,
      hostSamstats = qcStats.hostMappedAlignmentStats,
      qcStatistics = ncov2019ArticNf.qcCsv,
      kraken2Report = kraken2.out,
      coverageHist = qcStats.genomecvgHist,
      vcfVariants = variantCalling.variantOnlyVcf
    }

    call createPdf {
    input: 
      json = createJson.json,
      cvgPerBaseFile = qcStats.genomecvgPerBase,
      cvgHistFile = qcStats.cvgHist,
      sample = name,
      library = inputLibrary,
      external = inputExternal,
      run = inputRun
    }


    output {
      File bclFastqR1 = fastqR1Bcl
      File bclFastqR2 = fastqR2Bcl
      File readTrimmingFastqR1 = ncov2019ArticNf.readTrimmingFastqR1
      File readTrimmingFastqR2 = ncov2019ArticNf.readTrimmingFastqR2
      File readMappingBam = ncov2019ArticNf.readMappingBam
      File trimPrimerSequencesBam = ncov2019ArticNf.trimPrimerSequencesBam
      File trimPrimerSequencesPrimerTrimmedBam = ncov2019ArticNf.trimPrimerSequencesPrimerTrimmedBam
      File makeConsensusFasta = ncov2019ArticNf.makeConsensusFasta
      File qcPlotsPng = ncov2019ArticNf.qcPlotsPng
      File callVariantsTsv = ncov2019ArticNf.callVariantsTsv
      File qcCsv = ncov2019ArticNf.qcCsv
      File nextflowLogs = ncov2019ArticNf.nextflowLogs
      File outputKrakenTxt = kraken2.out
      File vcf = variantCalling.vcfFile
      File consensusFasta = variantCalling.consensusFasta
      File variantOnlyVcf = variantCalling.variantOnlyVcf
      File? outCvgHist = qcStats.cvgHist
      File outGenomecvgHist = qcStats.genomecvgHist
      File outGenomecvgPerBase = qcStats.genomecvgPerBase
      File outHostMappedAlignmentStats = qcStats.hostMappedAlignmentStats
      File outHostDepletedAlignmentStats = qcStats.hostDepletedAlignmentStats
      File jsonOut = createJson.json
    }
}

task kraken2 {
  input {
    String modules = "kraken2/2.0.8 kraken2-database/1"
    File fastq1
    File fastq2
    String kraken2DB = "$KRAKEN2_DATABASE_ROOT/"
    String sample
    Int mem = 8
    Int timeout = 72
  }
  
  parameter_meta {
    fastq1: "Read 1 fastq file to be rename."
    fastq2: "Read 2 fastq file to rename."
    sample: "Output prefix to renamed fastqs with."
    kraken2DB: "Database for kraken2 data"
    mem: "Memory (in GB) to allocate to the job."
    timeout: "Maximum amount of time (in hours) the task can run for."
    modules: "Environment module name and version to load (space separated) before command execution."
  }

  command <<<
    set -euo pipefail

    kraken2 --paired ~{fastq1} ~{fastq2} \
    --db ~{kraken2DB} \
    --report ~{sample}.kreport2.txt
  >>>

  runtime {
    memory: "~{mem} GB"
    modules: "~{modules}"
    timeout: "~{timeout}"
  }

  output {
    File out = "~{sample}.kreport2.txt"
  }
}

task variantCalling {
  input {
    String modules = "bcftools/1.9 samtools/1.9 vcftools/0.1.16 seqtk/1.3 sars-covid-2-polymasked/mn908947.3"
    File bam
    String sample
    String sarsCovidRef = "$SARS_COVID_2_POLYMASKED_ROOT/MN908947.3.mask.fasta"
    Int mem = 8
    Int timeout = 72
  }

  String vcfName = "~{sample}.vcf"
  String fastaName = "~{sample}.consensus.fasta"
  String variantOnlyVcf_ = "~{sample}.v.vcf"

  command <<<
    set -euo pipefail

    #Call consensus sequence
    samtools mpileup -aa -uf ~{sarsCovidRef} ~{bam} | \
    bcftools call --ploidy 1 -Mc | tee -a ~{vcfName} | \
    vcfutils.pl vcf2fq -d 10 | \
    seqtk seq -A - | sed '2~2s/[actg]/N/g' > ~{fastaName}

    bcftools mpileup -a "INFO/AD,FORMAT/DP,FORMAT/AD" \
    -d 8000 -f ~{sarsCovidRef} ~{bam} | \
    tee ~{sample}.m.vcf | bcftools call --ploidy 1 -m -v > ~{variantOnlyVcf_}
  >>>

  runtime {
    memory: "~{mem} GB"
    modules: "~{modules}"
    timeout: "~{timeout}"
  }

  output {
    File vcfFile = "~{vcfName}"
    File consensusFasta = "~{fastaName}"
    File variantOnlyVcf = "~{variantOnlyVcf_}"
  }
}


task qcStats {
  input {
    String modules = "bedtools samtools/1.9"
    String sample
    File? panelBed
    File bam
    File hostMappedBam
    Int mem = 8
    Int timeout = 72
  }

  parameter_meta {
    panelBed: "bam file which synchs to the version"
    bam: "bam file"
    hostMappedBam: "host mapped bam file"
    sample: "basename for the file names"
    mem: "Memory (in GB) to allocate to the job."
    timeout: "Maximum amount of time (in hours) the task can run for."
    modules: "Environment module name and version to load (space separated) before command execution."
  }


  command <<<
    set -euo pipefail

    if [ -f "~{panelBed}" ]; then
      bedtools coverage -hist -a ~{panelBed} -b ~{bam} > ~{sample}.cvghist.txt
    fi

    bedtools genomecov -ibam ~{bam} > ~{sample}.genomecvghist.txt

    bedtools genomecov -d -ibam ~{bam} > ~{sample}.genome.cvgperbase.txt

    samtools stats ~{hostMappedBam} > ~{sample}.host.mapped.samstats.txt

    samtools stats ~{bam} > ~{sample}.samstats.txt
  >>>

  runtime {
    memory: "~{mem} GB"
    modules: "~{modules}"
    timeout: "~{timeout}"
  }

  output {
    File cvgHist = "~{sample}.cvghist.txt"
    File genomecvgHist = "~{sample}.genomecvghist.txt"
    File genomecvgPerBase = "~{sample}.genome.cvgperbase.txt"
    File hostMappedAlignmentStats = "~{sample}.host.mapped.samstats.txt"
    File hostDepletedAlignmentStats = "~{sample}.samstats.txt"
  }
}

task createJson {
  input {
    File primerTrimSamstats
    File hostSamstats
    File qcStatistics
    File kraken2Report
    File coverageHist
    File vcfVariants
    String modules = "sarscov2helper/1.0"
    Int mem = 8
    Int timeout = 72
  }

  parameter_meta {
    primerTrimSamstats: "Sam stats of the primertrimmed file"
    hostSamstats: "Sam stats of the host file"
    qcStatistics: "QC stats from nextflow "
    kraken2Report: "Taxonomic classification"
    coverageHist: "Coverage history file"
    vcfVariants: "v.vcf file which holds variants"
    mem: "Memory (in GB) to allocate to the job."
    timeout: "Maximum amount of time (in hours) the task can run for."
    modules: "Environment module name and version to load (space separated) before command execution."
  }

   command <<<
    set -euo pipefail

    cat ~{primerTrimSamstats} | grep SN | cut -f2,3 > primerTrim.txt 
    cat ~{hostSamstats} | grep SN | cut -f2,3 > hostSamstats.txt 
    cat ~{coverageHist} | grep genome > meancvg.txt
    cat ~{vcfVariants} | grep -v ^# > v.txt

    jsonCreater.py -s primerTrim.txt  -o hostSamstats.txt  -q ~{qcStatistics} -k ~{kraken2Report} -m meancvg.txt -v v.txt

    >>>

    runtime {
    memory: "~{mem} GB"
    modules: "~{modules}"
    timeout: "~{timeout}"
    }

    output {
    File json = "metrics.json"

  }
}

task createPdf {
  input {
    File json
    String rmdScript = "$SARSCOV2HELPER_ROOT/share/sarscov2help/json_COVID_Report.Rmd" 
    File cvgPerBaseFile
    File cvgHistFile
    String sample
    String library
    String external
    String run
    String modules = "rmarkdown/1.0 sarscov2helper/1.0"
    Int mem = 8
    Int timeout = 72
  }

  parameter_meta {
    json: "json file of all the info"
    rmdScript: "rmd script to make the pdf"
    cvgPerBaseFile: "Coverage for base file"
    cvgHistFile: "Coverage for history file"
    sample: "Sample Info"
    library: "Library Info"
    external: "External Info"
    run: "Run info"
    mem: "Memory (in GB) to allocate to the job."
    timeout: "Maximum amount of time (in hours) the task can run for."
    modules: "Environment module name and version to load (space separated) before command execution."
  }

   command <<<
    set -euo pipefail

    cp ~{rmdScript} .

    Rscript -e "rmarkdown::render(./json_COVID_Report.Rmd, params=list(json=~{json},perbasefile=~{cvgPerBaseFile}, histfile=~{cvgHistFile}, \
                sample=~{sample}, library=~{library}, ext=~{external}, run=~{run}, refname=MN), output_file=~{sample}.pdf)"

    >>>

    runtime {
    memory: "~{mem} GB"
    modules: "~{modules}"
    timeout: "~{timeout}"
    }

    output {
    File pdf = "~{sample}.pdf"

  }
}
