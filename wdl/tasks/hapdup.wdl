version 1.0

task hapdup_t {
  input {
    Int threads
    File alignedBam
	File contigs
    String readType = "ont"
    Int memSizeGb = 128
    Int diskSizeGb = 500
  }

  command <<<
    set -o pipefail
    set -e
    set -u
    set -o xtrace

    #Workaround for Python multiprocessing, fixes "AF_UNIX path too long"
    mkdir -p /tmp
    export TMPDIR="/tmp"

    flye-samtools index -@ 10 ~{alignedBam}
    hapdup --assembly ~{contigs} --bam ~{alignedBam} --out-dir hapdup -t ~{threads} --rtype ~{readType}
  >>>

  output {
    File hapdupHap1 = "hapdup/haplotype_1.fasta"
    File hapdupHap2 = "hapdup/haplotype_2.fasta"
  }

  runtime {
    docker: "mkolmogo/hapdup:0.4"
    cpu: threads
    memory: memSizeGb + " GB"
    disk: "local-disk " + diskSizeGb
  }
}
