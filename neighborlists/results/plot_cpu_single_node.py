import matplotlib.pyplot as plt
import numpy as np

plt.rcParams.update({'font.size': 14})
plt.rcParams.update({'hatch.color': 'black'})

results = {}
results['AnyDSL']               =       [13043.8,   7699.6,   13430.8,   13668.2  ]
results['AnyDSL (C++)']         =       [7172.65,   3010.5,   4535.9,    5921.43  ]
results['miniMD']               =       [15475.209, 7957.003, 14767.304, 14211.262]
results['miniMD (opt)']         =       [11524.212, 3874.003, 6090.834,  8237.429 ]

results_sec = {}

for p in results:
    results_sec[p] = [i / 1000.0 for i in results[p]]

processors = ['naples', 'cascadelake', 'skylake', 'broadwell']
variants = [variant for variant in results]
variants.sort(reverse=True)

print(variants)

x = np.arange(len(processors))
bar_width = 0.2
bar_sep = 0.005

fig = plt.figure()

plt.bar(x - 3 * bar_width / 2, results_sec[variants[0]], bar_width - bar_sep * 0.5, align='center', alpha=0.5, label=variants[0], color='#ff0000', edgecolor='black')
plt.bar(x - bar_width / 2,     results_sec[variants[1]], bar_width - bar_sep * 0.5, align='center', alpha=0.5, label=variants[1], color='#00ffff', edgecolor='black')
plt.bar(x + bar_width / 2,     results_sec[variants[2]], bar_width - bar_sep * 0.5, align='center', alpha=0.5, label=variants[2], color='#00ff00', edgecolor='black')
plt.bar(x + 3 * bar_width / 2, results_sec[variants[3]], bar_width - bar_sep * 0.5, align='center', alpha=0.5, label=variants[3], color='#ffff00', edgecolor='black')

#plt.bar(x - bar_width * 2, results_sec[variants[0]], bar_width - bar_sep * 0.5, align='center', alpha=0.5, label=variants[0])
#plt.bar(x - bar_width,     results_sec[variants[1]], bar_width - bar_sep * 0.5, align='center', alpha=0.5, label=variants[1])
#plt.bar(x,                 results_sec[variants[2]], bar_width - bar_sep * 0.5, align='center', alpha=0.5, label=variants[2])
#plt.bar(x + bar_width,     results_sec[variants[3]], bar_width - bar_sep * 0.5, align='center', alpha=0.5, label=variants[3])
#plt.bar(x + bar_width * 2, results_sec[variants[4]], bar_width - bar_sep * 0.5, align='center', alpha=0.5, label=variants[4])

plt.xticks(x, processors)
plt.xlabel("Architecture");
plt.ylabel("Time (s)")
plt.ylim(0, 30)
plt.axes().yaxis.grid(linestyle=':', linewidth=0.15)
plt.legend()
plt.tight_layout()

fig.savefig("pdf/cpu_single_node.pdf", bbox_inches = 'tight', pad_inches = 0)
