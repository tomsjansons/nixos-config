#!/usr/bin/env bun
import { $ } from "bun";

const outputOrAction = process.argv[2];

function wsElement(symbol: string, shift: string, underline: boolean): string {
  return `${underline ? "<u>" : ""}<span font_size="large" baseline_shift='${shift}pt'>${symbol}</span>${underline ? "</u>" : ""}`;
}

if (outputOrAction === "up") {
  await $`niri msg action focus-workspace-up && pkill -SIGRTMIN+8 waybar;;`;
} else if (outputOrAction === "down") {
  await $`niri msg action focus-workspace-down && pkill -SIGRTMIN+8 waybar;;`;
} else {
  const output = outputOrAction;

  const workspaces = JSON.parse(await $`niri msg -j workspaces`.text()).filter(
    (ws) => ws.output === output,
  );

  const workspaceGlyphs = ["⑩", "①", "②", "③", "④", "⑤", "⑥", "⑦", "⑧", "⑨"];

  let workspaceIndicator = "  ";
  for (const ws of workspaces) {
    if (!Number.isNaN(parseInt(ws.name))) {
      workspaceIndicator +=
        parseInt(ws.name) > 9
          ? wsElement("○", "6", ws.is_active)
          : wsElement(workspaceGlyphs[parseInt(ws.name)], "5", ws.is_active);
    } else {
      workspaceIndicator += wsElement("○", "6", ws.is_active);
    }

    workspaceIndicator += "  ";
  }

  await $`echo "${JSON.stringify({ text: workspaceIndicator, tooltip: "" })}"`;
}
