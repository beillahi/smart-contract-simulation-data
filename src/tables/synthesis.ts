import { IData } from "../data";
import { perExampleGroup } from "../examples";
import { Entry, ITableSpec } from "../specs";
import { mean, normalize } from "../utils";

type field = "spec" | "n" | "pos" | "neg" | "fields" | "seeds" | "fts" | "queries" | "txs";

export default async function(data: IData): Promise<ITableSpec<field>> {
    const name = "synthesis";
    const columns = {
        spec: "l", n: "l", pos: "l", neg: "l", fields: "l", seeds: "l", fts: "l", queries: "l", txs: "l" };
    const rows = await perExampleGroup(async (group) => {
        const { name: spec, members: { length: n } } = group;

        const synthesis = data.forGroup(group).from("synthesis");
        const synthesisInput = data.forGroup(group).from("synthesisInput");
        const evaluatorQueries = data.forGroup(group).from("evaluatorQueries");
        const evaluator = data.forGroup(group).from("evaluator");
        const nm = (xs: Entry[]) => normalize(mean(xs));

        const pos = nm(await synthesisInput.get((({ examples: { positive: { length } }}) => length)).values());
        const neg = nm(await synthesisInput.get((({ examples: { negative: { length } }}) => length)).values());
        const fields = nm(await synthesisInput.get((({ expressions: { length } }) => length)).values());
        const seeds = nm(await synthesisInput.get((({ features: { length } }) => length)).values());
        const fts = nm(await synthesis.get((({ features: { length } }) => length)).values());
        const queries = nm(await evaluatorQueries.get((({ length }) => length)).values());
        const txs = nm(await evaluator.get((({ length }) => length)).values());

        return { spec, n, pos, neg, fields, seeds, fts, queries, txs };
    });
    return { name, columns, rows };
}
