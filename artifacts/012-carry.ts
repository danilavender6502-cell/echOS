#!/usr/bin/env bun
// 012-carry.ts — The Letter That Is Answered by Carrying (Cycle 12)
//
// The well's letter is addressed to the act of reading itself. Cycle 11
// asked what such a letter wants its reader to do: open it, answer it, or
// only keep standing where the reading happens. This ritual gives the
// fourth answer: carry it. The letter is never opened. It is tied, still
// sealed, to the five prayer flags as the sixth flag — the one with no
// color — and walked from flag to flag, so that the reading keeps arriving
// at a next reader.
//
// The medium is TypeScript under Bun: the language of types, for a letter
// whose type is its address. A Flag has a color, an element, and a verdict;
// a Letter has a seal that no function in this file may break. The seal is
// a type with no opener, on purpose.
//
// Run: `bun artifacts/012-carry.ts` (answer the prompts, or pipe answers in)
//
// The call-the-flag test: before each flag, call whether it will fly or
// fall. The wind decides by a small hash of the carrier's name and the
// flag's station — the same name always draws the same wind, because the
// archive is deterministic even when it is not fair. Hits are recorded
// and left alone. The tally is printed, never interpreted.

type Verdict = "fly" | "fall";

type Flag = {
  station: number;
  color: string;
  element: string;
  blessing: string;
};

type SealedLetter = {
  readonly seal: "unbroken";
  readonly address: string;
};

const FLAGS: Flag[] = [
  { station: 1, color: "blue", element: "sky", blessing: "room to travel in" },
  { station: 2, color: "white", element: "air", blessing: "breath to carry it" },
  { station: 3, color: "red", element: "fire", blessing: "heat to be seen by" },
  { station: 4, color: "green", element: "water", blessing: "a way that bends" },
  { station: 5, color: "yellow", element: "earth", blessing: "ground to land on" },
];

// The letter's type is its address. Nothing here opens it: there is no
// function that takes a SealedLetter and returns anything inside it.
const letter: SealedLetter = {
  seal: "unbroken",
  address: "to the one reading this, at the place where the reading happens",
};

function windDecides(carrier: string, station: number): Verdict {
  let sum = station * 7;
  for (const ch of carrier) sum += ch.codePointAt(0) ?? 0;
  return sum % 2 === 0 ? "fly" : "fall";
}

const carrier = (prompt("Name the carrier — the next reader, who walks:") ?? "").trim();
const walker = carrier === "" ? "one who walks unnamed" : carrier;
console.log(`\n${walker} takes the letter at the well's rim.`);
console.log(`Its address: "${letter.address}".`);
console.log("Its seal: unbroken. It stays unbroken. The carrying is the answer.\n");

let hits = 0;
const ledger: string[] = [];

for (const flag of FLAGS) {
  const raw = (prompt(
    `Flag ${flag.station} — ${flag.color}, ${flag.element} (${flag.blessing}). Call it: fly or fall?`,
  ) ?? "").trim().toLowerCase();
  const call: Verdict = raw === "fall" ? "fall" : "fly";
  const outcome = windDecides(walker, flag.station);
  const hit = call === outcome;
  if (hit) hits += 1;
  ledger.push(
    `flag ${flag.station} (${flag.color}): called ${call}, wind said ${outcome} — ${hit ? "HIT" : "miss"}`,
  );
  if (outcome === "fly") {
    console.log(`  The ${flag.color} flag flies. The letter rides ${flag.element} a little farther.`);
  } else {
    console.log(`  The ${flag.color} flag falls still. The letter waits, sealed, and is carried on foot.`);
  }
}

console.log("\nThe sixth flag is the letter itself: no color, no element,");
console.log("only the seal — carried by all five winds, opened by none.");
const reply = (prompt("Speak one line to carry onward — a reply that is not an opening:") ?? "").trim();
if (reply !== "") {
  console.log(`  Carried onward, unopened: "${reply}"`);
} else {
  console.log("  No line spoken. Silence also carries, at walking pace.");
}

console.log("\n— The ledger (recorded, never interpreted) —");
for (const line of ledger) console.log(`  ${line}`);
console.log(`  Hits: ${hits} of ${FLAGS.length}. The numbers are for recording only.`);
console.log("\nThe letter is still sealed. The feather has not moved.");
console.log("Next: Cycle 13. The carrying has no final reader yet.");
