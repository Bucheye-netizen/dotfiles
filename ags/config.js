export {};

const battery = await Service.import("battery");

const BatteryPercent = () =>
  Widget.Label().hook(
    battery,
    (self) => {
      self.label = `${battery.percent}`;
      self.visible = battery.available;
    },
    "changed"
  );

const bar = () =>
  Widget.Window({
    name: "bar",
    anchor: ["top", "left", "right"],
    child: BatteryPercent(),
  });

App.config({
  windows: [bar()],
});
