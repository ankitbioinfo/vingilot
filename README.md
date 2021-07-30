# Kallisto bustools bwa RaceID ssam docker image 

use the following dockerfile https://github.com/ankitbioinfo/vingilot/blob/main/DockerKallisto_v2/Dockerfile

sshuttle -x 132.187.15.2/32 -r extgruenlab3@login6.informatik.uni-wuerzburg.de 132.187.14.0/20

fastbuildah --runroot /tmp/${USER}/.local/share/containers/runroot --root /tmp/${USER}/.local/share/containers/storage/ bud --layers -t ls6-stud-registry.informatik.uni-wuerzburg.de/${USER}/jupyterlab-with-bwa-kallisto-raceid .

fastbuildah --runroot /tmp/${USER}/.local/share/containers/runroot --root /tmp/${USER}/.local/share/containers/storage/ push ls6-stud-registry.informatik.uni-wuerzburg.de/${USER}/jupyterlab-with-bwa-kallisto-raceid

give_me_jupyter 1 4Gi 0 ls6-stud-registry.informatik.uni-wuerzburg.de/extgruenlab3/jupyterlab-with-bwa-kallisto-raceid

kubectl port-forward -n extgruenlab3 deployment/jupyterlab 8888:8888

localhost:8888

release_my_jupyter

# cellRanger docker image 
