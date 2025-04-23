version 1.0

task sum_gaps {
  input {
    File assembly
  }

  command <<<
    gzip -d --stdout '~{assembly}' | \
        grep -o 'unzipped_assembly' | \
        wc -l
  >>>

  runtime {
    docker: "quay.io/biocontainers/gzip:1.11"
  }

  output {
    String num_gaps = read_string(stdout())
  }
}

workflow sum_gaps_matuska {
  input {
    File assembly
  }

  call sum_gaps {
    input:
    assembly = assembly
  }

  output {
    String num_gaps = sum_gaps.num_gaps
  }
}
