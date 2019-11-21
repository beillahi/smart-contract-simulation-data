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
        numberFn: numericDist,
        stringFn: nonNumericDist,
    });
}

function numericDist(entries: number[], n = 1) {
    const mean = mathjs.round(mathjs.mean(entries), n) as number;
    const std = mathjs.round(mathjs.std(entries), n) as number;
    const count = entries.length;
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
        .replace(/&/g, "\\land");
    return `$${skeleton}$`;
}

export function countTerms(expression: string): number | undefined {
    const terms = expression.match(/(?=\((?!and|or).*\))/g);
    return terms === null ? undefined : terms.length;
}

export function countVerifiedFunctions(lines: string[]): number {
    return lines.filter((line) => line.match(/^\S+: OK$/)).length;
}

export function countUnVerifiedFunctions(lines: string[]): number {
    return lines.filter((line) => line.match(/^\S+: ERROR$/)).length;
}
