import * as mathjs from "mathjs";
import { Entry } from "./specs";

export function normalize(entry: Entry): Entry {
    return mapEntry(entry, (n) => mathjs.round(n, 3) as number);
}

export function mean(entries: Entry[]) {
    return mapEntries(entries, (ns) => mathjs.mean(ns));
}

export function msToS(entry: Entry): Entry {
    return mapEntry(entry, (n) => normalize(n / 1000));
}

export function mixed(entries: Entry[]): Entry {
    const [ entry ] = entries;
    return entries.every((e) => e === entry) ? entry : undefined;
}

function mapEntry(entry: Entry, f: (_: number) => Entry): Entry {
    if (entry === undefined) {
        return undefined;
    }

    if (typeof(entry) === "string") {
        entry = Number(entry);
    }

    return f(entry);
}

function mapEntries(entries: Entry[], f: (_: number[]) => Entry): Entry {
    const filtered = entries
        .filter((n) => n !== undefined)
        .map((n) => typeof(n) === "string" ? Number(n) : n) as number[];

    return filtered.length > 0 ? f(filtered) : undefined;
}
