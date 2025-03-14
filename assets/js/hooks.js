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

export default Hooks;
