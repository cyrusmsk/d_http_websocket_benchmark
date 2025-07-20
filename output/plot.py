import matplotlib.pyplot as plt
import json

with open("data.json", "r") as f:
    main_data = json.load(f)

clients = ['d_data', 'py_data']

for cl in clients:
    data = main_data[cl]

    categories = []
    mean_values = []
    min_values = []
    max_values = []

    data = sorted(data, key=lambda d: sorted(d.keys())[0])
    for item in data:
        for key, values in item.items():
            categories.append(key)
            mean_values.append(sum(values)/len(values))
            min_values.append(min(values))
            max_values.append(max(values))

    plt.figure(figsize=(8, 5))
    plt.bar(categories, mean_values, color='skyblue', width=0.6)

    x_pos = list(range(len(categories)))
    plt.scatter(x_pos, min_values, color='red', s=10, label='Min', zorder=3)
    plt.scatter(x_pos, max_values, color='green', s=10, label='Max', zorder=3)

    # Rotate x-tick labels
    plt.xticks(rotation=30, ha='right')  # Rotate 30 degrees

    plt.title('Number of roundtrips per second (higher is better)')
    plt.ylabel('Mean Value')
    plt.tight_layout()  # Adjust layout to prevent label cutoff
    plt.grid(axis='y', alpha=0.3)
    plt.legend()
    plt.subplots_adjust(bottom=0.15)
    plt.savefig(f"plot_{cl}.png", dpi=300, bbox_inches='tight')
    plt.close()
