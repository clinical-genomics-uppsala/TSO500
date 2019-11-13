
S_rna = []
for s in config["RNA_Samples"].values() :
    S_rna.append(s)
fastq1_files = ["fastq_temp/RNA/" + s + "_" + i + "_R1_001.fastq.gz" for s,i in zip(config["RNA_Samples"], S_rna)]
fastq2_files = ["fastq_temp/RNA/" + s + "_" + i + "_R2_001.fastq.gz" for s,i in zip(config["RNA_Samples"], S_rna)]

rule fix_fastq_RNA_bash:
    input:
        fastq1 = fastq1_files,
        fastq2 = fastq2_files
    output:
        bash_scripts_rna = ["fastq_temp/RNA/" + s + ".fix_fastq.sh" for s in config["RNA_Samples"]]
    params:
        RNA_samples = [s for s in config["RNA_Samples"]]
    run:
        import subprocess
        subprocess.call("mkdir fastq",shell=True)
        i = 0
        for sample in params.RNA_samples :
            bs = open("fastq_temp/RNA/" + sample + ".fix_fastq.sh", "w")
            bs.write("for s in " + S_rna[i] + "," + sample + "; do\n")
            bs.write("\tIFS=\",\";\n")
            bs.write("\tset -- $s;\n")
            bs.write("\tsample_number=$1;\n")
            bs.write("\tsample=$2\n")
            bs.write("\t\tfor r in R1 R2; do\n")
            bs.write("\t\t\techo \"zcat fastq_temp/RNA/\"$sample\"_\"$sample_number\"_\"$r\"* | awk '{if(/^@/){split(\$0,a,\\\":\\\");print(a[1]\\\":\\\"a[2]\\\":\\\"a[3]\\\":\\\"a[4]\\\":\\\"a[5]\\\":\\\"a[6]\\\":\\\"a[7]\\\":UMI_\\\"gsub(\\\"+\\\",\\\"\\\",a[8])\\\":\\\"a[9]\\\":\\\"a[10]\\\":\\\"a[11])}else{print(\$0)}}' | gzip > fastq/RNA/\"$sample\"_\"$r\".fastq.gz &\";\n")
            bs.write("\t\tdone  | bash -\n")
            bs.write("done\n")
            bs.write("sleep 3600\n")
            bs.close()
            subprocess.call("chmod 774 fastq_temp/RNA/" + sample + ".fix_fastq.sh", shell=True)
            i += 1


# S_rna = []
# for s in config["RNA_Samples"].values() :
#     S_rna.append(s)
# fastq_files_R1 = ["fastq_temp/RNA/" + s + "_" + Si + "_L00" + L + "_R1_001.fastq.gz" for s,Si,L,R in zip(config["RNA_Samples"], S_rna, ["1","2","3","4"])]
# fastq_files_R2 = ["fastq_temp/RNA/" + s + "_" + Si + "_L00" + L + "_R1_001.fastq.gz" for s,Si,L,R in zip(config["RNA_Samples"], S_rna, ["1","2","3","4"])]
#
#
# rule fix_fastq_RNA_bash_R1:
#     input:
#         fastq = fastq_files_R1,
#     output:
#         bash_scripts = ["fastq_temp/RNA/" + s + ".fix_fastq_R1.sh" for s in config["RNA_Samples"]]
#     params:
#         samples = expand(config["RNA_Samples"])
#     run:
#         import subprocess
#         i = 1
#         for sample in params.samples :
#             bs = open("fastq_temp/RNA/" + sample + ".fix_fastq_R1.sh", "w")
#             bs.write("for s in " + S_rna[i] + "," + sample + "; do\n")
#             bs.write("\tIFS=\",\";\n")
#             bs.write("\tset -- $s;\n")
#             bs.write("\tsample_number=$1;\n")
#             bs.write("\tsample=$2\n")
#             bs.write("\tfor l in L001 L002 L003 L004; do\n")
#             #bs.write("\t\tfor r in R1 R2; do\n")
#             bs.write("\t\tfor r in R1; do\n")
#             #bs.write("\t\t\techo \"zcat fastq_temp/\"$sample\"_\"$sample_number\"_\"$l\"_\"$r\"* | awk '{if(/^@/){split(\$0,a,\\\":\\\");print(a[1]\\\":\\\"a[2]\\\":\\\"a[3]\\\":\\\"a[4]\\\":\\\"a[5]\\\":\\\"a[6]\\\":\\\"a[7]\\\":UMI_\\\"a[8]\\\":\\\"a[9]\\\":\\\"a[10]\\\":\\\"a[11])}else{print(\$0)}}' | gzip > fastq_temp2/\"$sample\"_\"$sample_number\"_\"$l\"_\"$r\"_001.fastq.gz &\";\n")
#             bs.write("\t\t\techo \"zcat fastq_temp/RNA/\"$sample\"_\"$sample_number\"_\"$l\"_\"$r\"* | awk '{if(/^@/){split(\$0,a,\\\":\\\");print(a[1]\\\":\\\"a[2]\\\":\\\"a[3]\\\":\\\"a[4]\\\":\\\"a[5]\\\":\\\"a[6]\\\":\\\"a[7]\\\":UMI_\\\"gsub(\\\"+\\\",\\\"\\\",a[8])\\\":\\\"a[9]\\\":\\\"a[10]\\\":\\\"a[11])}else{print(\$0)}}' | gzip > fastq/RNA/\"$sample\"_\"$r\".fastq.gz &\";\n")
#             bs.write("\t\tdone  | bash -\n")
#             bs.write("\tdone\n")
#             bs.write("done\n")
#             bs.write("sleep 3600\n")
#             #bs.write("zcat fastq_temp2/\"$sample\"_*_*_R1_001.fastq.gz | awk '{gsub(\"+\",\"\",$0); print($0);getline;print($0);getline;print($0);getline;print($0)}'  | gzip > fastq/\"$sample\"_R1.fastq.gz &\n")
#             #bs.write("zcat fastq_temp2/\"$sample\"_*_*_R2_001.fastq.gz | awk '{gsub(\"+\",\"\",$0); print($0);getline;print($0);getline;print($0);getline;print($0)}'  | gzip > fastq/\"$sample\"_R2.fastq.gz &\n")
#             #bs.write("sleep 3600\n")
#             #bs.write("rm -r fastq_temp/\n")
#             #bs.write("rm -r fastq_temp2/\n")
#             bs.close()
#             subprocess.call("chmod 774 fastq_temp/" + sample + ".fix_fastq_R1.sh", shell=True)
#             i += 1


