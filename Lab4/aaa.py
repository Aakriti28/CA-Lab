# -*- coding: utf-8 -*-
from __future__ import unicode_literals
import os
import matplotlib.pyplot as plt
import numpy as np

prog = ["bfs", "matrix_multi", "matrix_multi_2", "quicksort"]
vers = ["baseline", "direct-mapped", "fully-associative", "reduced-size", "doubled-size", "reduced-mshr", "doubled-mshr"]
caches = ["L1D", "L1I", "L2C", "LLC"]
base = ".trace.xz-bimodal-no-no-no-no-lru-1core.txt"
IPC_IDX = 4
A_IDX = 3
MISS_IDX = 7

data_mpki = np.zeros((len(caches), len(vers) ,len(prog)))
data_ipc = np.zeros((len(vers), len(prog)))

def plotBars(X, title, ylabel):
    # set width of bar
    barWidth = 0.1
    fig = plt.subplots(figsize =(12, 8))
    
    # # set height of bar
    # IT = [12, 30, 1, 8, 22]
    # ECE = [28, 6, 16, 5, 10]
    # CSE = [29, 3, 24, 25, 17]
    
    # # Set position of bar on X axis
    # br1 = np.arange(len(IT))
    # br2 = [x + barWidth for x in br1]
    # br3 = [x + barWidth for x in br2]
    
    # # Make the plot
    # plt.bar(br1, IT, color ='r', width = barWidth,
    #         edgecolor ='grey', label ='IT')
    # plt.bar(br2, ECE, color ='g', width = barWidth,
    #         edgecolor ='grey', label ='ECE')
    # plt.bar(br3, CSE, color ='b', width = barWidth,
    #         edgecolor ='grey', label ='CSE')

    br = list(range(len(prog)))

    for i, v in enumerate(vers[1:]):
        br1 = [x+i*barWidth for x in br]
        plt.bar(br1, X[i+1], width=barWidth, edgecolor='grey', label=v)

    
    # Adding Xticks
    # plt.xlabel(xlabel, fontweight ='bold', fontsize = 15)
    plt.title(title)
    plt.ylabel(ylabel, fontweight ='bold', fontsize = 15)
    plt.xticks([r + 3*barWidth for r in range(len(prog))], prog)
    
    plt.legend()
    plt.savefig(f"images/{title}.png")

if __name__ == "__main__":
    os.makedirs("images/", exist_ok=True)

    for i, dir in enumerate(vers):
        for j, p in enumerate(prog):
            filename = f"champsim-results/{dir}/{p}{base}"
            
            k = 0
            with open(filename, 'r') as f :
                for line in f.readlines():
                    data = line.split()
                    l = len(data)
                    if(l > IPC_IDX-1 and data[IPC_IDX-1] == "IPC:"):
                        # print(line)
                        data_ipc[i][j] = float(data[IPC_IDX])
                    elif (l>1 and  data[0] == caches[k] and data[1] == "TOTAL"):
                        # print(line)
                        data_mpki[k][i][j] = int(data[MISS_IDX])/1e4
                        k+=1
                    
                    if(k>=len(caches)): break
    
    for i in range(len(caches)):
        data_mpki[i] = (-(data_mpki[i] - data_mpki[i][0])/data_mpki[i][0] )* 100

    data_ipc = data_ipc/data_ipc[0]
    print(data_ipc)
    print(data_mpki)

    for i in range(len(caches)):
        plotBars(data_mpki[i], f"{caches[i]}", "MPKI Improvement (in %)")
    
    plotBars(data_ipc, "IPC", "Normalised IPC")
