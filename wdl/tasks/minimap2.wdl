version 1.0

task minimap2_t {
  input {
    Int threads
    File reference
    File reads
	String mapMode = "map-ont"
	Int memSizeGb = 64
	Int diskSizeGb = 32
  }

  command <<<
    set -o pipefail
    set -e
    set -u
    set -o xtrace
    
    minimap2 -ax ~{mapMode} ~{reference} ~{reads} -K 5G -t ~{threads} | samtools sort -@ 4 -m 4G > minimap2.bam
    samtools index -@ ~{threads} minimap2.bam
  >>>

  output {
    File bam = "minimap2.bam"
	File bamIndex = "minimap2.bam.bai"
  }

  runtime {
    docker: "mkolmogo/card_mapping"
    cpu: threads
	memory: memSizeGb + " Gb"
	disk: "local-disk " + diskSizeGb
  }
}
