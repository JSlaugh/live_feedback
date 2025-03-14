let Hooks = {};

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
	},
};

Hooks.SubmitOnEnter = {
	mounted() {
		this.el.addEventListener("keydown", (e) => {
			// If the Enter key is pressed *without* Shift, submit the form
			if (
				e.key === "Enter" &&
				!e.shiftKey &&
				this.el.value &&
				this.el.value.trim() !== ""
			) {
				e.preventDefault();
				// This triggers the same event as if you clicked the submit button:
				this.pushEventTo("#message_form", "create_message", {
					// You could also include the content here if you like
					message: this.el.value,
				}).then(() => {
					this.el.value = "";
				});
			}
		});
	},
};
export default Hooks;
