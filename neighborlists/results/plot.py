import matplotlib.pyplot as plt
import numpy as np

plt.rcParams.update({'font.size': 20})
plt.rcParams.update({'hatch.color': 'black'})

labels = [1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048]
results = [2524.81, 3342.14, 3396.98, 3681.13, 4385.48, 5166.42, 5995.02, 6550.09, 9304.78, 9698.36, 11283.2, 14342.5]
results_s = [res / 1000 for res in results]

y_pos = np.arange(len(labels))
bar_width = 0.35
bar_sep = 0.1 

fig = plt.figure()

#for i in range(len(results)):
#    p1 = plt.bar(
#        y_pos + bar_width * i, results[i], bar_width - bar_sep * 0.5, color='#ff0000ff',
#        align='center', alpha=0.5)

#plt.xticks(y_pos + bar_width * 0.5 * (len(results) - 1), labels)
#plt.ylabel("Time (ms)")
#plt.axes().yaxis.grid(linestyle=':', linewidth=0.15)
#plt.legend()
#plt.tight_layout()

plt.xscale('log', basex=2)
plt.ylabel("Time (s)")
plt.xlabel("Number of nodes")
plt.plot(labels, results_s)

fig.savefig("pdf/gpu_scalability.pdf", bbox_inches = 'tight', pad_inches = 0)
