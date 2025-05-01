import matplotlib.pyplot as plt
import json

data = {
    "py_data": [
        {
            "py-aiohttp": [
                6431.0,
                6445.0,
                6448.0
            ]
        },
        {
            "py-blacksheep": [
                4909.0,
                4913.0,
                4915.0
            ]
        }
    ]
}

# Extract the data for plotting
labels = []
values = []

for item in data["py_data"]:
    for key, val in item.items():
        labels.append(key)
        values.append(val)

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
