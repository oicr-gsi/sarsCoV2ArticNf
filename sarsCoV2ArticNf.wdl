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
    }

    parameter_meta {
        bcl2fastqMetas: "Samples, lanes, and runDirectory for bcl2fastq"
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
        
      }
    }

    call bcl2fastq.bcl2fastq {
      input:
        samples = bcl2fastqMeta.samples,
        lanes = bcl2fastqMeta.lanes,
        runDirectory = bcl2fastqMeta.runDirectory
    }

    File fastqR1Bcl = select_first([bcl2fastq.fastqs])[0].fastqs.left
    File fastqR2Bcl = select_first([bcl2fastq.fastqs])[1].fastqs.left
    String name =  select_first([bcl2fastq.fastqs])[0].name 

    call ncov2019ArticNf.ncov2019ArticNf {
        input:
          fastqR1 = fastqR1Bcl,
          fastqR2 = fastqR2Bcl, 
          outputFileNamePrefix = name,
          schemeVersion = schemeVersionInput
    }

    output {

    }
}

