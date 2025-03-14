import Chart from 'chart.js/auto'
let Hooks = {}

Hooks.AutoClearFlash = {
  mounted() {
    let timeout = 3000; // Default timeout (success: 3 sec)

    if (this.el.dataset.kind === "info") {
      timeout = 5000; // Info last 5 seconds
    } else if (this.el.dataset.kind === "warning") {
      timeout = 7000; // Warning lasts 7 seconds
    }

    setTimeout(() => {
      this.pushEvent("lv:clear-flash", { key: this.el.dataset.kind });
    }, timeout);
  }
}

Hooks.PieChart = {
  mounted() {
    const ctx = this.el.getContext('2d')
    this.chart = new Chart(ctx, {
      type: 'pie',
      data: JSON.parse(this.el.dataset.chartData),
      options: {
        responsive: true,
        plugins: {
          legend: {
            position: 'top',
          },
          title: {
            display: true,
            text: 'Understanding Gauge'
          }
        }
      }
    })
  },
  updated() {
    const newData = JSON.parse(this.el.dataset.chartData);
  
    // Ensure labels are also updated
    this.chart.data.labels = newData.labels;
    this.chart.data.datasets[0].data = newData.datasets[0].data;
  
    // Force a full re-draw while keeping animation smooth
    this.chart.resize();
    this.chart.update();
  },
  destroyed() {
    this.chart.destroy()
  }
}


export default Hooks;
