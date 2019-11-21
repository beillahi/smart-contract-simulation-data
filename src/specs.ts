
export type Row<T extends string> = {
    [key in T]: Entry;
};

export type Entry = string | number | boolean | undefined;

export type ColumnSpec<T extends string> = Row<T>;

export interface ITableSpec<T extends string> {
    name: string;
    columns: ColumnSpec<T>;
    rows: Array<Row<T>>;
}

export function toNumber(entry: Entry): number | undefined {
    const num = parseInt(entry as any);
    return Number.isFinite(num) ? num : undefined;
}

export function toBoolean(entry: Entry): boolean | undefined {
    const s = String(entry).toLowerCase();
    return s === "true"
        ? true
        : s === "false"
        ? false
        : undefined;
}

export function toString(entry: Entry): string | undefined {
    return entry === undefined ? undefined : String(entry);
}

interface IApplyParams<T> {
    defaultValue: T;
    entry: Entry;
    numberFn?(entry: number): T;
    stringFn?(entry: string): T;
    booleanFn?(entry: boolean): T;
}

export function apply<T>(params: IApplyParams<T>): T | undefined {
    const { defaultValue, entry } = params;
    const { numberFn = (_: number) => defaultValue } = params;
    const { stringFn = (_: string) => defaultValue } = params;
    const { booleanFn = (_: boolean) => defaultValue } = params;

    if (typeof(entry) === "number") {
        return numberFn(entry);
    }

    if (typeof(entry) === "string") {
        return stringFn(entry);
    }

    if (typeof(entry) === "boolean") {
        return booleanFn(entry);
    }

    return defaultValue;
}

interface IApplyAryParams<T> {
    defaultValue: T;
    entries: Entry[];
    numberFn?(entry: number[]): T;
    stringFn?(entry: string[]): T;
    booleanFn?(entry: boolean[]): T;
}

export function applyAry<T>(params: IApplyAryParams<T>): T {
    const { defaultValue } = params;
    const { numberFn = (_: number[]) => defaultValue } = params;
    const { stringFn = (_: string[]) => defaultValue } = params;
    const { booleanFn = (_: boolean[]) => defaultValue } = params;
    const entries = params.entries.filter((e) => e !== undefined);
    const [ first ] = entries;
    const type = typeof(first);

    if (entries.some((e) => typeof(e) !== type)) {
        throw Error(`Non-uniform entries.`);
    }

    if (type === "number") {
        return numberFn(entries as number[]);
    }

    if (type === "string") {
        return stringFn(entries as string[]);
    }

    if (type === "boolean") {
        return booleanFn(entries as boolean[]);
    }

    return defaultValue;
}

export function mapNumber(entry: Entry, f: (_: number) => Entry): Entry {
    const num = toNumber(entry);
    return num !== undefined ? f(num) : undefined;
}

export function mapNumbers(entries: Entry[], f: (_: number[]) => Entry): Entry {
    const filtered = entries.map(toNumber).filter((n) => n !== undefined) as number[];
    return filtered.length > 0 ? f(filtered) : undefined;
}
