import { IData } from "../data";
import { perExampleGroup } from "../examples";
import { ITableSpec } from "../specs";
import { countTerms, dist } from "../utils";

const name = "synthesis";
const columns = {
    spec: "l", n: "l", pos: "l", neg: "l", fields: "l", seeds: "l", terms: "l", queries: "l", txs: "l"
};

export default async function(data: IData): Promise<ITableSpec<keyof typeof columns>> {
    const rows = await perExampleGroup(async (group) => {
        const { name: spec, members: { length: n } } = group;

        const synthesis = data.forGroup(group).from("synthesis");
        const synthesisInput = data.forGroup(group).from("synthesisInput");
        const evaluatorQueries = data.forGroup(group).from("evaluatorQueries");
        const evaluator = data.forGroup(group).from("evaluator");

        const pos = dist(await synthesisInput.get((({ examples: { positive: { length } }}) => length)).values());
        const neg = dist(await synthesisInput.get((({ examples: { negative: { length } }}) => length)).values());
        const fields = dist(await synthesisInput.get((({ expressions: { length } }) => length)).values());
        const seeds = dist(await synthesisInput.get((({ features: { length } }) => length)).values());
        const terms = dist(await synthesis.get((({ output: [ sim ] }) => countTerms(sim))).values());
        const queries = dist(await evaluatorQueries.get((({ length }) => length)).values());
        const txs = dist(await evaluator.get((({ length }) => length)).values());

        return { spec, n, pos, neg, fields, seeds, terms, queries, txs };
    });
    return { name, columns, rows };
}
