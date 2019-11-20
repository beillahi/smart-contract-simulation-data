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
