import { ColumnSpec, ITableSpec, Row, Entry } from "./specs";

export function latexDocument(tableNames: string[]): string {
    const lines: string[] = [];
    lines.push("\\documentclass{article}");
    lines.push("\\usepackage{booktabs}");
    lines.push("\\usepackage[margin=1cm]{geometry}");
    lines.push("\\begin{document}");

    for (const name of tableNames) {
        lines.push("\\begin{table}[h]");
        lines.push(`\\caption{${name} table}`);
        lines.push(`\\input ${name}-table.tex`);
        lines.push("\\end{table}");
    }
    lines.push("\\end{document}");
    return lines.join("\n");
}

export function latexTable(spec: ITableSpec<any>): string {
    const { name, columns, rows } = spec;
    const entries = Object.keys(columns).map<[string, string]>((k) => [k, k]);
    const header = Object.fromEntries(entries);

    const lines: string[] = [];
    lines.push(`%% ${name} table`)
    lines.push(`%% NOTE: this table is generated automatically; do not edit.`);
    lines.push(`\\begin{tabular}{${latexColumnSpec(columns)}}`);
    lines.push(`\\toprule`);

    lines.push(`${latexRow(header)} \\\\`);
    lines.push(`\\cmidrule(lr){1-${Object.keys(columns).length}}`);

    for (const row of rows) {
        lines.push(`${latexRow(row)} \\\\`);
    }

    lines.push(`\\bottomrule`);
    lines.push(`\\end{tabular}`);
    lines.push();
    return lines.join("\n");
}

function latexColumnSpec(spec: ColumnSpec<any>) {
    return Object.values(spec).join("");
}

function latexRow(row: Row<any>) {
    return Object.values(row).map(latexEntry).join(" & ");
}

function latexEntry(entry: Entry) {
    return entry === undefined ? empty : entry.toString();
}

export const empty = "-";

export function meanAndStd(mean: number, std: number, count: number) {
    return `${mean} $\\!\\pm\\!$ ${std}, ${count}`;
}
