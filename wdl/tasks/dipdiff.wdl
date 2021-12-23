version 1.0

task dipdiff_t {
  input {
    File ctgsPat
	File ctgsMat
	File reference
    Int threads = 32
    Int memSizeGb = 128
    Int diskSizeGb = 100
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
    docker: "mkolmogo/dipdiff:0.3"
    cpu: threads
    memory: memSizeGb + " GB"
    disks: "local-disk " + diskSizeGb + " SSD"
  }
}
