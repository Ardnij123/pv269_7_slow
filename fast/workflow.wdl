version 1.0

task split_fasta {
  input {
    File assembly
  }

  command <<<
    seqkit split --by-part 100 --out-dir 'assembly_parts' '~{assembly}'
  >>>

  runtime {
    docker: "staphb/seqkit:latest"
  }

  output {
    Array[File] assembly_files = glob("assembly_parts/*")
    Int num_parts = length(assembly_files)
  }
}

task sum_gaps {
  input {
    File assembly
  }

  command <<<
    assembly='~{assembly}'
    if [ "${assembly##*.}" == 'gz' ]; then
      gzip -d --stdout '~{assembly}'
    else
      cat '~{assembly}'
    fi | grep -o 'N' | wc -l
  >>>

  runtime {
    docker: "quay.io/biocontainers/gzip:1.11"
    preemptible: 1
  }

  output {
    Int num_gaps = read_int(stdout())
  }
}

# Taken from https://github.com/openwdl/wdl/blob/wdl-1.2/SPEC.md#comments
# example sum_task.wdl, editted to conform to WDL version 1.0
task sum {
  input {
    Array[Int]+ ints
  }
  
  command <<<
  printf '~{sep=" " ints}' | awk '{tot=0; for(i=1;i<=NF;i++) tot+=$i; print tot}'
  >>>

	runtime {
		docker: "ubuntu:latest"
		preemptible: 1
	}
  
  output {
    Int total = read_int(stdout())
  }
}

workflow sum_gaps_matuska {
  input {
    File assembly
  }

  call split_fasta {
    input:
    assembly = assembly
  }

  scatter (assembly_file in split_fasta.assembly_files) {
    call sum_gaps {
			input:
			assembly = assembly_file
		}
  }

	call sum {
		input:
		ints = sum_gaps.num_gaps
	}

  output {
    Int num_gaps = sum.total
  }
}
