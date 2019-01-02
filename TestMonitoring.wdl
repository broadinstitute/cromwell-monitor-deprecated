version 1.0

workflow TestMonitoring {
  Int timeout = 150

  call SleepTest {
    input:
      timeout = timeout
  }

  call StressTest {
    input:
      timeout = timeout
  }
}

task SleepTest {
  input {
    Int timeout
  }

  command <<<
    sleep ~{timeout}
  >>>

  runtime {
    docker: 'debian:stable-slim'
    disks: 'local-disk 1 HDD'
    memory: '1G'
    cpu: 1
    preemptible: 3
    maxRetries: 0
  }
}

task StressTest {
  input {
    Int timeout
  }

  Int cpu = 4
  Int memory = 8192
  Int memoryTest = ceil(memory * 0.8 / cpu)
  Int disk = cpu + 1

  command <<<
    apt-get update -qq
    apt-get install -qq stress

    stress \
      --vm ~{cpu} \
      --vm-bytes ~{memoryTest}M \
      -d ~{cpu} \
      -t ~{timeout}s
  >>>

  runtime {
    docker: 'debian:stable-slim'
    disks: 'local-disk ~{disk} HDD'
    memory: '~{memory}M'
    cpu: cpu
    preemptible: 3
    maxRetries: 0
  }
}
