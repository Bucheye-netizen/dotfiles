const hyprland = await Service.import("hyprland");
const notifications = await Service.import("notifications");
const mpris = await Service.import("mpris");
const audio = await Service.import("audio");
const battery = await Service.import("battery");
const systemtray = await Service.import("systemtray");

App.config({
  style: "/home/lisan/nix/home/ags/style.css",
  windows: [Bar()],
});
