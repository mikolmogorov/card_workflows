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

    dipdiff.py --reference ~{reference} --pat ~{ctgsPat} --mat ~{ctgsMat} --out-dir dipdiff -t ~{threads}
  >>>

  output {
    File dipdiffVcf = "dipdiff/variants.vcf"
  }

  runtime {
    docker: "mkolmogo/dipdiff:0.1"
    cpu: threads
    memory: memSizeGb + " GB"
    disk: "local-disk " + diskSizeGb
  }
}
