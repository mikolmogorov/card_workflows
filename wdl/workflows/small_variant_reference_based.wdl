version 1.0

import "../tasks/minimap2.wdl" as minimap2_t
import "../tasks/pepper-margin-dv.wdl" as pepper_t

workflow smallVariantsReferenceBased {

    input {
        String sampleName
        File referenceFile
        File readsFile
		Int threads
    }

    ### minimap2 alignent ###
    call minimap2_t.minimap2_t as minimap2 {
        input:
            threads=threads,
            reference=referenceFile,
            reads=readsFile
    }


	### P-M-DV
    call pepper_t.pepper_margin_dv_t as pepper_t {
        input:
            threads=threads,
            reference=referenceFile,
			bamAlignment=minimap2.bam
    }

	output {
        File smallVariantsVcf = pepper_t.pepperVcf
	}
}

task getBamStats {
  input {
   	File bamFile 
  }
  command <<<
    samtools stats ~{bamFile} > stats.txt
  >>>
  output {
    File out = "stats.txt"
  }
  runtime {
    docker: "mkolmogo/card_mapping"
  }
}
