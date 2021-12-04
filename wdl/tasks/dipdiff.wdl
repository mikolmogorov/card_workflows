version 1.0

task dipdiff_t {
  input {
    Int threads
    File ctgsPat
	File ctgsMat
	File reference
    Int memSizeGb = 128
    Int diskSizeGb = 500
  }

  command <<<
    set -o pipefail
    set -e
    set -u
    set -o xtrace

    dipdiff --reference ~{reference} --pat ~{ctgsPat} --mat ~{ctgsMat} -t ~{threads}
  >>>

  output {
    File dipdiffVcf = "variants.vcf"
  }

  runtime {
    docker: "mkolmogo/dipdiff:0.1"
    cpu: threads
    memory: memSizeGb + " Gb"
    disk: "local-disk " + diskSizeGb
  }
}
