version 1.0

import "../tasks/minimap2.wdl" as minimap2_t
import "../tasks/shasta.wdl" as shasta_t
import "../tasks/hapdup.wdl" as hapdup_t
import "../tasks/dipdiff.wdl" as dipdiff_t

workflow structuralVariantsDenovoAssembly {

    input {
        String sampleName
        File referenceFile
        File readsFile
        Int threads
    }

    ### Shasta assembly ###
    call shasta_t.shasta_t as shasta_t {
        input:
    #        threads=threads,
            reads=readsFile
    }

	### minimap2 alignent ###
    call minimap2_t.minimap2_t as minimap2 {
        input:
            threads=threads,
            reference=shasta_t.shastaFasta,
            reads=readsFile
    }

	### hapdup
	call hapdup_t.hapdup_t as hapdup_t {
		input:
			threads=threads,
			alignedBam=minimap2.bam,
			contigs=shasta_t.shastaFasta
	}

	### dipdiff
	call dipdiff_t.dipdiff_t as dipdiff_t {
		input:
			threads=threads,
			reference=referenceFile,
			ctgsPat=hapdup_t.hapdupHap1,
			ctgsMat=hapdup_t.hapdupHap2
	}

	output {
        File asmHap1 = hapdup_t.hapdupHap1
        File asmHap2 = hapdup_t.hapdupHap2
		File vcfWithSv = dipdiff_t.dipdiffVcf
	}
}
