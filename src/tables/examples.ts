import { IData } from "../data";
import { perExampleGroup } from "../examples";
import { ITableSpec } from "../specs";
import { mean, normalize } from "../utils";

type field = "spec" | "n" | "traces" | "states" | "txs" | "pos" | "neg";

export default async function(data: IData): Promise<ITableSpec<field>> {
    const name = "examples";
    const columns = { spec: "l", n: "l", traces: "l", states: "l", txs: "l", pos: "l", neg: "l" };
    const rows = await perExampleGroup(async (group) => {
        const { name: spec, members: { length: n } } = group;
        const examples = data.forGroup(group).from("examples");
        const traces = normalize(mean(await examples.get((({ traces: { length } }) => length)).values()));
        const states = normalize(mean(await examples.get((({ states: { length } }) => length)).values()));
        const txs = normalize(mean(await examples.get((({ transactionHistory: { length } }) => length)).values()));
        const pos = normalize(mean(await examples.get((({ examples: { positive: { length } }}) => length)).values()));
        const neg = normalize(mean(await examples.get((({ examples: { negative: { length } }}) => length)).values()));
        return { spec, n, traces, states, txs, pos, neg };
    });
    return { name, columns, rows };
}
