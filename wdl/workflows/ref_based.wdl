version 1.0

import "../tasks/minimap2.wdl" as minimap2_t

workflow smallVariantsReferenceBased {

    input {
        String sampleName
        File referenceFile
        File readsFile
		Int threads
    }

    ### Dipcall: ###
    call minimap2_t.minimap2_t as minimap2 {
        input:
            threads=threads,
            reference=referenceFile,
            reads=readsFile
    }


    ### Consolidation ###
    call getBamStats {
        input:
            bamFile = minimap2.bam
    }

	output {
		File alignment = minimap2.bam
        File bamStats = getBamStats.out
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
