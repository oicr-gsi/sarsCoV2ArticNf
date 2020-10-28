version 1.0

workflow ncov2019ArticNf {
  input {
    String illumina_ncov2019ArticNf_compositeHumanVirusReferencePath = "$HG38_SARS_COVID_2_ROOT/composite_human_virus_reference.fasta"
    String illumina_ncov2019ArticNf_ncov2019ArticPath = "$ARTIC_NCOV2019_ROOT"
    String illumina_ncov2019ArticNf_ncov2019ArticNextflowPath = "$NCOV2019_ARTIC_NF_ILLUMINA_ROOT"
    String illumina_ncov2019ArticNf_modules = "ncov2019-artic-nf-illumina/20200910 artic-ncov2019/2 hg38-sars-covid-2/20200714"
    Int illumina_ncov2019ArticNf_timeout = 5
    Int illumina_ncov2019ArticNf_mem = 8
    String? illumina_ncov2019ArticNf_additionalParameters
    Float? illumina_ncov2019ArticNf_ivarMinDepth
    Float? illumina_ncov2019ArticNf_ivarFreqThreshold
    Int? illumina_ncov2019ArticNf_mpileupDepth
    Int? illumina_ncov2019ArticNf_illuminaQualThreshold
    Int? illumina_ncov2019ArticNf_illuminaKeepLen
    Boolean? illumina_ncov2019ArticNf_allowNoprimer
    String illumina_ncov2019ArticNf_viralContigName = "MN908947.3"
    Int renameInputs_timeout = 1
    Int renameInputs_mem = 1
    File fastqR1
    File fastqR2
    String outputFileNamePrefix
    String schemeVersion
  }

  call renameInputs {
    input:
      timeout = renameInputs_timeout,
      mem = renameInputs_mem,
      fastqR1 = fastqR1,
      fastqR2 = fastqR2,
      outputFileNamePrefix = outputFileNamePrefix
  }

  call illumina_ncov2019ArticNf {
    input:
      compositeHumanVirusReferencePath = illumina_ncov2019ArticNf_compositeHumanVirusReferencePath,
      ncov2019ArticPath = illumina_ncov2019ArticNf_ncov2019ArticPath,
      ncov2019ArticNextflowPath = illumina_ncov2019ArticNf_ncov2019ArticNextflowPath,
      modules = illumina_ncov2019ArticNf_modules,
      timeout = illumina_ncov2019ArticNf_timeout,
      mem = illumina_ncov2019ArticNf_mem,
      additionalParameters = illumina_ncov2019ArticNf_additionalParameters,
      ivarMinDepth = illumina_ncov2019ArticNf_ivarMinDepth,
      ivarFreqThreshold = illumina_ncov2019ArticNf_ivarFreqThreshold,
      mpileupDepth = illumina_ncov2019ArticNf_mpileupDepth,
      illuminaQualThreshold = illumina_ncov2019ArticNf_illuminaQualThreshold,
      illuminaKeepLen = illumina_ncov2019ArticNf_illuminaKeepLen,
      allowNoprimer = illumina_ncov2019ArticNf_allowNoprimer,
      viralContigName = illumina_ncov2019ArticNf_viralContigName,
      fastqR1 = renameInputs.renamedFastqR1,
      fastqR2 = renameInputs.renamedFastqR2,
      outputFileNamePrefix = outputFileNamePrefix,
      schemeVersion = schemeVersion
  }

  output {
    File readTrimmingFastqR1 = illumina_ncov2019ArticNf.readTrimmingFastqR1
    File readTrimmingFastqR2 = illumina_ncov2019ArticNf.readTrimmingFastqR2
    File readMappingBam = illumina_ncov2019ArticNf.readMappingBam
    File trimPrimerSequencesBam = illumina_ncov2019ArticNf.trimPrimerSequencesBam
    File trimPrimerSequencesPrimerTrimmedBam = illumina_ncov2019ArticNf.trimPrimerSequencesPrimerTrimmedBam
    File makeConsensusFasta = illumina_ncov2019ArticNf.makeConsensusFasta
    File qcPlotsPng = illumina_ncov2019ArticNf.qcPlotsPng
    File callVariantsTsv = illumina_ncov2019ArticNf.callVariantsTsv
    File qcCsv = illumina_ncov2019ArticNf.qcCsv
    File nextflowLogs = illumina_ncov2019ArticNf.nextflowLogs
  }

  parameter_meta {
      illumina_ncov2019ArticNf_compositeHumanVirusReferencePath: "Path to the composite reference to use during non-human filtering step."
      illumina_ncov2019ArticNf_ncov2019ArticPath: "Path to the artic-ncov2019 repository directory or url"
      illumina_ncov2019ArticNf_ncov2019ArticNextflowPath: "Path to the ncov2019-artic-nf-illumina repository directory."
      illumina_ncov2019ArticNf_modules: "Environment module name and version to load (space separated) before command execution."
      illumina_ncov2019ArticNf_timeout: "Maximum amount of time (in hours) the task can run for."
      illumina_ncov2019ArticNf_mem: "Memory (in GB) to allocate to the job."
      illumina_ncov2019ArticNf_additionalParameters: "Additional parameters to add to the nextflow command."
      illumina_ncov2019ArticNf_ivarMinDepth: "Minimum coverage depth to call variant."
      illumina_ncov2019ArticNf_ivarFreqThreshold: "ivar frequency threshold for variant."
      illumina_ncov2019ArticNf_mpileupDepth: "Mpileup depth for ivar."
      illumina_ncov2019ArticNf_illuminaQualThreshold: "Sliding window quality threshold for keeping reads after primer trimming (illumina)."
      illumina_ncov2019ArticNf_illuminaKeepLen: "Length of illumina reads to keep after primer trimming."
      illumina_ncov2019ArticNf_allowNoprimer: "Allow reads that don't have primer sequence? Ligation prep = false, nextera = true."
      illumina_ncov2019ArticNf_viralContigName: "Viral contig name to retain during non-human filtering step."
      renameInputs_timeout: "Maximum amount of time (in hours) the task can run for."
      renameInputs_mem: "Memory (in GB) to allocate to the job."
    fastqR1: "Read 1 fastq file."
    fastqR2: "Read 2 fastq file."
    outputFileNamePrefix: "Output prefix to prefix output file names with."
    schemeVersion: "The Artic primer scheme version that was used."
  }

  meta {
    author: "Michael Laszloffy"
    email: "michael.laszloffy@oicr.on.ca"
    description: "ncov2019ArticNf workflow executes the ncov2019-artic-nf Nextflow workflow from connor-lab (https://github.com/connor-lab/ncov2019-artic-nf)."
    dependencies: [
      {
        name: "ncov2019-artic-nf-illumina/20200910",
        url: "https://github.com/oicr-gsi/ncov2019-artic-nf"
      },
      {
        name: "artic-ncov2019/2",
        url: "https://github.com/oicr-gsi/artic-ncov2019"
      },
      {
        name: "hg38-sars-covid-2/20200714",
        url: "https://gitlab.oicr.on.ca/ResearchIT/modulator"
      }
    ]
    output_meta: {
      readTrimmingFastqR1: "Fastq R1 from readTrimming step.",
      readTrimmingFastqR2: "Fastq R1 from readTrimming step.",
      readMappingBam: "Sorted bam from readMapping step.",
      trimPrimerSequencesBam: "Mapped bam from trimPrimerSequences step.",
      trimPrimerSequencesPrimerTrimmedBam: "Mapped + primer trimmer bam from trimPrimerSequences step.",
      makeConsensusFasta: "Consensus fasta from makeConsensus step.",
      callVariantsTsv: "Variants tsv from callVariants step.",
      qcPlotsPng: "Qc plot (depth) png from qcPlots step.",
      qcCsv: "Qc csv from qc step.",
      nextflowLogs: "All nextflow workflow task stdout and stderr logs gzipped and named by task."
    }
  }

}

