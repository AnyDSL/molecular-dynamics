import matplotlib.pyplot as plt
import numpy as np

plt.rcParams.update({'font.size': 14})
plt.rcParams.update({'hatch.color': 'black'})

results = {}
results['AnyDSL']               =       [1593.14,  1009.13,  399.363]
results['miniMD']               =       [2521.367, 1019.250, 414.487]

results_sec = {}

for p in results:
    results_sec[p] = [i / 1000.0 for i in results[p]]

processors = ['Pascal', 'Turing', 'Volta']
variants = [variant for variant in results]
variants.sort(reverse=True)

print(variants)

x = np.arange(len(processors))
bar_width = 0.2
bar_sep = 0.005

fig = plt.figure()

plt.bar(x - bar_width / 2, results_sec[variants[0]], bar_width - bar_sep * 0.5, align='center', alpha=0.5, label=variants[0], color='#ff0000', edgecolor='black')
plt.bar(x + bar_width / 2, results_sec[variants[1]], bar_width - bar_sep * 0.5, align='center', alpha=0.5, label=variants[1], color='#00ff00', edgecolor='black')

plt.xticks(x, processors)
plt.xlabel("Architecture");
plt.ylabel("Time (s)")
plt.ylim(0, 4)
plt.axes().yaxis.grid(linestyle=':', linewidth=0.15)
plt.legend()
plt.tight_layout()

fig.savefig("pdf/gpu_single_node.pdf", bbox_inches = 'tight', pad_inches = 0)
