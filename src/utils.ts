import * as mathjs from "mathjs";
import * as Latex from "./latex";
import { Entry } from "./specs";
import * as E from "./specs";

export function normalize(entry: number, n = 1): number {
    return mathjs.round(entry, n) as number;
}

export function mean(entries: number[], n = 1): number {
    return mathjs.round(mathjs.mean(entries), n) as number;
}

export function dist(entries: Entry[], n: number = 1) {
    return E.applyAry<string>({
        booleanFn: nonNumericDist,
        defaultValue: Latex.empty,
        entries,
        numberFn: (ns) => numericDist(ns, entries.length),
        stringFn: nonNumericDist,
    });
}

function numericDist(entries: number[], expected: number, n = 1) {
    const mean = mathjs.round(mathjs.mean(entries), n) as number;
    const std = mathjs.round(mathjs.std(entries), n) as number;
    const { length } = entries;
    const count = length === expected ? undefined : length;
    return Latex.meanAndStd(mean, std, count);
}

function nonNumericDist(entries: Array<string | boolean>, n = 1) {
    const index = (i: string | boolean) => i === true ? "\\textsf{T}" : i === false ? "\\textsf{F}" : i;
    const counts = Object.fromEntries(entries.map((e) => [index(e), 0]));
    entries.forEach((e) => counts[index(e)]++);
    return Object.entries(counts).sort().map(([k, v]) => `${k}$\\times$${v}`).join(", ");
}

export function msToS(entry: Entry): number | undefined {
    return E.apply<number | undefined>({
        entry,
        defaultValue: undefined,
        numberFn: (n: number) => n / 1000,
    });
}

export function mixed(entries: Entry[]): Entry {
    const [ entry ] = entries;
    return entries.every((e) => e === entry) ? entry : undefined;
}

export function skeletonOfExpression(expression: string): string {
    const skeleton = expression
        .replace(/\band\b/g, "&")
        .replace(/[\w$]+/g, "")
        .replace(/\(\s*([=+])\s*\)/g, "{(\\!{$1}\\!)}")
        .replace(/&/g, "\\land");
    return `$${skeleton}$`;
}

export function countTerms(expression: string): number | undefined {
    const terms = expression.match(/(?=\((?!and|or).*\))/g);
    return terms === null ? undefined : terms.length;
}

export function countVerifiedFunctions(lines: string[]): number | undefined {
    return validVerifierResults(lines)
        ? lines.filter((line) => line.match(/^\S+: OK$/)).length
        : undefined;
}

export function countUnVerifiedFunctions(lines: string[]): number | undefined {
    return validVerifierResults(lines)
        ? lines.filter((line) => line.match(/^\S+: (ERROR|SKIPPED)$/)).length
        : undefined;
}

export function validVerifierResults(lines: string[]): boolean {
    return lines.length > 0
        && lines.filter((line) => line.match(/Error while running compiler, details:/)).length === 0;
}
