version 1.0

task shasta_t {
  input {
    File reads
    Int threads = 96
    String shastaConfig = "Nanopore-Oct2021"
    Int memSizeGb = 624
    Int diskSizeGb = 1024
  }

  command <<<
    set -o pipefail
    set -e
    set -u
    set -o xtrace

    SHASTA_INPUT=~{reads}
    if [ "${SHASTA_INPUT: -3}" == ".gz" ]
    then
      if [ "${SHASTA_INPUT: -4}" == "q.gz" ]
      then
        UNGZIPPED=${SHASTA_INPUT:0:-3}.fasta
        zcat $SHASTA_INPUT | awk '{if(NR%4==1) {printf(">%s\n",substr($0,2));} else if(NR%4==2) print;}' > ${UNGZIPPED}
      else
        UNGZIPPED=${SHASTA_INPUT:0:-3}
        zcat $SHASTA_INPUT > ${UNGZIPPED}
      fi
      rm $SHASTA_INPUT
      SHASTA_INPUT=${UNGZIPPED}
    fi
    shasta --input $SHASTA_INPUT --config ~{shastaConfig} --threads ~{threads} --memoryMode filesystem --memoryBacking disk
  >>>

  output {
    File shastaFasta = "ShastaRun/Assembly.fasta"
    File shastaGfa = "ShastaRun/Assembly.gfa"
  }

  runtime {
    docker: "mkolmogo/card_shasta"
    cpu: threads
    memory: memSizeGb + " GB"
    disks: "local-disk " + diskSizeGb + " SSD"
    #cpuPlatform: "Intel Cascade Lake"
  }
}
