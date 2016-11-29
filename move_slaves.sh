#!/bin/bash -xe

ruby ./acquire_slaves.rb \
  --label svt \
  --jenkins svt.jenkins.klarna.net \
  --username leandro.ostera \
  --token 8feab793f8f9a5ed8585c42e8118e2a1 \
  --fqdn esup.cloud.internal.machines \
  --port 22 \
  --mode EXCLUSIVE \
  --home /home/jenkins \
  svt-slave-byngaude \
  svt-slave-cidapail \
  svt-slave-ellystoy \
  svt-slave-hebojelm

ruby ./acquire_slaves.rb \
  --label orchid-svt \
  --jenkins svt.jenkins.klarna.net \
  --username leandro.ostera \
  --token 8feab793f8f9a5ed8585c42e8118e2a1 \
  --fqdn esup.cloud.internal.machines \
  --port 22 \
  --mode EXCLUSIVE \
  --home /home/jenkins \
  orchid-svt-slave-mayeravo \
  orchid-svt-slave-mayeravo \
  orchid-svt-slave-nematemp \
  orchid-svt-slave-numatosk \
  orchid-svt-slave-perlkval \
  orchid-svt-slave-sadasass
