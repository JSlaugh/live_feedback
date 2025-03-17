const keyframes = [
	{ opacity: 0, transform: "scale(0.95)" },
	{ opacity: 1, transform: "scale(1)" },
];

const animate = async (nav, keyframes, options) => {
	const animation = nav.animate(keyframes, options);

	await animation.finished;

	animation.commitStyles();
	animation.cancel();
};

const pendingAnimations = (el) => {
	return el.getAnimations().length > 0;
};

const close = async (nav, button) => {
	await animate(nav, [...keyframes].reverse(), {
		duration: 75,
		easing: "ease-out",
		fill: "forwards",
	});

	nav.setAttribute("hidden", "");
	button.setAttribute("aria-expanded", "false");
};

const open = async (nav, button) => {
	nav.removeAttribute("hidden");
	button.setAttribute("aria-expanded", "true");

	await animate(nav, keyframes, {
		duration: 100,
		easing: "ease-out",
		fill: "forwards",
	});
};

export const setupDropdowns = () => {
	document.querySelectorAll(`[data-component="dropdown"]`).forEach((el) => {
		const button = el.querySelector("button");
		const nav = el.querySelector("nav");

		if (!button || !nav)
			throw new Error("dropdown component must have a button and a nav");

		el.addEventListener("close", () => {
			if (!pendingAnimations(nav)) {
				const isOpen = button.getAttribute("aria-expanded") === "true";

				isOpen ? close(nav, button) : undefined;
			}
		});

		el.addEventListener("toggle", () => {
			if (!pendingAnimations(nav)) {
				const isOpen = button.getAttribute("aria-expanded") === "true";

				isOpen ? close(nav, button) : open(nav, button);
			}
		});
	});
};
