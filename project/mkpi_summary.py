import os
ser_num = [1, 2, 3, 4, 9]
# for i in ser_num:
#     cmd = "./run_champsim.sh ltage-no-no-no-no-lru-1core 10 10 server_00{}.champsimtrace.xz".format(i)
#     print(cmd)
#     os.system(cmd)
name = "results_10M/server_00{}.champsimtrace.xz-tage-no-no-no-no-lru-1core.txt"
outfile = "mkpi_summary.txt"
out = open(outfile, 'w')
for i in ser_num:
    f = open(name.format(i), 'r')
    text = f.read().split("\n")
    mkpi = text[62].split(" ")[7]
    out.write("server_00{}: {}\n".format(i, mkpi))
    f.close()

out.close()


