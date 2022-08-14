version 1.0

import "../tasks/minimap2.wdl" as minimap2_t
import "../tasks/sniffles.wdl" as sniffles_t
import "../tasks/pepper-margin-dv.wdl" as pepper_t

workflow smallVariantsReferenceBased {

    input {
        String sampleName
        File referenceFile
        File readsFile
        File vntrAnnotations = ""
        Int threads
    }

    ### minimap2 alignent ###
    call minimap2_t.minimap2_t as minimap2 {
        input:
            threads=threads,
            reference=referenceFile,
            reads=readsFile,
			useMd=true
    }


	### P-M-DV
    call pepper_t.pepper_margin_dv_t as pepper_t {
        input:
            threads=threads,
            reference=referenceFile,
			bamAlignment=minimap2.bam
    }

	### Sniffles
    call sniffles_t.sniffles_t as sniffles_t {
        input:
            threads=threads,
			bamAlignment=minimap2.bam,
			vntrAnnotations=vntrAnnotations
    }

	output {
        File smallVariantsVcf = pepper_t.pepperVcf
        File structuralVariantsSniffles = sniffles_t.snifflesVcf
	}
}
