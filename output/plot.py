import matplotlib.pyplot as plt
import json

# Extract the data for plotting
clients = {} 

with open("data.json", "r") as f:
    js = loads(f)

# Create the histogram
plt.figure(figsize=(10, 6))

# Plot each set of values
for i, (label, vals) in enumerate(zip(labels, values)):
    plt.hist(vals, bins=len(vals), alpha=0.7, label=label, align='left')

plt.xlabel('Value')
plt.ylabel('Frequency')
plt.title('Performance Data Histogram')
plt.legend()
plt.grid(True, axis='y', alpha=0.3)

plt.show()
