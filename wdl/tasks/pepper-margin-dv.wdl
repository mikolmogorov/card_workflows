version 1.0

task pepper_margin_dv_t {
  input {
    Int threads
    File reference
	File bamAlignment
	String mapMode = "ont"
	Int memSizeGb = 64
	Int diskSizeGb = 32
  }

  String pepperMode = if mapMode == "ont" then "--ont_r9_guppy5_sup" else "--hifi"

  command <<<
    samtools index -@ 10 ~{bamAlignment}
    run_pepper_margin_deepvariant call_variant -b ~{bamAlignment} -f ~{reference} -o `pwd` -t ~{threads} ~{pepperMode}
  >>>

  output {
	File pepperVcf = "PEPPER_MARGIN_DEEPVARIANT_OUTPUT.vcf.gz"
    File haplotaggedBam = "intermediate_files/PHASED.PEPPER_MARGIN.haplotagged.bam"
  }

  runtime {
    docker: "kishwars/pepper_deepvariant:r0.6"
    cpu: threads
	memory: memSizeGb + " Gb"
	disk: "local-disk " + diskSizeGb
  }
}