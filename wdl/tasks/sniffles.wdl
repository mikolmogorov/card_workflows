version 1.0

task sniffles_t {
  input {
    Int threads
	File bamAlignment
	Int memSizeGb = 128
	Int diskSizeGb = 256
	String trfAnnotations = ""
	Int minSvLen = 30
  }
  
  command <<<
    set -o pipefail
    set -e
    set -u
    set -o xtrace

    TRF_STRING=""
    if [ ! -z ~{trfAnnotations} ]
    then
       TRF_STRING="--tandem-repeats /opt/trf_annotations/~{trfAnnotations}"
    fi
    echo $TRF_STRING

    samtools index -@ 10 ~{bamAlignment}
    sniffles -i ~{bamAlignment} -v sniffles.vcf -t ~{threads} ${TRF_STRING} --minsvlen ~{minSvLen} 2>&1 | tee sniffles.log
  >>>

  output {
	File snifflesVcf = "sniffles.vcf"
	File snifflesLog = "sniffles.log"
  }

  runtime {
    docker: "mkolmogo/card_sniffles:2.0.3"
    cpu: threads
	memory: memSizeGb + " GB"
	disks: "local-disk " + diskSizeGb + " SSD"
  }
}