# rule fix_fastq_RNA_bash_R2:
#     input:
#         fastq = fastq_files_R2,
#     output:
#         bash_scripts = ["fastq_temp/RNA/" + s + ".fix_fastq_R2.sh" for s in config["RNA_Samples"]]
#     params:
#         samples = expand(config["RNA_Samples"])
#     run:
#         import subprocess
#         i = 1
#         for sample in params.samples :
#             bs = open("fastq_temp/RNA/" + sample + ".fix_fastq_R2.sh", "w")
#             bs.write("for s in " + S_rna[i] + "," + sample + "; do\n")
#             bs.write("\tIFS=\",\";\n")
#             bs.write("\tset -- $s;\n")
#             bs.write("\tsample_number=$1;\n")
#             bs.write("\tsample=$2\n")
#             bs.write("\tfor l in L001 L002 L003 L004; do\n")
#             #bs.write("\t\tfor r in R1 R2; do\n")
#             bs.write("\t\tfor r in R2; do\n")
#             #bs.write("\t\t\techo \"zcat fastq_temp/\"$sample\"_\"$sample_number\"_\"$l\"_\"$r\"* | awk '{if(/^@/){split(\$0,a,\\\":\\\");print(a[1]\\\":\\\"a[2]\\\":\\\"a[3]\\\":\\\"a[4]\\\":\\\"a[5]\\\":\\\"a[6]\\\":\\\"a[7]\\\":UMI_\\\"a[8]\\\":\\\"a[9]\\\":\\\"a[10]\\\":\\\"a[11])}else{print(\$0)}}' | gzip > fastq_temp2/\"$sample\"_\"$sample_number\"_\"$l\"_\"$r\"_001.fastq.gz &\";\n")
#             bs.write("\t\t\techo \"zcat fastq_temp/RNA/\"$sample\"_\"$sample_number\"_\"$l\"_\"$r\"* | awk '{if(/^@/){split(\$0,a,\\\":\\\");print(a[1]\\\":\\\"a[2]\\\":\\\"a[3]\\\":\\\"a[4]\\\":\\\"a[5]\\\":\\\"a[6]\\\":\\\"a[7]\\\":UMI_\\\"gsub(\\\"+\\\",\\\"\\\",a[8])\\\":\\\"a[9]\\\":\\\"a[10]\\\":\\\"a[11])}else{print(\$0)}}' | gzip > fastq/RNA/\"$sample\"_\"$r\".fastq.gz &\";\n")
#             bs.write("\t\tdone  | bash -\n")
#             bs.write("\tdone\n")
#             bs.write("done\n")
#             bs.write("sleep 3600\n")
#             #bs.write("zcat fastq_temp2/\"$sample\"_*_*_R1_001.fastq.gz | awk '{gsub(\"+\",\"\",$0); print($0);getline;print($0);getline;print($0);getline;print($0)}'  | gzip > fastq/\"$sample\"_R1.fastq.gz &\n")
#             #bs.write("zcat fastq_temp2/\"$sample\"_*_*_R2_001.fastq.gz | awk '{gsub(\"+\",\"\",$0); print($0);getline;print($0);getline;print($0);getline;print($0)}'  | gzip > fastq/\"$sample\"_R2.fastq.gz &\n")
#             #bs.write("sleep 3600\n")
#             bs.close()
#             subprocess.call("chmod 774 fastq_temp/" + sample + ".fix_fastq_R2.sh", shell=True)
#             i += 1


rule fix_fastq_run_RNA:
    input:
        bash_scripts_RNA = "fastq_temp/RNA/{sample}.fix_fastq.sh"
    output:
        merged_fastq_R1_RNA = "fastq/RNA/{sample}_R1.fastq.gz",
        merged_fastq_R1_RNA = "fastq/RNA/{sample}_R2.fastq.gz"
    shell:
        "{input.bash_scripts_RNA}"

# rule fix_fastq_run_RNA_R1:
#     input:
#         bash_scripts_RNA = "fastq_temp/RNA/{sample}.fix_fastq_R1.sh"
#     output:
#         merged_fastq_R1_RNA = "fastq/RNA/{sample}_R1.fastq.gz"
#     shell:
#         "{input.bash_scripts_RNA}"
#
# rule fix_fastq_run_RNA_R2:
#     input:
#         bash_scripts_RNA = "fastq_temp/RNA/{sample}.fix_fastq_R2.sh"
#     output:
#         merged_fastq_R2_RNA = "fastq/RNA/{sample}_R2.fastq.gz"
#     shell:
#         "{input.bash_scripts_RNA}"
