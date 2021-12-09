version 1.0

task shasta_t {
  input {
    Int threads
    File reads
    String shastaConfig = "Nanopore-Oct2021"
    Int memSizeGb = 512
    Int diskSizeGb = 512
  }

  command <<<
    set -o pipefail
    set -e
    set -u
    set -o xtrace

    SHASTA_INPUT=~{reads}
    if [ "${SHASTA_INPUT: -3}" == ".gz" ]
    then
      UNGZIPPED=${SHASTA_INPUT:0:-3}
      zcat $SHASTA_INPUT > ${UNGZIPPED}
      SHASTA_INPUT=${UNGZIPPED}
    fi
    shasta --input $SHASTA_INPUT --config ~{shastaConfig} --threads ~{threads}
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
  }
}