task renameInputs {
  input {
    File fastqR1
    File fastqR2
    String outputFileNamePrefix
    Int mem = 1
    Int timeout = 1
  }

  command <<<
    ln -s ~{fastqR1} ~{outputFileNamePrefix}_R1.fastq.gz
    ln -s ~{fastqR2} ~{outputFileNamePrefix}_R2.fastq.gz
  >>>

  output {
    File renamedFastqR1 = "~{outputFileNamePrefix}_R1.fastq.gz"
    File renamedFastqR2 = "~{outputFileNamePrefix}_R2.fastq.gz"
  }

  runtime {
    memory: "~{mem} GB"
    timeout: "~{timeout}"
  }

  parameter_meta {
    fastqR1: "Read 1 fastq file to rename."
    fastqR2: "Read 2 fastq file to rename."
    outputFileNamePrefix: "Output prefix to renamed fastqs with."
    mem: "Memory (in GB) to allocate to the job."
    timeout: "Maximum amount of time (in hours) the task can run for."
  }
}

task illumina_ncov2019ArticNf {
  input {
    File fastqR1
    File fastqR2
    String outputFileNamePrefix
    String schemeVersion
    String viralContigName = "MN908947.3"

    Boolean? allowNoprimer
    Int? illuminaKeepLen
    Int? illuminaQualThreshold
    Int? mpileupDepth
    Float? ivarFreqThreshold
    Float? ivarMinDepth
    String? additionalParameters

    Int mem = 8
    Int timeout = 5
    String modules = "ncov2019-artic-nf-illumina/20200910 artic-ncov2019/2 hg38-sars-covid-2/20200714"
    String ncov2019ArticNextflowPath = "$NCOV2019_ARTIC_NF_ILLUMINA_ROOT"
    String ncov2019ArticPath = "$ARTIC_NCOV2019_ROOT"
    String compositeHumanVirusReferencePath = "$HG38_SARS_COVID_2_ROOT/composite_human_virus_reference.fasta"
  }

  command <<<
    set -euo pipefail

    nextflow run ~{ncov2019ArticNextflowPath} \
    --illumina \
    --directory "$(dirname ~{fastqR1})" \
    --prefix "~{outputFileNamePrefix}" \
    --schemeRepoURL ~{ncov2019ArticPath} \
    --schemeVersion ~{schemeVersion} \
    ~{true="--allowNoprimer true" false="--allowNoprimer false" allowNoprimer} \
    ~{"--illuminaKeepLen " + illuminaKeepLen} \
    ~{"--illuminaQualThreshold " + illuminaQualThreshold} \
    ~{"--mpileupDepth " + mpileupDepth} \
    ~{"--ivarFreqThreshold " + ivarFreqThreshold} \
    ~{"--ivarMinDepth " + ivarMinDepth} \
    --composite_ref ~{compositeHumanVirusReferencePath} \
    --viral_contig_name ~{viralContigName} \
    ~{additionalParameters}

    # rename some of the outputs
    ln -s "results/ncovIllumina_sequenceAnalysis_readTrimming/~{outputFileNamePrefix}_hostfiltered_R1_val_1.fq.gz" \
    ~{outputFileNamePrefix}_R1.trimmed.fastq.gz
    ln -s "results/ncovIllumina_sequenceAnalysis_readTrimming/~{outputFileNamePrefix}_hostfiltered_R2_val_2.fq.gz" \
    ~{outputFileNamePrefix}_R2.trimmed.fastq.gz

    # extract all logs from the nextflow working directory
    NEXTFLOW_ID="$(nextflow log -q | head -1)"
    NEXTFLOW_TASKS=$(nextflow log "${NEXTFLOW_ID}" -f "name,workdir" -s '\t')
    mkdir -p logs
    while IFS=$'\t' read -r name workdir; do
      FILENAME="$(echo "${name}" | sed -e 's/[^A-Za-z0-9._-]/_/g')"
      if [ -f "$workdir/.command.log" ]; then
        cp "$workdir/.command.log" "logs/$FILENAME.stdout"
      fi
      if [ -f "$workdir/.command.err" ]; then
        cp "$workdir/.command.err" "logs/$FILENAME.stderr"
      fi
    done <<< ${NEXTFLOW_TASKS}
    tar -zcvf ~{outputFileNamePrefix}.logs.tar.gz logs/
  >>>

  output {
    File readTrimmingFastqR1 = "~{outputFileNamePrefix}_R1.trimmed.fastq.gz"
    File readTrimmingFastqR2 = "~{outputFileNamePrefix}_R2.trimmed.fastq.gz"
    File readMappingBam = "results/ncovIllumina_sequenceAnalysis_readMapping/~{outputFileNamePrefix}.sorted.bam"
    File trimPrimerSequencesBam = "results/ncovIllumina_sequenceAnalysis_trimPrimerSequences/~{outputFileNamePrefix}.mapped.bam"
    File trimPrimerSequencesPrimerTrimmedBam = "results/ncovIllumina_sequenceAnalysis_trimPrimerSequences/~{outputFileNamePrefix}.mapped.primertrimmed.sorted.bam"
    File makeConsensusFasta = "results/ncovIllumina_sequenceAnalysis_makeConsensus/~{outputFileNamePrefix}.primertrimmed.consensus.fa"
    File callVariantsTsv = "results/ncovIllumina_sequenceAnalysis_callVariants/~{outputFileNamePrefix}.variants.tsv"
    File qcPlotsPng = "results/qc_plots/~{outputFileNamePrefix}.depth.png"
    File qcCsv = "results/~{outputFileNamePrefix}.qc.csv"
    File nextflowLogs = "~{outputFileNamePrefix}.logs.tar.gz"
  }

  runtime {
    memory: "~{mem} GB"
    modules: "~{modules}"
    timeout: "~{timeout}"
  }

  parameter_meta {
    fastqR1: "Read 1 fastq file."
    fastqR2: "Read 2 fastq file."
    outputFileNamePrefix: "Output prefix to prefix output file names with."
    schemeVersion: "The Artic primer scheme version that was used."
    viralContigName: "Viral contig name to retain during non-human filtering step."
    allowNoprimer: "Allow reads that don't have primer sequence? Ligation prep = false, nextera = true."
    illuminaKeepLen: "Length of illumina reads to keep after primer trimming."
    illuminaQualThreshold: "Sliding window quality threshold for keeping reads after primer trimming (illumina)."
    mpileupDepth: "Mpileup depth for ivar."
    ivarFreqThreshold: "ivar frequency threshold for variant."
    ivarMinDepth: "Minimum coverage depth to call variant."
    additionalParameters: "Additional parameters to add to the nextflow command."
    mem: "Memory (in GB) to allocate to the job."
    timeout: "Maximum amount of time (in hours) the task can run for."
    modules: "Environment module name and version to load (space separated) before command execution."
    ncov2019ArticNextflowPath: "Path to the ncov2019-artic-nf-illumina repository directory."
    ncov2019ArticPath: "Path to the artic-ncov2019 repository directory or url"
    compositeHumanVirusReferencePath: "Path to the composite reference to use during non-human filtering step."
  }
}
