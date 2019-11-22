import { IData } from "../data";
import { perExampleGroup } from "../examples";
import { ITableSpec } from "../specs";
import { countTerms, dist, msToS } from "../utils";

const name = "synthesis";
const columns = { contracts: "l", fields: "l", seeds: "l", terms: "l", queries: "l", time: "l" };

export default async function(data: IData): Promise<ITableSpec<keyof typeof columns>> {
    const rows = await perExampleGroup(async (group) => {
        const { name: g, members: { length: n } } = group;
        const contracts = `${g} $\\times$ ${n}`;

        const synthesis = data.forGroup(group).from("synthesis");
        const synthesisInput = data.forGroup(group).from("synthesisInput");
        const evaluatorQueries = data.forGroup(group).from("evaluatorQueries");
        const metrics = data.forGroup(group).from("metrics");

        const fields = dist(await synthesisInput.get((({ expressions: { length } }) => length)).values());
        const seeds = dist(await synthesisInput.get((({ features: { length } }) => length)).values());
        const terms = dist(await synthesis.get((({ output: [ sim ] }) => countTerms(sim))).values());
        const queries = dist(await evaluatorQueries.get((({ length }) => length)).values());
        const time = dist((await metrics.get(({ synthesisTime: { value } }) => value).values()).map(msToS));
        return { contracts, fields, seeds, terms, queries, time };
    });
    return { name, columns, rows };
}
