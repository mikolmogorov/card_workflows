version 1.0

task dipdiff_t {
  input {
    File ctgsPat
	File ctgsMat
	File reference
    Int threads = 32
    Int memSizeGb = 128
    Int diskSizeGb = 256
	Int minSvSize = 30
  }

  command <<<
    set -o pipefail
    set -e
    set -u
    set -o xtrace

    dipdiff.py --reference ~{reference} --pat ~{ctgsPat} --mat ~{ctgsMat} --out-dir dipdiff -t ~{threads} --sv-size ~{minSvSize} 2>&1 | tee dipdiff.log
  >>>

  output {
    File dipdiffUnphasedVcf = "dipdiff/dipdiff_unphased.vcf.gz"
    File dipdiffPhasedVcf = "dipdiff/dipdiff_phased.vcf.gz"
    File dipdiffLog = "dipdiff.log"
  }

  runtime {
    docker: "mkolmogo/dipdiff:0.5"
    cpu: threads
    memory: memSizeGb + " GB"
    disks: "local-disk " + diskSizeGb + " SSD"
  }
}
