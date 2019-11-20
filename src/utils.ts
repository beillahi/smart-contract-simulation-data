import * as mathjs from "mathjs";
import { Entry } from "./specs";

export function normalize(entry: Entry, n: number = 1): Entry {
    return mapEntry(entry, (x) => mathjs.round(x, n) as number);
}

export function mean(entries: Entry[], n: number = 1) {
    return mapEntries(entries, (xs) => `${mathjs.round(mathjs.mean(xs), n)}`);
}

export function dist(entries: Entry[], n: number = 1) {
    return mapEntries(entries, (xs) => `${mathjs.round(mathjs.mean(xs), n)}±${mathjs.round(mathjs.std(xs), n)}`);
}

export function msToS(entry: Entry): Entry {
    return mapEntry(entry, (n) => normalize(n / 1000));
}

export function mixed(entries: Entry[]): Entry {
    const [ entry ] = entries;
    return entries.every((e) => e === entry) ? entry : undefined;
}

function mapEntry(entry: Entry, f: (_: number) => Entry): Entry {
    const num = entryToNumber(entry);
    return num !== undefined ? f(num) : undefined;
}

function entryToNumber(entry: Entry): number | undefined {
    const num = parseInt(entry as any);
    return Number.isFinite(num) ? num : undefined;
}

function mapEntries(entries: Entry[], f: (_: number[]) => Entry): Entry {
    const filtered = entries.map(entryToNumber).filter((n) => n !== undefined) as number[];
    return filtered.length > 0 ? f(filtered) : undefined;
}
